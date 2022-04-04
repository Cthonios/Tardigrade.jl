using ..QuadratureTemplates

function quad4_calculate_shape_function_values(q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    Nξ = zeros(Float64, 4)
    @inbounds Nξ[1] = fourth * (one - ξ) * (one - η)
    @inbounds Nξ[2] = fourth * (one + ξ) * (one - η)
    @inbounds Nξ[3] = fourth * (one + ξ) * (one + η)
    @inbounds Nξ[4] = fourth * (one - ξ) * (one + η)
    return Nξ
end

function quad4_calculate_shape_function_gradients(q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    ∇Nξ = zeros(Float64, 4, 2)
    @inbounds ∇Nξ[1, 1] = -fourth * (one - η)
    @inbounds ∇Nξ[1, 2] = -fourth * (one - ξ)
    @inbounds ∇Nξ[2, 1] = fourth * (one - η)
    @inbounds ∇Nξ[2, 2] = -fourth * (one + ξ)
    @inbounds ∇Nξ[3, 1] = fourth * (one + η)
    @inbounds ∇Nξ[3, 2] = fourth * (one + ξ)
    @inbounds ∇Nξ[4, 1] = -fourth * (one + η)
    @inbounds ∇Nξ[4, 2] = fourth * (one - ξ)
    return ∇Nξ
end
