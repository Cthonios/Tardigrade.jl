test_set_name = rpad("ShapeFunctions.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])

    # just test on one block
    conn = Connectivity(mesh.blocks[1])

    coords = ElementLevelNodalValues(mesh.coordinates, conn)

    quadrature = Quadrature(mesh.blocks[1].elem_type, 1)
    shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)

    # this simple mesh should have a volume of 1.0
    block_volume = sum(shape_function_values.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_gradients.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_values_and_gradients.JxW)
    @test block_volume == 1.0

    quadrature = Quadrature(mesh.blocks[1].elem_type, 2)
    shape_function_values = ShapeFunctionValues(mesh.blocks[1].elem_type, quadrature, coords)
    shape_function_gradients = ShapeFunctionGradients(mesh.blocks[1].elem_type, quadrature, coords)
    shape_function_values_and_gradients = ShapeFunctionValuesAndGradients(mesh.blocks[1].elem_type, quadrature, coords)

    # this simple mesh should have a volume of 1.0
    block_volume = sum(shape_function_values.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_gradients.JxW)
    @test block_volume == 1.0
    block_volume = sum(shape_function_values_and_gradients.JxW)
    @test block_volume == 1.0
end