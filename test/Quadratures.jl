test_set_name = rpad("Quadratures.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    element_type = mesh.blocks[1].elem_type

    quadrature_rule = Quadratures.Quadrature(element_type, 1)

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
    quadrature_rule = Quadratures.Quadrature(element_type, 2)

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