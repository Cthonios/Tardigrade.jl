"""
    ShapeFunctions
A module for working with FEM shape functions.
"""
module ShapeFunctions

export AbstractShapeFunction
export LagrangeShapeFunction
export J
export detJ
export map_∇φ_ξ

using LinearAlgebra

"""
    AbstractShapeFunction
Parent type of all shape functions.
"""
abstract type AbstractShapeFunction end

"""
    LagrangeShapeFunction
Container for shape function methods on the master element.
"""
struct LagrangeShapeFunction <: AbstractShapeFunction
    φ::Function
    φ!::Function
    ∇φ_ξ::Function
    ∇φ_ξ!::Function
end

"""
    LagrangeShapeFunction(element_type::String)
Init method for LagrangeShapeFunction.
"""
function LagrangeShapeFunction(element_type::String)
    values_method_name = Symbol(lowercase(element_type) * "_shape_function_values")
    grads_method_name = Symbol(lowercase(element_type) * "_shape_function_gradients")
    values_method_name! = Symbol(lowercase(element_type) * "_shape_function_values!")
    grads_method_name! = Symbol(lowercase(element_type) * "_shape_function_gradients!")
    values_method = getfield(ShapeFunctions, values_method_name)
    grads_method = getfield(ShapeFunctions, grads_method_name)
    values_method! = getfield(ShapeFunctions, values_method_name!)
    grads_method! = getfield(ShapeFunctions, grads_method_name!)
    return LagrangeShapeFunction(values_method, values_method!, grads_method, grads_method!)
end

# NEED TO FIGURE OUT TYPE FOR X WITH A VIEW
"""
    J(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
Mapping Jacobian. Written to except views of coordinates.
"""
J(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} = transpose(∇φ_ξ) * X
"""
    detJ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
Determinant of mapping Jacobian. Written to except views of coordinates
"""
detJ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} = det(J(∇φ_ξ, X))
"""
    map_∇φ_ξ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
Method to map master element shape function grads to physical element.
    Written to except views.
"""
map_∇φ_ξ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} = transpose(inv(J(∇φ_ξ, X)) * transpose(∇φ_ξ)) 


# actual element implementations below
#
#
"""
    quad4_shape_function_values(ξ::Vector{T}) where {T <: Real}
Implementation for quad4 element.
"""
function quad4_shape_function_values(ξ::Vector{T}) where {T <: Real}
    φ = zeros(T, 4)
    φ[1] = 0.25 * (1.0 - ξ[1]) * (1.0 - ξ[2])
    φ[2] = 0.25 * (1.0 + ξ[1]) * (1.0 - ξ[2])
    φ[3] = 0.25 * (1.0 + ξ[1]) * (1.0 + ξ[2])
    φ[4] = 0.25 * (1.0 - ξ[1]) * (1.0 + ξ[2])
    return φ
end

"""
    quad4_shape_function_values!(φ::Vector{T}, ξ::Vector{T}) where {T <: Real}
Implementation for quad4 element with pre-allocation.
"""
function quad4_shape_function_values!(φ::Vector{T}, ξ::Vector{T}) where {T <: Real}
    φ[1] = 0.25 * (1.0 - ξ[1]) * (1.0 - ξ[2])
    φ[2] = 0.25 * (1.0 + ξ[1]) * (1.0 - ξ[2])
    φ[3] = 0.25 * (1.0 + ξ[1]) * (1.0 + ξ[2])
    φ[4] = 0.25 * (1.0 - ξ[1]) * (1.0 + ξ[2])
end

"""
    quad4_shape_function_gradients(ξ::Vector{T}) where {T <: Real}
Implementation for quad4 element.
"""
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

"""
    quad4_shape_function_gradients!
Implementation for quad4 element.
"""
function quad4_shape_function_gradients!(∇φ_ξ::Matrix{T}, ξ::Vector{T}) where {T <: Real}
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
end

end # module