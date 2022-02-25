include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("variables/Variables.jl")
include("quadrature_templates/QuadratureTemplates.jl")
include("function_spaces/FunctionSpaces.jl")
include("boundary_conditions/BoundaryConditions.jl")

# using QuadratureTemplates
# import Tardigrade.QuadratureTemplates

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

# function setup_reference_elements(mesh, variables)
#     reference_elements =
#     Array{FunctionSpaces.ReferenceElement}(undef, size(variables, 1))
#     for m = 1:size(variables, 1)
#         reference_elements =
#         FunctionSpaces.reference_element_factory("QUAD4", variables[m].function_space_order)
#     end
#     return reference_elements
# end

function setup_function_spaces(mesh, variables)

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
    @time mesh = setup_mesh(input_settings)

    println("Setting up variables...")
    @time variables = setup_variables(input_settings)
    @time variables = setup_variables(input_settings)

    println("Setting up quadrature...")
    @time quadrature = setup_quadrature(mesh, variables)
    @time quadrature = setup_quadrature(mesh, variables)

    println("Setting up function space reference elements...")
    @time reference_elements = setup_reference_elements(mesh, variables)
    @time reference_elements = setup_reference_elements(mesh, variables)

    println("Setting up boundary conditions...")
    @time boundary_conditions = setup_boundary_conditions(input_settings, mesh, variables)
    @time boundary_conditions = setup_boundary_conditions(input_settings, mesh, variables)
end

poisson_equation()
