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

include("TestBoundaryConditions.jl")
include("TestFields.jl")
include("TestMeshes.jl")
include("TestQuadratures.jl")
include("TestShapeFunctions.jl")
include("TestStaticQuadratures.jl")

# eventually add this to some regression test workflow
include("TestPoissonProblem.jl")
