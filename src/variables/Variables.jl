module Variables

include("./QuadratureTemplates.jl")

using Parameters

abstract type AbstractVariable end

# Needs to contain all the stuff to build shape functions
# and store the values, make it serial at first then parallel eventually
#
mutable struct Variable <: AbstractVariable
    name::String
    id::Int64
    values::Vector{Float64}
    quadrature::QuadratureTemplates.QuadraturePoints
    # function_space::FunctionSpace
    function Variable(name::String, id::Int64, 
                      values::Vector{Float64}, 
                      quadrature::QuadratureTemplates.QuadraturePoints)
        return new(name, id, values, quadrature)
    end
end

function initialize_variables(variables_blocK::Vector{Dict{Any, Any}})
    message = rpad("Setting up variables...", 48)
    print(message)

    for variable_block in variables_blocK
        @show variable_block
    end
end

end
