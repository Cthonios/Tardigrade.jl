"""
`ShapeFunctions`
"""
module ShapeFunctions

export ShapeFunctionValues
export ShapeFunctionGradients
export ShapeFunctionValuesAndGradients

import ..Meshes.Coordinates
import ..Meshes.Connectivity
import ..Meshes.ElementLevelNodalValues
import ..Meshes.FEMContainer
import ..Quadratures.Quadrature

using Base
using LinearAlgebra

"""
`ShapeFunctionContainer`
"""
abstract type ShapeFunctionContainer <: FEMContainer end

"""
`ShapeFunctionValues`

Container that just holds the shape function values and JxW arrays

Interface 
`Base.getindex(s::ShapeFunctionValues, e::Int64)`\n
`Base.iterate(s::ShapeFunctionValues, e=1)`\n
`Base.length(s::ShapeFunctionValues)`\n
"""
struct ShapeFunctionValues <: ShapeFunctionContainer
    φ::Matrix{Float64}
    JxW::Matrix{Float64}
    function ShapeFunctionValues(element_type::String, quadrature::Quadrature, coords::ElementLevelNodalValues)
        values_method, grads_method = setup_shape_function_methods(element_type)
        φs, ∇φ_ξs = values_method(quadrature), grads_method(quadrature)
        JxWs = zeros(Float64, length(coords), length(quadrature))
        initialize_JxW_array!(JxWs, quadrature, coords, ∇φ_ξs)
        return new(φs, JxWs)
    end
end

Base.getindex(s::ShapeFunctionValues, e::Int64) = (s.φ, s.JxW[e, :])
Base.iterate(s::ShapeFunctionValues, e=1) = e > size(s.JxW, 1) ? nothing : ((s.φ, s.JxW[e, :]), e + 1)
Base.length(s::ShapeFunctionValues) = size(s.JxW, 1)

"""
`ShapeFunctionGradients`

Container that just holds the shape function gradients (in the physical frame) and JxW arrays

Interface 
`Base.getindex(s::ShapeFunctionGradients, e::Int64)`\n
`Base.iterate(s::ShapeFunctionGradients, e=1)`\n
`Base.length(s::ShapeFunctionGradients)`\n
"""
struct ShapeFunctionGradients <: ShapeFunctionContainer
    ∇φ_X::Array{Float64,4}
    JxW::Matrix{Float64}
    function ShapeFunctionGradients(element_type::String, quadrature::Quadrature, coords::ElementLevelNodalValues)
        values_method, grads_method = setup_shape_function_methods(element_type)
        φs, ∇φ_ξs = values_method(quadrature), grads_method(quadrature)
        ∇φ_Xs = zeros(Float64, length(coords), length(quadrature), size(∇φ_ξs, 2), size(∇φ_ξs, 3))
        JxWs = zeros(Float64, length(coords), length(quadrature))
        initialize_JxW_and_∇φ_X_array!(∇φ_Xs, JxWs, quadrature, coords, ∇φ_ξs)
        return new(∇φ_Xs, JxWs)
    end
end

Base.getindex(s::ShapeFunctionGradients, e::Int64) = (s.∇φ_X[e, :, :, :], s.JxW[e, :])
Base.iterate(s::ShapeFunctionGradients, e=1) = e > size(s.JxW, 1) ? nothing : ((s.∇φ_X[e, :, :, :], s.JxW[e, :]), e + 1)
Base.length(s::ShapeFunctionGradients) = size(s.JxW, 1)

"""
`ShapeFunctionValuesGradients`

Container that just holds the shape function gradients (in the physical frame) and JxW arrays

Interface 
`Base.getindex(s::ShapeFunctionValuesAndGradients, e::Int64)`\n
`Base.iterate(s::ShapeFunctionValuesAndGradients, e=1)`\n
`Base.length(s::ShapeFunctionValuesAndGradients)`\n
"""
struct ShapeFunctionValuesAndGradients <: ShapeFunctionContainer
    φ::Matrix{Float64}
    ∇φ_X::Array{Float64,4}
    JxW::Matrix{Float64}
    function ShapeFunctionValuesAndGradients(element_type::String, quadrature::Quadrature, coords::ElementLevelNodalValues)
        values_method, grads_method = setup_shape_function_methods(element_type)
        φs, ∇φ_ξs = values_method(quadrature), grads_method(quadrature)
        ∇φ_Xs = zeros(Float64, length(coords), length(quadrature), size(∇φ_ξs, 2), size(∇φ_ξs, 3))
        JxWs = zeros(Float64, length(coords), length(quadrature))
        initialize_JxW_and_∇φ_X_array!(∇φ_Xs, JxWs, quadrature, coords, ∇φ_ξs)
        return new(φs, ∇φ_Xs, JxWs)
    end
end

