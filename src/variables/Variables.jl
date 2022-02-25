module Variables

using Parameters

abstract type AbstractVariable end

@with_kw struct Variable <: AbstractVariable
    name::String
    function_space_family::String = "lagrange"
    function_space_order::Int8 = 1
    quadrature_order::Int8 = 1
    blocks::Array{Int64,1}
end

function initialize_variable(input_settings)
    return Variable(name=input_settings["variable_name"],
                    function_space_family=input_settings["function space family"],
                    function_space_order=input_settings["function space order"],
                    quadrature_order=input_settings["quadrature order"],
                    blocks=input_settings["blocks"])
end

function update_variables!(input_settings, variables)
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
