module Kernels

abstract type AbstractKernel end
abstract type AbstractStaticKernel <: AbstractKernel end
abstract type AbstractTransientKernel <: AbstractKernel end

struct UncoupledStaticKernel <: AbstractStaticKernel
    calculate_qp_residual::Function
    calculate_qp_tangent::Function
    function UncoupledStaticKernel(kernel_settings::Dict{Any,Any})
        kernel_name = kernel_settings["type"]
        residual_method_symbol = Symbol(lowercase(kernel_name) * "_calculate_qp_residual")
        residual_method = getfield(Kernels, residual_method_symbol)
        tangent_method_symbol = Symbol(lowercase(kernel_name) * "_calculate_qp_tangent")
        tangent_method = getfield(Kernels, tangent_method_symbol)
        return new(residual_method, tangent_method)
    end
end

function poisson_calculate_qp_residual(e)

end

function poisson_calculate_qp_tangent(e)

end

end # module