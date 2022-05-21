using Test

using Tardigrade.Parser
using Tardigrade.Meshes
using Tardigrade.Quadratures
using Tardigrade.ShapeFunctions

# TODO figure out which modules make sense to make a standalone test input_file
# so this isn't massive


test_set_name = rpad("Parser.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    @time Parser.parse_input_file("input_file/test_input_file.yaml")
    @time Parser.parse_input_file("input_file/test_input_file.yaml")
end

test_set_name = rpad("Meshes.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    @time Meshes.Mesh(settings["mesh"])
    @time Meshes.Mesh(settings["mesh"])
end

# TODO set up tests for each element type, stupid right now it only supports quad4s
test_set_name = rpad("Quadratures.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    element_type = mesh.blocks[1].elem_type

    @time quadrature_rule = Quadratures.Quadrature(element_type, 1)
    @time quadrature_rule = Quadratures.Quadrature(element_type, 1)

    # correctness test, stupid but a sanity check
    @test quadrature_rule.xi[1, 1] == 0.0
    @test quadrature_rule.xi[1, 2] == 0.0
    @test quadrature_rule.w == [4.0]
    
    # interface check on quad4 with q order = 1
    for (xi, w) in quadrature_rule
        @test xi[1] == 0.0
        @test xi[2] == 0.0
        @test w[1] == 4.0
    end

    @test length(quadrature_rule) == 1
    @test length(quadrature_rule) == quadrature_rule.n_q_points

    # correctness test, stupid but a sanity check
    @time quadrature_rule = Quadratures.Quadrature(element_type, 2)
    @time quadrature_rule = Quadratures.Quadrature(element_type, 2)

    @test quadrature_rule.xi[1, 1] == -1.0 / sqrt(3.0)
    @test quadrature_rule.xi[1, 2] == -1.0 / sqrt(3.0)

    @test quadrature_rule.xi[2, 1] == 1.0 / sqrt(3.0)
    @test quadrature_rule.xi[2, 2] == -1.0 / sqrt(3.0)
    
    @test quadrature_rule.xi[3, 1] == 1.0 / sqrt(3.0)
    @test quadrature_rule.xi[3, 2] == 1.0 / sqrt(3.0)

    @test quadrature_rule.xi[4, 1] == -1.0 / sqrt(3.0)
    @test quadrature_rule.xi[4, 2] == 1.0 / sqrt(3.0)

    @test quadrature_rule.w == [1.0, 1.0, 1.0, 1.0]

    for (xi, w) in quadrature_rule
        # just to test looping on this boy
    end

    @test length(quadrature_rule) == 4
    @test length(quadrature_rule) == quadrature_rule.n_q_points
end

test_set_name = rpad("ShapeFunctions.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])

    # just test on one block
    @time conn = Connectivity(mesh.blocks[1])
    @time conn = Connectivity(mesh.blocks[1])

    @time coords = ElementLevelNodalValues(mesh.coordinates, conn)
    @time coords = ElementLevelNodalValues(mesh.coordinates, conn)

    quadrature = Quadrature(mesh.blocks[1].elem_type, 1)
    @time shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)

    @time begin
        for (φ, JxW) in shape_function_values
        end
    end

    @time begin
        for (φ, JxW) in shape_function_values
        end
    end

    @time begin
        for (∇φ, JxW) in shape_function_gradients
        end
    end

    @time begin
        for (∇φ, JxW) in shape_function_gradients
        end
    end

    @time begin
        for (φ, ∇φ, JxW) in shape_function_values_and_gradients
        end
    end

    @time begin
        for (φ, ∇φ, JxW) in shape_function_values_and_gradients
        end
    end

    # this simple mesh should have a volume of 1.0
    block_volume = sum(shape_function_values.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_gradients.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_values_and_gradients.JxW)
    @test block_volume == 1.0

    quadrature = Quadrature(mesh.blocks[1].elem_type, 2)
    @time shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)
    @time shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)

    @time begin
        for (φ, JxW) in shape_function_values
        end
    end

    @time begin
        for (φ, JxW) in shape_function_values
        end
    end

    @time begin
        for (∇φ, JxW) in shape_function_gradients
        end
    end

    @time begin
        for (∇φ, JxW) in shape_function_gradients
        end
    end

    @time begin
        for (φ, ∇φ, JxW) in shape_function_values_and_gradients
        end
    end

    @time begin
        for (φ, ∇φ, JxW) in shape_function_values_and_gradients
        end
    end

    # this simple mesh should have a volume of 1.0
    block_volume = sum(shape_function_values.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_gradients.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_values_and_gradients.JxW)
    @test block_volume == 1.0

    
end

test_set_name = rpad("Sections.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    sections = settings["sections"]

    for section in sections
        @show section
    end
end