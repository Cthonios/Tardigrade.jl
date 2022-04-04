module Tardigrade

include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("variables/Variables.jl")

import Tardigrade.Parser: read_input_file, 
                          parse_mesh_block, 
                          parse_variables_block,
                          parse_kernels_block,
                          parse_boundary_conditions_block

import Tardigrade.Mesh: initialize_mesh
import Tardigrade.Variables: initialize_variables

function tardigrade(input_file::String)
    @show input_file
    input_settings = Parser.read_input_file(input_file)

    @time mesh = initialize_mesh(parse_mesh_block(input_settings))
    @time mesh = initialize_mesh(parse_mesh_block(input_settings))

    @time initialize_variables(parse_variables_block(input_settings))
    @time initialize_variables(parse_variables_block(input_settings))
end

end # module
