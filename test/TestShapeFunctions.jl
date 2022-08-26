using Tardigrade.Meshes
using Tardigrade.Quadratures
using Tardigrade.ShapeFunctions


@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Value Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    φ = shape_functions.φ(quadrature.ξ[1, :])
    @test φ ≈ [0.25, 0.25, 0.25, 0.25]
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Value Correctness Inplace" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    φ = zeros(Float64, 4)
    shape_functions.φ!(φ, quadrature.ξ[1, :])
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

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Value Correctness Inplace" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)

    φ = zeros(Float64, 4)

    shape_functions.φ!(φ, quadrature.ξ[1, :])
    @test φ[1] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))

    shape_functions.φ!(φ, quadrature.ξ[2, :])
    @test φ[1] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))

    shape_functions.φ!(φ, quadrature.ξ[3, :])
    @test φ[1] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))

    shape_functions.φ!(φ, quadrature.ξ[4, :])
    @test φ[1] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[2] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. - 1. / sqrt(3.))
    @test φ[3] ≈ 0.25 * (1. - 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
    @test φ[4] ≈ 0.25 * (1. + 1. / sqrt(3.)) * (1. + 1. / sqrt(3.))
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Grad Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[1, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25
    @test ∇φ_ξ[1, 2] ≈ -0.25
    @test ∇φ_ξ[2, 1] ≈ 0.25
    @test ∇φ_ξ[2, 2] ≈ -0.25
    @test ∇φ_ξ[3, 1] ≈ 0.25
    @test ∇φ_ξ[3, 2] ≈ 0.25
    @test ∇φ_ξ[4, 1] ≈ -0.25
    @test ∇φ_ξ[4, 2] ≈ 0.25
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Grad Correctness Inplace" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    ∇φ_ξ = zeros(Float64, 4, 2)
    shape_functions.∇φ_ξ!(∇φ_ξ, quadrature.ξ[1, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25
    @test ∇φ_ξ[1, 2] ≈ -0.25
    @test ∇φ_ξ[2, 1] ≈ 0.25
    @test ∇φ_ξ[2, 2] ≈ -0.25
    @test ∇φ_ξ[3, 1] ≈ 0.25
    @test ∇φ_ξ[3, 2] ≈ 0.25
    @test ∇φ_ξ[4, 1] ≈ -0.25
    @test ∇φ_ξ[4, 2] ≈ 0.25
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Grad Correctness" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)

    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[1, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))

    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[2, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))

    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[3, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))

    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[4, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Grad Correctness Inplace" begin
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)
    ∇φ_ξ = zeros(Float64, 4, 2)

    shape_functions.∇φ_ξ!(∇φ_ξ, quadrature.ξ[1, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))

    shape_functions.∇φ_ξ!(∇φ_ξ, quadrature.ξ[2, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))

    shape_functions.∇φ_ξ!(∇φ_ξ, quadrature.ξ[3, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))

    shape_functions.∇φ_ξ!(∇φ_ξ, quadrature.ξ[4, :])
    @test ∇φ_ξ[1, 1] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[1, 2] ≈ -0.25 * (1. + sqrt(1. / 3))
    @test ∇φ_ξ[2, 1] ≈ 0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[2, 2] ≈ -0.25 * (1. - sqrt(1. / 3))
    @test ∇φ_ξ[3, 1] ≈ 0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[3, 2] ≈ 0.25 * (1. - sqrt(1. / 3.))
    @test ∇φ_ξ[4, 1] ≈ -0.25 * (1. + sqrt(1. / 3.))
    @test ∇φ_ξ[4, 2] ≈ 0.25 * (1. + sqrt(1. / 3.))
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Mapping" begin
    mesh = SingleBlockExodusMesh("./mesh/mesh_test_1.g")
    X = element_level_coordinates(mesh, 1)
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    ∇φ_ξ = shape_functions.∇φ_ξ(quadrature.ξ[1, :])
    ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
    J_e = J(∇φ_ξ, X)
    detJ_e = detJ(∇φ_ξ, X)
    @test detJ_e ≈ 0.25
end

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 2 Mapping" begin
    mesh = SingleBlockExodusMesh("./mesh/mesh_test_1.g")
    X = element_level_coordinates(mesh, 1)
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 2)

    for (ξ, w) in quadrature
        ∇φ_ξ = shape_functions.∇φ_ξ(ξ)
        ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
        J_e = J(∇φ_ξ, X)
        det_J_e = detJ(∇φ_ξ, X)
        # @show ∇φ_X ∇φ_X
        # @show J_e
        # @show det_J_e
        # @show J_e
        # @show det_J_e

        @test det_J_e ≈ 0.25
    end
end