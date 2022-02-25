module Variable

abstract type AbstractVariable end

struct Variable <: AbstractVariable
    name::String
    quadrature_order::Int8
    blocks::Array{Int64,1}
end

function initialize_variable(input_settings)
    variable_name = input_settings["variable name"]
    quadrature_order = input_settings["quadrature order"]
    blocks = input_settings["blocks"]
    return Variable(variable_name, quadrature_order, blocks)
end
