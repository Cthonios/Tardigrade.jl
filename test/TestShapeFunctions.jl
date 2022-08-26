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

@tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Mapping" begin
    mesh = SingleBlockExodusMesh("./mesh/mesh_test_1.g")
    X = element_level_coordinates(mesh, 1)
    shape_functions = LagrangeShapeFunction("quad4")
    quadrature = Quadrature("quad4", 1)
    ∇φ_ξ = shape_functions.∇φ(quadrature.ξ[1, :])
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
        ∇φ_ξ = shape_functions.∇φ(ξ)
        ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
        J_e = J(∇φ_ξ, X)
        det_J_e = detJ(∇φ_ξ, X)
        # @show ∇φ_X
        # @show J_e
        # @show det_J_e

        @test det_J_e ≈ 0.25
    end
end

# @tardigrade_test_set "ShapeFunctions.jl - Quad4 Order 1 Mapping" begin
#     mesh = SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")
#     # X = element_level_coordinates(mesh, 1)
#     shape_functions = LagrangeShapeFunction("quad4")
#     quadrature = Quadrature("quad4", 1)
#     # ∇φ_ξ = shape_functions.∇φ(quadrature.ξ[1, :])
#     # @show ∇φ_ξ
#     # @time ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
#     # @time ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
#     # @show ∇φ_X

#     ∇φ_ξ = shape_functions.∇φ(quadrature.ξ[1, :])
#     @time begin
#         for e in 1:size(mesh.connectivity, 1)
#             @show e
#             X = element_level_coordinates(mesh, e)
#             ∇φ_X = map_∇φ_ξ(∇φ_ξ, X)
#         end
#     end
# end