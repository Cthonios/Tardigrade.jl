module Kernels

include("./Poisson.jl")

using Parameters

abstract type AbstractKernel end

@with_kw struct Kernel
    name::String
    primary_variable::String
    coupled_variables::Array{String,1} = []
    blocks::Array{Int64,1}
    #
    # initialize_quadrature_point_function
    # residual_at_quadrature_point_function
    # tangent_at_quadrature_point_function
    update_kernel_method
end

function kernel_factory(input_settings)
    # if input_settings["kernel name"] == "laplacian"
    #     # TODO: link to a Laplacian kernel
    #     include("./Laplacian.jl")
    #     return Kernel()
    if input_settings["kernel name"] == "poisson"
        # return Kernel(name="poisson",
        # primary_variable="u",
        # blocks=[1],
        # update_kernel_method=update_poisson_kernel_at_qp!)
        return update_poisson_kernel_at_qp!
    else
        throw(AssertionError("Unsupported kernel"))
    end
end

# function build_residual_functions_at_quadrature_points()
#
# end
#
# function build_tangent_methods_at_quadrature_points()
# end
#
#
#
# function calculate_element_level_residual()
#
# end
#
# function calculate_element_level_tangent()
#
# end

end
