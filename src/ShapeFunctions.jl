module ShapeFunctions

export AbstractShapeFunction
export LagrangeShapeFunction
export J
export detJ
export map_∇φ_ξ

abstract type AbstractShapeFunction end

struct LagrangeShapeFunction <: AbstractShapeFunction
    φ::Function
    ∇φ::Function
end

function LagrangeShapeFunction(element_type::String)
    values_method_name = Symbol(lowercase(element_type) * "_shape_function_values")
    grads_method_name = Symbol(lowercase(element_type) * "_shape_function_gradients")
    
    values_method = getfield(ShapeFunctions, values_method_name)
    grads_method = getfield(ShapeFunctions, grads_method_name)
    return LagrangeShapeFunction(values_method, grads_method)
end

J(∇φ_ξ::Matrix{T}, X::Matrix{T}) where {T <: Real} = transpose(∇φ_ξ) * X
# JxW(∇φ_ξ::Matrix{T})
detJ(∇φ_ξ::Matrix{T}, X::Matrix{T}) where {T <: Real} = det(J(∇φ_ξ, X))
map_∇φ_ξ(∇φ_ξ::Matrix{T}, X::Matrix{T}) where {T <: Real} = transpose(inv(J(∇φ_ξ, X)) * transpose(∇φ_ξ)) 


# actual element implementations below
#
#
function quad4_shape_function_values(ξ::Vector{T}) where {T <: Real}
    φ = zeros(T, 4)
    φ[1] = 0.25 * (1.0 - ξ[1]) * (1.0 - ξ[2])
    φ[2] = 0.25 * (1.0 + ξ[1]) * (1.0 - ξ[2])
    φ[3] = 0.25 * (1.0 + ξ[1]) * (1.0 + ξ[2])
    φ[4] = 0.25 * (1.0 - ξ[1]) * (1.0 + ξ[2])
    return φ
end

function quad4_shape_function_gradients(ξ::Vector{T}) where {T <: Real}
    ∇φ_ξ = zeros(T, 4, 2)
    ∇φ_ξ[1, 1] = -0.25 * (1.0 - ξ[2])
    ∇φ_ξ[1, 2] = -0.25 * (1.0 - ξ[1])
    #
    ∇φ_ξ[2, 1] =  0.25 * (1.0 - ξ[2])
    ∇φ_ξ[2, 2] = -0.25 * (1.0 + ξ[1])
    #
    ∇φ_ξ[3, 1] = 0.25 * (1.0 + ξ[2])
    ∇φ_ξ[3, 2] = 0.25 * (1.0 + ξ[1])
    #
    ∇φ_ξ[4, 1] = -0.25 * (1.0 + ξ[2])
    ∇φ_ξ[4, 2] =  0.25 * (1.0 - ξ[1])
    return ∇φ_ξ
end

end # module