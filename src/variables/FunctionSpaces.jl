module FunctionSpaces

using LinearAlgebra
using ..QuadratureTemplates

include("./function_spaces/QuadFunctionSpace.jl")

export function_space_factory
export J
export detJ
export ∇Nₓ

function function_space_factory(element_type::String)
    if element_type == "QUAD4"
        Nξ(x::Vector{Float64}) = quad4_calculate_shape_function_values(x)
        ∇Nξ(x::Vector{Float64}) = quad4_calculate_shape_function_gradients(x)
        return Nξ, ∇Nξ
    else
        throw(AssertionError("Unsupported element type"))
    end
end

J(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = transpose(∇Nξ) * X
detJ(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = det(J(X, ∇Nξ))
∇Nₓ(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = transpose(inv(J(X, ∇Nξ)) * transpose(∇Nξ))

end
