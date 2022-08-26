using Tardigrade.Meshes

@tardigrade_test_set "SingleBlockExodusMesh" begin
    @time mesh = SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")
    @time mesh = SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")

    @time element_coords = element_level_coordinates(mesh)
    @time element_coords = element_level_coordinates(mesh)

    @show "here"
    @time begin
        for e in 1:size(mesh.connectivity, 1)
            element_coords = element_level_coordinates(mesh, e)
        end
    end

    @time begin
        for e in 1:size(mesh.connectivity, 1)
            element_conn = element_level_connectivity(mesh, e)
        end
    end

end