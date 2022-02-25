module Kernels

abstract type AbstractKernel end

struct Kernel
    name::String
    primary_variable::String
    coupled_variables::Array{String,1}
end

function kernel_factory(input_settings)
    if input_settings["kernel name"] == "laplacian"
        # TODO: link to a Laplacian kernel
    else
        throw(AssertionError("Unsupported kernel"))
    end
end

end module
