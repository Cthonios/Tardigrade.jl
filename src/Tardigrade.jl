module Tardigrade

include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("quadrature_templates/QuadratureTemplates.jl")
include("function_spaces/FunctionSpaces.jl")

# using .Mesh : initialize_mesh

function setup_mesh(input_settings)
    mesh = Mesh.initialize_mesh(Parser.parse_mesh_block(input_settings))
    return mesh
end

function setup_variables(input_settings)
    variable_block = Parser.parse_variables_block(input_settings)
end

function tardigrade()
    println("Tardigrade!!!")
    input_file = ARGS[1]
    @show input_file
    input_settings = Parser.read_input_file(input_file)

    @time mesh = setup_mesh(input_settings)
    @time mesh = setup_mesh(input_settings)

    variables = setup_variables(input_settings)
    # println(mesh)
end

end # module