Base.getindex(s::ShapeFunctionValuesAndGradients, e::Int64) = (s.φ, s.∇φ_X[e, :, :, :], s.JxW[e, :])
Base.iterate(s::ShapeFunctionValuesAndGradients, e=1) = e > size(s.JxW, 1) ? nothing : ((s.φ, s.∇φ_X[e, :, :, :], s.JxW[e, :]), e + 1)
Base.length(s::ShapeFunctionValuesAndGradients) = size(s.JxW, 1)

"""
`setup_shape_function_methods(element_type::String)`

Creates the method calls for different elements based on the exodusII naming convention
"""
function setup_shape_function_methods(element_type::String)
    values_method_name = Symbol(lowercase(element_type) * "_shape_function_values")
    grads_method_name = Symbol(lowercase(element_type) * "_shape_function_gradients")
    
    values_method = getfield(ShapeFunctions, values_method_name)
    grads_method = getfield(ShapeFunctions, grads_method_name)

    return values_method, grads_method
end

# common interface to all (or maybe most element types)
"""
`J(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64})`

Calculates the mapping Jacobian
"""
J(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = transpose(∇φ_ξ) * coords
"""
`detJ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64})`

Calculates the determinant of the mapping Jacobian
"""
detJ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = det(J(∇φ_ξ, coords))
"""
`map_∇φ_ξ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64})`

Maps shape functions from the element template space to the real space
"""
map_∇φ_ξ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = transpose(inv(J(∇φ_ξ, coords)) * transpose(∇φ_ξ)) 

"""
`initialize_JxW_array!(JxW::Matrix{Float64}, quadrature::Quadrature, coords::ElementLevelNodalValues, ∇φ_ξ::Array{Float64,3})`

Initializes the JxW array for arbitrary element shape and quadrature rule
"""
function initialize_JxW_array!(JxW::Matrix{Float64}, quadrature::Quadrature, coords::ElementLevelNodalValues, ∇φ_ξ::Array{Float64,3})
    for (q, (_, w)) in enumerate(quadrature)
        JxW[:, q] .= w * detJ.((∇φ_ξ[q, :, :],), coords)
    end
end

function initialize_JxW_and_∇φ_X_array!(∇φ_X::Array{Float64,4}, JxW::Matrix{Float64}, 
                                        quadrature::Quadrature, coords::ElementLevelNodalValues, ∇φ_ξ::Array{Float64,3})
    for (q, (_, w)) in enumerate(quadrature)
        for e = 1:length(coords)
            ∇φ_X[e, q, :, :] = map_∇φ_ξ(∇φ_ξ[q, :, :], coords[e])
        end
        # ∇φ_ξ_q = ∇φ_ξ[q, :, :]
        # ∇φ_X[:, q, :, :] .= map_∇φ_ξ.((∇φ_ξ[q, :, :],), coords)
        # ∇φ_X[:, q, :, :] .= map_∇φ_ξ.((∇φ_ξ_q,), coords)
        JxW[:, q] .= w * detJ.((∇φ_ξ[q, :, :],), coords)
    end
end

# element types, eventually move to sorted files or something else organized

"""
`quad4_shape_function_values(quadrature::Quadrature)::Matrix{Float64}`
"""
function quad4_shape_function_values(quadrature::Quadrature)::Matrix{Float64}
    φ = zeros(Float64, length(quadrature), 4)
    for (q, (ξ, _)) in enumerate(quadrature)
        φ[q, 1] = 0.25 * (1.0 - ξ[1]) * (1.0 - ξ[2])
        φ[q, 2] = 0.25 * (1.0 + ξ[1]) * (1.0 - ξ[2])
        φ[q, 3] = 0.25 * (1.0 + ξ[1]) * (1.0 + ξ[2])
        φ[q, 4] = 0.25 * (1.0 - ξ[1]) * (1.0 + ξ[2])
    end
    return φ
end

"""
`quad4_shape_function_gradients(quadrature::Quadrature)::Array{Float64,3}`
"""
function quad4_shape_function_gradients(quadrature::Quadrature)::Array{Float64,3}
    ∇φ_ξ = zeros(Float64, length(quadrature), 4, 2)
    for (q, (ξ, _)) in enumerate(quadrature)
        ∇φ_ξ[q, 1, 1] = -0.25 * (1.0 - ξ[2])
        ∇φ_ξ[q, 1, 2] = -0.25 * (1.0 - ξ[1])
        #
        ∇φ_ξ[q, 2, 1] = 0.25 * (1.0 - ξ[2])
        ∇φ_ξ[q, 2, 2] = -0.25 * (1.0 + ξ[1])
        #
        ∇φ_ξ[q, 3, 1] = 0.25 * (1.0 + ξ[2])
        ∇φ_ξ[q, 3, 2] = 0.25 * (1.0 + ξ[1])
        #
        ∇φ_ξ[q, 4, 1] = -0.25 * (1.0 + ξ[2])
        ∇φ_ξ[q, 4, 2] = 0.25 * (1.0 - ξ[1])
    end
    return ∇φ_ξ
end

end # module