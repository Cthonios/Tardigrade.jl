# using ..FunctionSpaces
# import ..FunctionSpaces
# import ..FunctionSpaces
# using Tardigrade.FunctionSpaces
# import Tardigrade.FunctionSpaces.∇Nₓ
# import Tardigrade.FunctionSpaces.detJ
function update_poisson_kernel_at_qp!(coords, u,
                                      quadrature, Nξ_method, ∇Nξ_method,
                                      Rₑ, Kₑ)
    @simd for q=1:quadrature.Nq
        @inbounds Nξ = Nξ_method(quadrature.ξ[q, :])
        @inbounds ∇Nξ = ∇Nξ_method(quadrature.ξ[q, :])
        ∇Nₓ = FunctionSpaces.∇Nₓ(coords, ∇Nξ)
        JxW = quadrature.w[q] * FunctionSpaces.detJ(coords, ∇Nξ)
        # ∇Nₓ = ∇Nₓ(coords, ∇Nξ)
        # JxW = quadrature.w[q] * detJ(coords, ∇Nξ)
        ∇u_q = transpose(∇Nₓ) * u
        f_q = 1.0 * Nξ
        @inbounds Rₑ[:] = Rₑ + JxW * (-∇Nₓ * ∇u_q + f_q)
        @inbounds Kₑ[:] = Kₑ - JxW * ∇Nₓ * transpose(∇Nₓ)
    end
end

function calculate_poisson_residual_at_qp!(u_q, i, Nξ, ∇Nₓ_temp, JxW)
    f_q = 1.0 * Nξ[i]
    return JxW * (-∇Nₓ_temp[i, :] * u_q + f_q)
end

function calculate_poisson_tangent_at_qp!(u_q, i, j, Nξ, ∇Nₓ_temp, JxW)
    return -JxW * ∇Nₓ_temp[i, :] * transpose(∇Nₓ_temp[j, :])
end
