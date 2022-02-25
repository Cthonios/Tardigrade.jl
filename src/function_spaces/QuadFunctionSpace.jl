using ..QuadratureTemplates

function quad_reference_element_init!(shape_function_order::Int8,
                                      quadrature::QuadraturePoints,
                                      Nξ::Array{Float64,2},
                                      ∇Nξ::Array{Float64,3})
    one = 1.0
    fourth = 1.0 / 4.0
    if shape_function_order == 1
        for q = 1:quadrature.Nq
            ξ = quadrature.ξ[q, 1]
            η = quadrature.ξ[q, 2]

            # shape function values
            #
            Nξ[1, q] = fourth * (one - ξ) * (one - η)
            Nξ[2, q] = fourth * (one + ξ) * (one - η)
            Nξ[3, q] = fourth * (one + ξ) * (one + η)
            Nξ[4, q] = fourth * (one - ξ) * (one + η)

            # shape function gradients on reference element
            #
            ∇Nξ[1, 1, q] = -fourth * (one - η)
            ∇Nξ[1, 2, q] = -fourth * (one - ξ)
            #
            ∇Nξ[2, 1, q] = fourth * (one - η)
            ∇Nξ[2, 2, q] = -fourth * (one + ξ)
            #
            ∇Nξ[3, 1, q] = fourth * (one + η)
            ∇Nξ[3, 2, q] = fourth * (one + ξ)
            #
            ∇Nξ[4, 1, q] = -fourth * (one + η)
            ∇Nξ[4, 2, q] = fourth * (one - ξ)
        end
    end
end
