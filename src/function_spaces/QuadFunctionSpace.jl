using ..QuadratureTemplates

function quad4_calculate_shape_function_values(shape_function_order,
                                               q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    if shape_function_order == 1
        Nξ = fourth * [(one - ξ) * (one - η),
                       (one + ξ) * (one - η),
                       (one + ξ) * (one + η),
                       (one - ξ) * (one + η)]
    end
    return Nξ
end

function quad4_calculate_shape_function_gradients(shape_function_order,
                                                  q_point::Vector{Float64})
    one = 1.0
    fourth = 1.0 / 4.0
    ξ, η = q_point[1], q_point[2]
    ∇Nξ = zeros(Float64, 4, 2)
    if shape_function_order == 1
        ∇Nξ[1, 1] = -fourth * (one - η)
        ∇Nξ[1, 2] = -fourth * (one - ξ)
        #
        ∇Nξ[2, 1] = fourth * (one - η)
        ∇Nξ[2, 2] = -fourth * (one + ξ)
        #
        ∇Nξ[3, 1] = fourth * (one + η)
        ∇Nξ[3, 2] = fourth * (one + ξ)
        #
        ∇Nξ[4, 1] = -fourth * (one + η)
        ∇Nξ[4, 2] = fourth * (one - ξ)
    end

    return ∇Nξ
end
