module Tardigrade

include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("variables/Variables.jl")
include("kernels/Kernels.jl")
include("quadrature_templates/QuadratureTemplates.jl")
include("function_spaces/FunctionSpaces.jl")
include("boundary_conditions/BoundaryConditions.jl")
include("post_processor/PostProcessor.jl")

import Tardigrade.Parser.read_input_file
import Tardigrade.Parser.parse_mesh_block
import Tardigrade.Parser.parse_variables_block
import Tardigrade.Parser.parse_kernels_block
import Tardigrade.Parser.parse_boundary_conditions_block

import Tardigrade.Mesh.initialize_mesh
import Tardigrade.QuadratureTemplates.quadrature_factory
# import Tardigrade.FunctionSpaces
# import Tardigrade.FunctionSpaces.function_space_factory
import Tardigrade.Kernels.kernel_factory
import Tardigrade.BoundaryConditions.boundary_condition_factory

import Tardigrade.BoundaryConditions.update_bcs_solution!
import Tardigrade.BoundaryConditions.update_bcs_residual_and_tangent!

using .FunctionSpaces

# export Tardigrade.FunctionSpaces

function setup_mesh(input_settings)
    message = rpad("Setting up mesh...", 48)
    print(message)
    mesh = initialize_mesh(parse_mesh_block(input_settings))
    return mesh
end

function setup_variables(input_settings)
    message = rpad("Setting up variables...", 48)
    print(message)
    variables_block = parse_variables_block(input_settings)
    variables = Variables.initialize_variables(variables_block)
    return variables
end

function setup_quadrature(mesh, variables)
    message = rpad("Setting up quadrature...", 48)
    print(message)
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
    message = rpad("Setting up function spaces...", 48)
    print(message)
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

function setup_kernels(input_settings)
    message = rpad("Setting up kernels...", 48)
    print(message)
    kernels_block = parse_kernels_block(input_settings)
    return kernel_factory(kernels_block[1])
end

function setup_boundary_conditions(input_settings, mesh, variables)
    message = rpad("Setting up boundary conditions...", 48)
    print(message)
    bc_input_settings = Parser.parse_boundary_conditions_block(input_settings)
    boundary_conditions = Array{Any}(undef, size(bc_input_settings, 1))
    for (n, bc) in enumerate(bc_input_settings)
        boundary_conditions[n] =
        BoundaryConditions.boundary_condition_factory(bc, mesh)
    end
    return boundary_conditions
end

# function tardigrade()
#     println("Tardigrade!!!")
#     input_file = ARGS[1]
#     @show input_file
#     input_settings = Parser.read_input_file(input_file)
#
#     @time mesh = setup_mesh(input_settings)
#     @time mesh = setup_mesh(input_settings)
#
#     @time variables = setup_variables(input_settings)
#     @time variables = setup_variables(input_settings)
#     # println(mesh)
# end

end # module
