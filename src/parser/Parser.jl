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
        for variable in variables_block
            println(variable["variable name"])
            println(variable["quadrature order"])
        end
    catch error
        if isa(error, KeyError)
            msg = "Error in variables block\nCorrect syntax is...\n\n\n"
            msg = msg * "variables:\n  -variable name: <str>\n"
            msg = msg * "   quadrature_order: <int>\n"
            msg = msg * "   blocks: <list<int>>\n"
            msg = msg * "  -variable name: <str>\n"
            msg = msg * "   quadrature_order: <int>\n"
            msg = msg * "   blocks: <list<int>>\n"
            msg = msg * "  ... etc. ...\n\n"
            throw(AssertionError(msg))
        end
    end
    return input_settings["variables"]
end

function parse_kernels_block(input_settings)
    return input_settings["kernels"]
end

end
