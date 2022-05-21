module Systems

export poisson_problem

using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Printf

# import ..Connectivity: scatter_nodal_values
import ..Sections: Section, 
                   initialize_sections, 
                   element_level_nodal_values,
                   element_level_quadrature_values,
                   element_level_quadrature_gradients,
                   element_level_quadrature_values_and_gradients
import ..BoundaryConditions: AbstractBC, 
                             initialize_boundary_conditions,
                             update_bcs_solution!,
                             update_bcs_residual!,
                             update_bcs_tangent!,
                             update_bcs_residual_and_tangent!
import ..Kernels: AbstractKernel, 
                  initialize_kernels,
                  calculate_element_level_residual!,
                  calculate_element_level_tangent!,
                  calculate_element_level_residual_and_tangent!

abstract type AbstractSystem end

mutable struct StaticUncoupledSystem <: AbstractSystem
    sections::Vector{Section}
    bcs::Vector{AbstractBC}
    kernels::Vector{AbstractKernel}
    u::Vector{Float64}
end

function poisson_problem(n_dof::Int64, sections::Vector{Section}, 
                         bcs::Vector{AbstractBC}, kernels::Vector{AbstractKernel})
    message = rpad("Solving Poisson problem...", 48)
    print(message)
    u = ones(Float64, n_dof)
    R = zeros(Float64, n_dof)
    K = spzeros(Float64, n_dof, n_dof)

    @time solve_poisson_problem(u, R, K, sections, bcs, kernels)

    # TODO: add post-processing
end

function solve_poisson_problem(u::Vector{Float64}, R::Vector{Float64}, K,
                               sections::Vector{Section}, 
                               bcs::Vector{AbstractBC},
                               kernels::Vector{AbstractKernel})

    tolerance = 1000.0
    Δu = zeros(Float64, size(R, 1))
    while tolerance > 1e-12
        R .= zero(Float64); K .= zero(Float64);

        # update bcs
        update_bcs_solution!(bcs, u)
        # loop over sections
        for s in sections
            R_e = zeros(Float64, s.N_n_per_e)
            K_e = zeros(Float64, s.N_n_per_e, s.N_n_per_e)
            # u_es = element_level_nodal_values(u, section)
            # u_e_qs = element_level_quadrature_values(u, section)
            message = rpad("Calculating gradients...", 48)
            print(message)
            @time u_e_qs, ∇u_e_qs = element_level_quadrature_values_and_gradients(u, s)
            # @time ∇u_e_qs = element_level_quadrature_gradients(u, s)
            for e = 1:s.N_e
                R_e .= zero(Float64); K_e .= zero(Float64)

                # calculate element level quadrature here
                for kernel in kernels
                    calculate_element_level_residual_and_tangent!(kernel.calculate_kernel_residual_and_tangent_at_qp,
                                                                  R_e, K_e,
                                                                  u_e_qs[e, :], ∇u_e_qs[e, :, :],
                                                                  s.function_space.Ns,
                                                                  s.function_space.∇N_Xs[e],
                                                                  s.function_space.JxWs[e])
                end

                for i = 1:s.N_n_per_e
                    @inbounds R[s.conn.conn[e, i]] += R_e[i]
                    for j = 1:s.N_n_per_e
                        @inbounds K[s.conn.conn[e, i], s.conn.conn[e, j]] += K_e[i, j]
                    end
                end
            end
        end

        # enforce constraints on residual and tangents
        update_bcs_residual_and_tangent!(bcs, R, K)

        # linear solve and update
        Δu .= zero(Float64)
        cg!(Δu, K, R)
        u .= u - Δu
        # error metrics
        norm_R, norm_Δu = norm(R), norm(Δu)
        @printf("|R| = %s\t|Δu| = %s\n", norm(R), norm(Δu))
        # check tolerances
        if norm_R < 1.0e-12
            break
        end
        if norm_Δu < 1.0e-12
            break
        end
        # 
        tolerance = 1e-16
    end
end


# interface
# initialize_system() = 0

# function initialize_static_uncoupled_system(
#     n_dof::Int64,
#     sections::Vector{Section},
#     bcs::Vector{AbstractDirichletBC})

#     return StaticUncoupledSystem(sections, bcs, zeros(Float64, n_dof))
# end

# function update_static_uncoupled_system!()
# end





end # module