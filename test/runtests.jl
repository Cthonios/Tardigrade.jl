using Tardigrade
using Test

macro tardigrade_test_set(test_name::String, ex)
    return quote
        local test_set_name = rpad($test_name, 64)
        @testset "$test_set_name" begin
            local val = $ex
            val
        end
    end
end

include("TestMeshes.jl")
include("TestQuadratures.jl")
