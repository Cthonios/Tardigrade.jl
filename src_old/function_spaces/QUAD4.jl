function quad4_calculate_shape_function_values(q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    N = zeros(Float64, 4)
    @inbounds N[1] = fourth * (one - ξ) * (one - η)
    @inbounds N[2] = fourth * (one + ξ) * (one - η)
    @inbounds N[3] = fourth * (one + ξ) * (one + η)
    @inbounds N[4] = fourth * (one - ξ) * (one + η)
    return N
end

function quad4_calculate_shape_function_gradients(q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    ∇N_ξ = zeros(Float64, 4, 2)
    @inbounds ∇N_ξ[1, 1] = -fourth * (one - η)
    @inbounds ∇N_ξ[1, 2] = -fourth * (one - ξ)
    @inbounds ∇N_ξ[2, 1] = fourth * (one - η)
    @inbounds ∇N_ξ[2, 2] = -fourth * (one + ξ)
    @inbounds ∇N_ξ[3, 1] = fourth * (one + η)
    @inbounds ∇N_ξ[3, 2] = fourth * (one + ξ)
    @inbounds ∇N_ξ[4, 1] = -fourth * (one + η)
    @inbounds ∇N_ξ[4, 2] = fourth * (one - ξ)
    return ∇N_ξ
end