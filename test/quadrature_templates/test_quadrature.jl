using Tardigrade.QuadratureTemplates

include("./test_quad_quadrature.jl")

function test_quadrature()
    test_set_name = rpad("QuadQuadrature.jl", 64)
    @testset "$test_set_name" begin
        test_quad_element_quadrature_template()
    end
end
