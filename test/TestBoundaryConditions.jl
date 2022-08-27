using Tardigrade
using Tardigrade.BoundaryConditions
using Tardigrade.Meshes

@tardigrade_test_set "BoundaryConditions.jl - ConstantDirichletBCs" begin
    mesh = SingleBlockExodusMesh("./mesh/mesh_test_0.125.g")
    settings = parse_input_file("./input_file/test_input_file.yaml")
    bcs = DirichletBCs(settings["boundary conditions"], mesh)

    R = ones(Float64, size(mesh.nodal_coordinates, 1))
    J = zeros(Float64, size(mesh.nodal_coordinates, 1), size(mesh.nodal_coordinates, 1))

    for bc in bcs
        @test bc.value ≈ 0.0
        update_residual!(R, bc)
        update_jacobian!(J, bc)
    end

    for bc in bcs
        for node in bc.nodes
            @test R[node] ≈ 0.0
            @test J[node, node] ≈ 1.0
        end
    end
end