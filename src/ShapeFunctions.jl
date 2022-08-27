"""
    ShapeFunctions
A module for working with FEM shape functions.
"""
module ShapeFunctions

export AbstractShapeFunction
export ShapeFunction
export LagrangeShapeFunction
export J
export J!
export detJ
export detJ!
export map_∇φ_ξ
export map_∇φ_ξ!

using LinearAlgebra

# actual element implementations
import ..Elements: quad4_shape_function_values
import ..Elements: quad4_shape_function_values!
import ..Elements: quad4_shape_function_gradients
import ..Elements: quad4_shape_function_gradients!

"""
    AbstractShapeFunction
Parent type of all shape functions.
"""
abstract type AbstractShapeFunction end

function ShapeFunction(shape_function_settings::Dict{Any, Any}, element_type::String)
    type_symbol = Symbol(shape_function_settings["type"])
    return getfield(ShapeFunctions, type_symbol)(element_type)
end 

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
    J!(J::Matrix{T}, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} 
Inplace mapping Jacobian.
"""
function J!(J::Matrix{T}, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} 
    J .= transpose(∇φ_ξ) * X
end
"""
    detJ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
Determinant of mapping Jacobian. Written to except views of coordinates.
"""
detJ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} = det(J(∇φ_ξ, X))

# # THIS IS PROBABLY OVERKILL
# """
#     detJ(J::T, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
# In place derminant of mapping Jacobian.
# """
# function detJ!(detJ::T, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
#     detJ .= det(J(∇φ_ξ, X))
# end
"""
    map_∇φ_ξ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
Method to map master element shape function grads to physical element.
    Written to except views.
"""
map_∇φ_ξ(∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S} = transpose(inv(J(∇φ_ξ, X)) * transpose(∇φ_ξ)) 
"""
    map_∇φ_ξ!(∇φ_X::Matrix{T}, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}    
In place version of map_∇φ_ξ
"""
function map_∇φ_ξ!(∇φ_X::Matrix{T}, ∇φ_ξ::Matrix{T}, X::S) where {T <: Real, S}
    J!(∇φ_X, ∇φ_ξ, X) # use the already allocated memory twice
    ∇φ_X .= transpose(inv(∇φ_X)) * transpose(∇φ_ξ)
end

end # module