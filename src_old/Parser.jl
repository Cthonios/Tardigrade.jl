"""
`Parser`

Module for holding the different methods for parsing.
"""
module Parser

export Settings

import YAML: load_file

"""
`Settings`

struct to store the various blocks of an input deck in yaml format

Currently this stores a container for the mesh settings, and a container
for the sections settings
"""
struct Settings
    mesh::Dict{Any,Any}
    sections::Vector{Dict{Any,Any}}
    """
    `Settings(input_file_name::String)`

    `input_file_name` should be self explanatory, expected to be
    in absolute path
    """
    function Settings(input_file_name::String)
        yaml_dict = parse_input_file(input_file_name)
        mesh = yaml_dict["mesh"]
        sections = yaml_dict["sections"]
        return new(mesh, sections)
    end
end

"""
`parse_input_file(input_file_name::String)`

`input_file_name` should be self explanatory
"""
function parse_input_file(input_file_name::String)
    yaml_dict = load_file(input_file_name)
    return yaml_dict
end

end # module