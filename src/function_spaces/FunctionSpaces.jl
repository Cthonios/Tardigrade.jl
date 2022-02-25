module FunctionSpaces
include("./QuadFunctionSpace.jl")
using LinearAlgebra
using ..QuadratureTemplates

function function_space_factory(element_type::String)
    if element_type == "QUAD4"
        one = 1
        Nξ(x::Vector{Float64}) = quad4_calculate_shape_function_values(one, x)
        ∇Nξ(x::Vector{Float64}) = quad4_calculate_shape_function_gradients(one, x)
        return Nξ, ∇Nξ
    else
        throw(AssertionError("Unsupported element type"))
    end
end

J(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = transpose(∇Nξ) * X
detJ(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = det(J(X, ∇Nξ))
∇Nₓ(X::Matrix{Float64}, ∇Nξ::Matrix{Float64}) = transpose(inv(J(X, ∇Nξ)) * transpose(∇Nξ))

end
