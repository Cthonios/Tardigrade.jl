using StaticArrays

"""
    quad4_quadrature_points_and_weights(q_order::Int64)
Defines quadrature rule for quad4 elements.
# Arguments
- `q_order::Int64`: quadrature order
"""
function quad4_quadrature_points_and_weights(q_order::Int64)
    if q_order == 1
        ξ = [0.0 0.0;]
        w = [4.0]
    elseif q_order == 2
        ξ = (1.0 / sqrt(3.0)) * [-1.0 -1.0
                                 1.0 -1.0
                                 1.0 1.0
                                 -1.0 1.0]
        w = [1.0, 1.0, 1.0, 1.0]
    else
        quadrautre_order_error(q_order)
    end
    return ξ, w
end

"""
    quad4_quadrature_points_and_weights_static(q_order::Int64)
Defines quadrature rule for quad4 elements.
# Arguments
- `q_order::Int64`: quadrature order
"""
function quad4_quadrature_points_and_weights_static(q_order::Int64)
    if q_order == 1
        ξ = SMatrix{1, 2, Float64}(0., 0.) # TODO make parametric
        w = SVector{1, Float64}(4.)
    elseif q_order == 2
        ξ = (1. / sqrt(3.)) * @SMatrix [-1.0 -1.0;
                                        1.0 -1.0;
                                        1.0 1.0;
                                        -1.0 1.0]
        w = SVector{4, Float64}(1., 1., 1., 1.)
    else
        quadrautre_order_error(q_order)
    end
    return ξ, w
end

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