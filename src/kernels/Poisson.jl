using ..FunctionSpaces

function update_poisson_kernel_at_qp!(coords, u, quadrature, Nξ_method, ∇Nξ_method, Rₑ, Kₑ)
    @simd for q=1:quadrature.Nq
        Nξ = Nξ_method(quadrature.ξ[q, :])
        ∇Nξ = ∇Nξ_method(quadrature.ξ[q, :])
        ∇Nₓ = FunctionSpaces.∇Nₓ(coords, ∇Nξ)
        JxW = quadrature.w[q] * FunctionSpaces.detJ(coords, ∇Nξ)
        ∇u_q = transpose(∇Nₓ) * u
        f_q = 1.0 * Nξ
        Rₑ[:] = Rₑ + JxW * (-∇Nₓ * ∇u_q + f_q)
        Kₑ[:] = Kₑ - JxW * ∇Nₓ * transpose(∇Nₓ)
    end
end
