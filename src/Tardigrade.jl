module Tardigrade

include("parser/Parser.jl")
include("mesh/Mesh.jl")
include("sections/Sections.jl")
# include("variables/Variables.jl")

import Tardigrade.Parser: read_input_file, 
                          parse_mesh_block, 
                          parse_variables_block,
                          parse_sections_block,
                          parse_kernels_block,
                          parse_boundary_conditions_block

import Tardigrade.Mesh: initialize_mesh
import Tardigrade.Sections: Section, initialize_sections

function tardigrade(input_file::String)
    @show input_file
    input_settings = Parser.read_input_file(input_file)

    @time mesh = initialize_mesh(parse_mesh_block(input_settings))
    @time mesh = initialize_mesh(parse_mesh_block(input_settings))

    @time initialize_sections(parse_sections_block(input_settings), mesh)
    @time initialize_sections(parse_sections_block(input_settings), mesh)
end

end # module
