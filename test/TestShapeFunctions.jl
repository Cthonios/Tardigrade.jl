using Tardigrade.Meshes
using Tardigrade.Quadratures
using Tardigrade.ShapeFunctions


@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Value Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    φ = shape_functions.φ(quadrature.ξ[1, :])
    @test φ ≈ [0.25, 0.25, 0.25, 0.25]
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Value Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)

    φ = shape_functions.φ(quadrature.ξ[1, :])
    @test φ[1] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))

    φ = shape_functions.φ(quadrature.ξ[2, :])
    @test φ[1] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))

    φ = shape_functions.φ(quadrature.ξ[3, :])
    @test φ[1] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))

    φ = shape_functions.φ(quadrature.ξ[4, :])
    @test φ[1] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Grad Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)

    ∇φ = shape_functions.∇φ(quadrature.ξ[1, :])
    @test ∇φ[1, 1] ≈ -0.25
    @test ∇φ[1, 2] ≈ -0.25
    @test ∇φ[2, 1] ≈ 0.25
    @test ∇φ[2, 2] ≈ -0.25
    @test ∇φ[3, 1] ≈ 0.25
    @test ∇φ[3, 2] ≈ 0.25
    @test ∇φ[4, 1] ≈ -0.25
    @test ∇φ[4, 2] ≈ 0.25
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Grad Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)

    ∇φ = shape_functions.∇φ(quadrature.ξ[1, :])
    @test ∇φ[1, 1] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ[1, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ[2, 1] ≈ 0.25 * (1. + sqrt(1. / 3))
    @test ∇φ[2, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ[3, 1] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ[3, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ[4, 1] ≈ -0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ[4, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
end