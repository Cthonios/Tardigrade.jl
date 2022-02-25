using Tardigrade.QuadratureTemplates

function test_quad_element_quadrature_template()
    quad = QuadratureTemplates.quadrature_factory("QUAD4", 1)
    @test quad.w[1] == 4.0
    @test quad.ξ[1, 1] == 0.0
    @test quad.ξ[1, 2] == 0.0

    quad = QuadratureTemplates.quadrature_factory("QUAD4", 2)
    for i=1:quad.Nq
        @test quad.w[i] == 1.0
    end

    @test quad.ξ[1, 1] == -1.0 / √3
    @test quad.ξ[1, 2] == -1.0 / √3
    @test quad.ξ[2, 1] == -1.0 / √3
    @test quad.ξ[2, 2] == 1.0 / √3
    @test quad.ξ[3, 1] == 1.0 / √3
    @test quad.ξ[3, 2] == 1.0 / √3
    @test quad.ξ[4, 1] == 1.0 / √3
    @test quad.ξ[4, 2] == -1.0 / √3
end
