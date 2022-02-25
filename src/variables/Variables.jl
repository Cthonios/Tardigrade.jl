module Variables

abstract type AbstractVariable end

struct Variable <: AbstractVariable
    name::String
    function_space_family::String
    function_space_order::Int8
    quadrature_order::Int8
    blocks::Array{Int64,1}
end

function initialize_variable(input_settings)
    println(input_settings)

    return Variable(input_settings["variable name"],
                    input_settings["function space family"],
                    input_settings["function space order"],
                    input_settings["quadrature order"],
                    input_settings["blocks"])
end

function update_variables!(input_settings, variables)
    println(keys(input_settings))
    for (n, key) in enumerate(keys(input_settings))
        variables[n] = initialize_variable(input_settings[key])
    end
    return variables
end

function initialize_variables(input_settings)
    variables = Array{Variable,1}(undef, length(input_settings))
    update_variables!(input_settings, variables)
end

end
