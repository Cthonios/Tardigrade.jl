module Parser

using YAML

function read_input_file(input_file)
    input_settings = YAML.load_file(input_file)
    return input_settings
end

function parse_input_settings(input_settings)
    mesh = parse_mesh_block(input_settings)
    variables = parse_variables_block(input_settings)
    kernels = parse_kernels_block(input_settings)
    @show mesh
    @show variables
    @show kernels
end

function parse_mesh_block(input_settings)
    # TODO: maybe add a simple hook to cubit
    # TODO: to build simple meshes like squares/cubes
    # TODO: eventually need to have parallel support but that's way in the future
    try
        mesh_file_name = input_settings["mesh"]["file name"]
        return mesh_file_name
    catch error
        if isa(error, KeyError)
            msg = "Error in mesh block\nCorrect syntax is...\n\n\n"
            msg = msg * "mesh:\n  file name: mesh_file_name.g\n\n\n"
            throw(AssertionError(msg))
        end
    end
end

function parse_variables_block(input_settings)
    try
        variables_block = input_settings["variables"]
        for key in keys(input_settings["variables"])
            # input_settings[key]["variable name"]
            # input_settings[key]["function space family"]
            # @assert input_settings[key]["function space order"] > 0
            # @assert input_settings[key]["quadrature order"] > 0
            # @assert size(input_settings[key]["blocks"]) > 0
        end
        return variables_block
    catch error
        if isa(error, KeyError)
            msg = "Error in variables block\nCorrect syntax is...\n\n\n"
            msg = msg * "variables:\n  -variable name: <str>\n"
            msg = msg * "   function space family: <str>\n"
            msg = msg * "   function space order: <int>\n"
            msg = msg * "   quadrature order: <int>\n"
            msg = msg * "   blocks: <list<int>>\n"
            msg = msg * "  -variable name: <str>\n"
            msg = msg * "   function space family: <str>\n"
            msg = msg * "   function space order: <int>\n"
            msg = msg * "   quadrature order: <int>\n"
            msg = msg * "   blocks: <list<int>>\n"
            msg = msg * "  ... etc. ...\n\n"
            throw(AssertionError(msg))
        end
    end
end

function parse_kernels_block(input_settings)
    return input_settings["kernels"]
end

end
