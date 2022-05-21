module Kernels

export initialize_kernels
export calculate_element_level_residual!
export calculate_element_level_tangent!

using LinearAlgebra

include("./Poisson.jl")

import ..Sections: Connectivity
import ..Sections: Section

abstract type AbstractKernel end

# TODO: maybe add some settings to not update for kernels that are fixed
mutable struct ScalarKernel <: AbstractKernel
    name::String
    solution_field::Vector{Float64}
    update!
end

struct Kernel <: AbstractKernel
    name::String
    calculate_kernel_residual_at_qp::Function
    calculate_kernel_tangent_at_qp::Function
    calculate_kernel_residual_and_tangent_at_qp::Function
end

# interface
# update_kernel_at_qp!(k::AbstractKernel) = 0

# here I think the kernel should read in only element information
# the total update then can be composed of functions using piping maybe?
# we should only be passing over the elements once
function update_scalar_kernel()
    # for (n, e) in section
    #     X, conn, N, ∇N_X, JxW = e
    #     u_e = u_es[n, :]
    #     kernel.update(X, conn, N, ∇N_X, JxW, u_e, R_e, K_e)
    # end
end


function calculate_element_level_residual!(f, R_e, u_e, ∇u_e, N_e, ∇N_e, JxW_e)
    # R_e .= zero(Float64)
    for q in size(N_e, 1)
        R_e += JxW_e[q] * f(u_e[q], ∇u_e[q], N_e[q], ∇N_e[q])
    end
end

function calculate_element_level_tangent!(f, K_e, u_e, ∇u_e, N_e, ∇N_e, JxW_e)
    # K_e .= zero(Float64)
    for q in size(N_e, 1)
        K_e += JxW_e[q] * f(u_e[q], ∇u_e[q], N_e[q], ∇N_e[q])
    end 
end

function calculate_element_level_residual_and_tangent!(f, R_e, K_e, u_e, ∇u_e, N_e, ∇N_e, JxW_e)
    # R_e .= zero(Float64); K_e .= zero(Float64)
    for q in size(N_e, 1)
        R_e += JxW_e[q] * f(u_e[q], ∇u_e[q], N_e[q], ∇N_e[q])
        K_e += JxW_e[q] * f(u_e[q], ∇u_e[q], N_e[q], ∇N_e[q])
    end
end


function kernel_factory(kernel_settings)
    if kernel_settings["kernel name"] == "poisson"
        name = "poisson"
        # update = update_poisson_kernel_at_qp!
        # return ScalarKernel(name, zeros(Float64, ))
        calculate_kernel_residual_at_qp = calculate_poisson_kernel_residual_at_qp
        calculate_kernel_tangent_at_qp = calculate_poisson_kernel_tangent_at_qp
        calculate_kernel_residual_and_tangent_at_qp = calculate_poisson_kernel_residual_and_tangent_at_qp
        # calculate_element_level_residual()
    else
        throw(AssertionError("Unsupported kernel"))
    end

    return Kernel(name, 
                  calculate_kernel_residual_at_qp, 
                  calculate_kernel_tangent_at_qp,
                  calculate_kernel_residual_and_tangent_at_qp)
end

function initialize_kernels!(kernels, kernel_settings)
    for (n, kernel) in enumerate(kernel_settings)
        kernels[n] = kernel_factory(kernel)
    end
end

function initialize_kernels(kernel_settings)
    kernels = Vector{AbstractKernel}(undef, length(kernel_settings))
    initialize_kernels!(kernels, kernel_settings)
    return kernels
end

# using Parameters
# # using Tardigrade.FunctionSpaces
# # using ..FunctionSpaces

# include("./Poisson.jl")

# abstract type AbstractKernel end

# @with_kw struct Kernel
#     name::String
#     primary_variable::String
#     coupled_variables::Array{String,1} = []
#     blocks::Array{Int64,1}
#     #
#     # initialize_quadrature_point_function
#     # residual_at_quadrature_point_function
#     # tangent_at_quadrature_point_function
#     update_kernel_method
# end

# function kernel_factory(input_settings)
#     if input_settings["kernel name"] == "poisson"
#         return update_poisson_kernel_at_qp!
#     else
#         throw(AssertionError("Unsupported kernel"))
#     end
# end

end # module
