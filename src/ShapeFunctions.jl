"""
`ShapeFunctions`
"""
module ShapeFunctions

using LinearAlgebra

function setup_shape_function_methods(element_type::String)
    values_method_name = Symbol(lowercase(element_type) * "_shape_function_values")
    grads_method_name = Symbol(lowercase(element_type) * "_shape_function_gradients")
    
    values_method = getfield(ShapeFunctions, values_method_name)
    grads_method = getfield(ShapeFunctions, grads_method_name)

    return values_method, grads_method
end


J(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = transpose(∇φ_ξ) * coords
detJ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = det(J(∇φ_ξ, coords))
map_∇φ_ξ(∇φ_ξ::Matrix{Float64}, coords::Matrix{Float64}) = transpose(inv(J(∇φ_ξ, coords)) * transpose(∇φ_ξ)) 

# element types, eventually move to sorted files or something else organized

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