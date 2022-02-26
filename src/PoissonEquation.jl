include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("variables/Variables.jl")
include("quadrature_templates/QuadratureTemplates.jl")
include("function_spaces/FunctionSpaces.jl")
include("boundary_conditions/BoundaryConditions.jl")
include("kernels/Kernels.jl")
include("post_processor/PostProcessor.jl")

using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Printf

function setup_mesh(input_settings)
    mesh = Mesh.initialize_mesh(Parser.parse_mesh_block(input_settings))
    return mesh
end

function setup_variables(input_settings)
    variables_block = Parser.parse_variables_block(input_settings)
    variables = Variables.initialize_variables(variables_block)
    return variables
end

function setup_quadrature(mesh, variables)
    quadrature_rules =
    Array{QuadratureTemplates.QuadraturePoints}(undef, size(variables, 1))  # limitation here that all blocks have the same rule
    for m = 1:size(variables, 1)
        # TODO: make below general to hook up other elements
        quadrature_rules[m] =
        QuadratureTemplates.quadrature_factory("QUAD4", variables[m].quadrature_order)
        # for n = 1:size(mesh.blocks, 1)
        #
        #     # TODO: need serious checking on block vs. variable
        #     # TODO: shape functions and quadrature rules
        #     #
        #     println(mesh.blocks[n])
        #     # quadrature_rules[m, n] = quadrature_factory(mesh.blocks)
        # end
    end
    return quadrature_rules
end

function setup_function_space_methods(mesh, variables)
    Nξ_methods =
    Array{Any}(undef, size(variables, 1))
    ∇Nξ_methods =
    Array{Any}(undef, size(variables, 1))
    for m = 1:size(variables, 1)
        Nξ_methods[m], ∇Nξ_methods[m] =
        FunctionSpaces.function_space_factory("QUAD4")
    end
    return Nξ_methods, ∇Nξ_methods
end

function setup_kernel(input_settings)
    kernels_block = Parser.parse_kernels_block(input_settings)
    println(kernels_block)
    return Kernels.kernel_factory(kernels_block[1])
end

function setup_boundary_conditions(input_settings, mesh, variables)
    bc_input_settings = Parser.parse_boundary_conditions_block(input_settings)

    boundary_conditions = Array{Any}(undef, size(bc_input_settings, 1))
    for (n, bc) in enumerate(bc_input_settings)
        boundary_conditions[n] =
        BoundaryConditions.boundary_condition_factory(bc, mesh)
    end
    return boundary_conditions
end

function poisson_equation()
    println("simple example for poisson equation")
    input_file = ARGS[1]
    @show input_file
    input_settings = Parser.read_input_file(input_file)

    println("Setting up mesh...")
    @time mesh = setup_mesh(input_settings)
    println("Setting up variables...")
    @time variables = setup_variables(input_settings)
    println("Setting up quadrature...")
    @time quadrature = setup_quadrature(mesh, variables)
    println("Setting up function spaces...")
    @time Nξ_methods, ∇Nξ_methods = setup_function_space_methods(mesh, variables)
    println("Setting up kernels...")
    @time kernel = setup_kernel(input_settings)
    kernels = [kernel]

    println("Setting up boundary conditions...")
    @time boundary_conditions = setup_boundary_conditions(input_settings, mesh, variables)
    # @show boundary_conditions

    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    # @time u = solve(mesh, boundary_conditions, quadrature, Nξ_methods, ∇Nξ_methods)

    mesh_file_name = Parser.parse_mesh_block(input_settings)
    @time exo = PostProcessor.copy_mesh_to_exodus_database(mesh_file_name)
    @time PostProcessor.setup_exodus_variable_fields(exo)
    @time PostProcessor.setup_initial_time_step(exo)
    @time PostProcessor.write_exodus_time_step(exo, u)
    @time PostProcessor.close_exodus_database(exo)
end

function solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    println("solving")

    tolerance = 1000.0
    coords = mesh.coords
    conn = mesh.blocks[1].connectivity
    # u = ones(Float64, mesh.Nₙ)
    u = ones(Float64, mesh.Nₙ)
    while tolerance > 1.0e-12

        # update bcs
        #
        @simd for bc in boundary_conditions
            @simd for node in bc.nodes
                u[node] = bc.value
            end
        end

        R = zeros(Float64, mesh.Nₙ)
        K = zeros(Float64, mesh.Nₙ, mesh.Nₙ)
        # K = spzeros(Float64, mesh.Nₙ, mesh.Nₙ)
        # K =

        R_e = zeros(Float64, 4)
        K_e = zeros(Float64, 4, 4)
        local_coords = zeros(Float64, 4, 2)
        local_u = zeros(Float64, 4)

        # calculate residual
        #
        @simd for e = 1:mesh.Nₑ
            local_nodes = conn[4*(e - 1) + 1:4*e]
            local_coords .= zero(Float64)
            @simd for i=1:4
                @simd for j=1:2
                    local_coords[i, j] = mesh.coords[local_nodes[i], j]
                end
            end

            local_u .= zero(Float64)
            @simd for i=1:4
                local_u[i] = u[local_nodes[i]]
            end

            R_e .= zero(Float64)
            K_e .= zero(Float64)
            kernels[1](local_coords, local_u, quadrature[1],
            Nξ_methods[1], ∇Nξ_methods[1], R_e, K_e)

            @simd for i=1:4
                R[local_nodes[i]] += R_e[i]
            end
            @simd for j=1:4
                @simd for i=1:4
                    K[local_nodes[i], local_nodes[j]] += K_e[i, j]
                end
            end
        end

        # update bcs
        #
        @simd for bc in boundary_conditions
            @simd for node in bc.nodes
                R[node] = 0.0
                K[node, node] = 1.0
            end
        end

        K = sparse(K)

        # Δu = K \ R
        Δu = cg(K, R)
        u = u - Δu

        # check residual
        #
        @printf("|R| = %s\t|Δu| = %s\n", norm(R), norm(Δu))

        if norm(R) < 1.0e-12
            break
        end

        if norm(Δu) < 1.0e-12
            break
        end
    end

    return u
end

poisson_equation()
