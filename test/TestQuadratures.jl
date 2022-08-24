@tardigrade_test_set "Quadratures.jl - Quadrature" begin
    @time quadrature_rule = Quadratures.Quadrature("quad4", 1)
    @time quadrature_rule = Quadratures.Quadrature("quad4", 1)

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

    # correctness test, stupid but a sanity check
    @time quadrature_rule = Quadratures.Quadrature("quad4", 2)
    @time quadrature_rule = Quadratures.Quadrature("quad4", 2)

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
end
