using Tardigrade.StaticQuadratures

@tardigrade_test_set "StaticQuadratures.jl - StaticQuadrature" begin
    quadrature = StaticQuadrature("quad4", 1)

    @test quadrature.ξ[1, 1] == 0.0
    @test quadrature.ξ[1, 2] == 0.0
    @test quadrature.w[1] == 4.

    @test length(quadrature) == 1
    @test sum(quadrature.w) == 4.

    for (ξ, w) in quadrature
    end

    quadrature = StaticQuadrature("quad4", 2)

    @test quadrature.ξ[1, 1] == -1.0 / sqrt(3.0)
    @test quadrature.ξ[1, 2] == -1.0 / sqrt(3.0)

    @test quadrature.ξ[2, 1] == 1.0 / sqrt(3.0)
    @test quadrature.ξ[2, 2] == -1.0 / sqrt(3.0)
    
    @test quadrature.ξ[3, 1] == 1.0 / sqrt(3.0)
    @test quadrature.ξ[3, 2] == 1.0 / sqrt(3.0)

    @test quadrature.ξ[4, 1] == -1.0 / sqrt(3.0)
    @test quadrature.ξ[4, 2] == 1.0 / sqrt(3.0)

    @test quadrature.w == [1.0, 1.0, 1.0, 1.0]

    for (ξ, w) in quadrature
    end

    @test length(quadrature) == 4
    @test sum(quadrature.w) == 4.
end