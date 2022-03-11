include("Tardigrade.jl")

using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Printf

import Tardigrade.read_input_file
import Tardigrade.parse_mesh_block

import Tardigrade.setup_mesh
import Tardigrade.setup_variables
import Tardigrade.setup_quadrature
import Tardigrade.setup_function_space_methods
import Tardigrade.setup_kernels
import Tardigrade.setup_boundary_conditions
import Tardigrade.update_bcs_solution!
import Tardigrade.update_bcs_residual_and_tangent!

function poisson_equation(input_file)
    println("simple example for poisson equation")
    # input_file = ARGS[1]
    @show input_file
    input_settings = read_input_file(input_file)
    @time mesh = setup_mesh(input_settings)
    @time variables = setup_variables(input_settings)
    @time quadrature = setup_quadrature(mesh, variables)
    @time Nξ_methods, ∇Nξ_methods = setup_function_space_methods(mesh, variables)
    @time kernels = setup_kernels(input_settings)
    kernels = [kernels]
    @time boundary_conditions = setup_boundary_conditions(input_settings, mesh, variables)

    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    @time u = solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)


    mesh_file_name = Parser.parse_mesh_block(input_settings)
    @time exo = PostProcessor.copy_mesh_to_exodus_database(mesh_file_name)
    @time PostProcessor.setup_exodus_variable_fields(exo)
    @time PostProcessor.setup_initial_time_step(exo)
    @time PostProcessor.write_exodus_time_step(exo, u)
    @time PostProcessor.close_exodus_database(exo)
end

function solve(mesh, boundary_conditions, kernels, quadrature, Nξ_methods, ∇Nξ_methods)
    println("solving")

    tolerance = 1000.0
    conn = mesh.blocks[1].connectivity
    coords = mesh.coords[conn, :]
    u = ones(Float64, mesh.Nₙ)
    R = zeros(Float64, mesh.Nₙ)
    K = spzeros(Float64, mesh.Nₙ, mesh.Nₙ)
    R_e = zeros(Float64, mesh.blocks[1].Nₙ_per_e)
    K_e = zeros(Float64, mesh.blocks[1].Nₙ_per_e, mesh.blocks[1].Nₙ_per_e)
    local_us = zeros(Float64, mesh.blocks[1].Nₑ, mesh.blocks[1].Nₙ_per_e)
    Δu = zeros(Float64, mesh.Nₙ)
    while tolerance > 1.0e-12
        K .= zero(Float64)
        R .= zero(Float64)

        # update bcs
        #
        update_bcs_solution!(boundary_conditions, u)

        # calculate residual
        #
        local_us .= zero(Float64)
        @simd for e=1:mesh.blocks[1].Nₑ
            @simd for i=1:mesh.blocks[1].Nₙ_per_e
                @inbounds local_us[e, i] = u[conn[e, i]]
            end
        end

        @simd for e = 1:mesh.Nₑ
            R_e .= zero(Float64)
            K_e .= zero(Float64)
            kernels[1](coords[e, :, :], local_us[e, :], quadrature[1],
            Nξ_methods[1], ∇Nξ_methods[1], R_e, K_e)

            @simd for i=1:4
                @inbounds R[conn[e, i]] += R_e[i]
                @simd for j=1:4
                    @inbounds K[conn[e, i], conn[e, j]] += K_e[i, j]
                end
            end
        end

        # update bcs
        #
        update_bcs_residual_and_tangent!(boundary_conditions, R, K)

        Δu .= zero(Float64)
        cg!(Δu, K, R)
        u .= u - Δu

        # check residual
        #
        @printf("|R| = %s\t|Δu| = %s\n", norm(R), norm(Δu))

        if norm(R) < 1.0e-12
            break
        end

        if norm(Δu) < 1.0e-12
            break
        end
    end

    return u
end

input_file = "test/input_file/test_input_file.yaml"
poisson_equation(input_file)
