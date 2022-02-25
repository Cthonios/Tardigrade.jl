using Test
using Tardigrade.FunctionSpaces

# TODO: add tri 3 element tests

function quad4_reference_element(quadrature_order::Int8)
    return FunctionSpaces.reference_element_factory("QUAD4", quadrature_order)
end

function test_quad_element_reference_element()
    one = 1.0
    fourth = 1.0 / 4.0
    element = quad4_reference_element(convert(Int8, 1))
    test_set_name = rpad("QUAD4 q1 shape function values", 64)
    @testset "$test_set_name" begin
        @test element.Nξ[1, 1] == fourth
        @test element.Nξ[2, 1] == fourth
        @test element.Nξ[3, 1] == fourth
        @test element.Nξ[4, 1] == fourth
    end

    test_set_name = rpad("QUAD4  q1 shape function gradients", 64)
    @testset "$test_set_name" begin
        @test element.∇Nξ[1, 1, 1] == -fourth
        @test element.∇Nξ[1, 2, 1] == -fourth
        @test element.∇Nξ[2, 1, 1] == fourth
        @test element.∇Nξ[2, 2, 1] == -fourth
        @test element.∇Nξ[3, 1, 1] == fourth
        @test element.∇Nξ[3, 2, 1] == fourth
        @test element.∇Nξ[4, 1, 1] == -fourth
        @test element.∇Nξ[4, 2, 1] == fourth
    end

    element = quad4_reference_element(convert(Int8, 2))
    test_set_name = rpad("QUAD4 q2 shape function values", 64)
    @testset "$test_set_name" begin
        @test element.Nξ[1, 1] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[2, 1] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[3, 1] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[4, 1] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        #
        @test element.Nξ[1, 2] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[2, 2] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[3, 2] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[4, 2] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        #
        @test element.Nξ[1, 3] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[2, 3] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[3, 3] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[4, 3] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        #
        @test element.Nξ[1, 4] == fourth * (1.0 - 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[2, 4] == fourth * (1.0 + 1.0 / √3) * (1.0 + 1.0 / √3)
        @test element.Nξ[3, 4] == fourth * (1.0 + 1.0 / √3) * (1.0 - 1.0 / √3)
        @test element.Nξ[4, 4] == fourth * (1.0 - 1.0 / √3) * (1.0 - 1.0 / √3)
    end

    test_set_name = rpad("QUAD4  q2 shape function gradients", 64)
    @testset "$test_set_name" begin
        @test element.∇Nξ[1, 1, 1] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[1, 2, 1] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[2, 1, 1] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[2, 2, 1] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[3, 1, 1] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[3, 2, 1] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[4, 1, 1] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[4, 2, 1] == fourth * (1.0 + 1.0 / √3)
        #
        @test element.∇Nξ[1, 1, 2] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[1, 2, 2] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[2, 1, 2] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[2, 2, 2] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[3, 1, 2] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[3, 2, 2] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[4, 1, 2] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[4, 2, 2] == fourth * (1.0 + 1.0 / √3)
        #
        @test element.∇Nξ[1, 1, 3] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[1, 2, 3] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[2, 1, 3] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[2, 2, 3] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[3, 1, 3] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[3, 2, 3] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[4, 1, 3] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[4, 2, 3] == fourth * (1.0 - 1.0 / √3)
        #
        @test element.∇Nξ[1, 1, 4] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[1, 2, 4] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[2, 1, 4] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[2, 2, 4] == -fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[3, 1, 4] == fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[3, 2, 4] == fourth * (1.0 + 1.0 / √3)
        @test element.∇Nξ[4, 1, 4] == -fourth * (1.0 - 1.0 / √3)
        @test element.∇Nξ[4, 2, 4] == fourth * (1.0 - 1.0 / √3)
    end
end
