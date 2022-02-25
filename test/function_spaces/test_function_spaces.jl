using Test
using LinearAlgebra
using Tardigrade.QuadratureTemplates
using Tardigrade.FunctionSpaces

# TODO: add tri 3 element tests

function quad4_shape_function_methods()
    return FunctionSpaces.function_space_factory("QUAD4")
end

function quad_element_simple(element_length)
    coords = zeros(Float64, 4, 2)
    coords[2, 1] = element_length
    coords[3, 1] = element_length
    coords[3, 2] = element_length
    coords[4, 2] = element_length
    return coords
end

function test_quad_calculate_shape_function_values()
    one = 1.0
    fourth = 1.0 / 4.0
    quad = QuadratureTemplates.quadrature_factory("QUAD4", 1)
    function_space_Nξ, _ = quad4_shape_function_methods()
    test_set_name = rpad("QUAD4 q1 shape function values", 64)
    @testset "$test_set_name" begin
        Nξ = function_space_Nξ(quad.ξ[1, :])
        @test Nξ[1] == fourth
        @test Nξ[2] == fourth
        @test Nξ[3] == fourth
        @test Nξ[4] == fourth
    end

    quad = QuadratureTemplates.quadrature_factory("QUAD4", 2)
    function_space_Nξ, _ = quad4_shape_function_methods()
    test_set_name = rpad("QUAD4 q2 shape function values", 64)
    @testset "$test_set_name" begin
        Nξ = function_space_Nξ(quad.ξ[1, :])
        @test Nξ[1] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[2] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[3] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[4] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        Nξ = function_space_Nξ(quad.ξ[2, :])
        @test Nξ[1] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[2] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[3] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[4] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        Nξ = function_space_Nξ(quad.ξ[3, :])
        @test Nξ[1] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[2] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[3] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[4] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        Nξ = function_space_Nξ(quad.ξ[4, :])
        @test Nξ[1] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[2] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test Nξ[3] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test Nξ[4] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
    end
end

function test_quad_calculate_shape_function_gradients()
    one = 1.0
    fourth = 1.0 / 4.0
    quad = QuadratureTemplates.quadrature_factory("QUAD4", 1)
    _, function_space_∇Nξ = quad4_shape_function_methods()
    test_set_name = rpad("QUAD4 q1 shape function values", 64)
    @testset "$test_set_name" begin
        ∇Nξ = function_space_∇Nξ(quad.ξ[1, :])
        @test ∇Nξ[1, 1] == -fourth
        @test ∇Nξ[1, 2] == -fourth
        @test ∇Nξ[2, 1] == fourth
        @test ∇Nξ[2, 2] == -fourth
        @test ∇Nξ[3, 1] == fourth
        @test ∇Nξ[3, 2] == fourth
        @test ∇Nξ[4, 1] == -fourth
        @test ∇Nξ[4, 2] == fourth
    end

    quad = QuadratureTemplates.quadrature_factory("QUAD4", 2)
    _, function_space_∇Nξ = quad4_shape_function_methods()
    test_set_name = rpad("QUAD4 q2 shape function values", 64)
    @testset "$test_set_name" begin
        ∇Nξ = function_space_∇Nξ(quad.ξ[1, :])
        @test ∇Nξ[1, 1] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[1, 2] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[2, 1] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[2, 2] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[3, 1] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[3, 2] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[4, 1] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[4, 2] == fourth * (1.0 + 1.0 / √3)
        ∇Nξ = function_space_∇Nξ(quad.ξ[2, :])
        @test ∇Nξ[1, 1] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[1, 2] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[2, 1] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[2, 2] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[3, 1] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[3, 2] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[4, 1] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[4, 2] == fourth * (1.0 + 1.0 / √3)
        ∇Nξ = function_space_∇Nξ(quad.ξ[3, :])
        @test ∇Nξ[1, 1] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[1, 2] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[2, 1] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[2, 2] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[3, 1] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[3, 2] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[4, 1] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[4, 2] == fourth * (1.0 - 1.0 / √3)
        ∇Nξ = function_space_∇Nξ(quad.ξ[4, :])
        @test ∇Nξ[1, 1] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[1, 2] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[2, 1] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[2, 2] == -fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[3, 1] == fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[3, 2] == fourth * (1.0 + 1.0 / √3)
        @test ∇Nξ[4, 1] == -fourth * (1.0 - 1.0 / √3)
        @test ∇Nξ[4, 2] == fourth * (1.0 - 1.0 / √3)
    end
end

function test_J_on_quad_element()
    quad = QuadratureTemplates.quadrature_factory("QUAD4", 1)
    _, function_space_∇Nξ = quad4_shape_function_methods()
    test_set_name = rpad("QUAD4 q1 J", 64)
    @testset "$test_set_name" begin
        for n = 1:10
            coords = quad_element_simple(1.0 * n)
            one = convert(Int8, 1)
            detJ = FunctionSpaces.detJ(coords, function_space_∇Nξ(quad.ξ[1, :]))
            @test detJ == (n / 2.0)^2
        end
    end
end
