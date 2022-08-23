test_set_name = rpad("Kernels.jl - UncoupledStaticKernel", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    kernels = settings["kernels"]
    for kernel in kernels
        k = Kernels.UncoupledStaticKernel(kernel)
        @show k
    end 
end