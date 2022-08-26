using Tardigrade.Meshes

@tardigrade_test_set "SingleBlockExodusMesh" begin
    mesh = SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")
    element_coords = element_level_coordinates(mesh)

    for e in 1:size(mesh.connectivity, 1)
        element_coords = element_level_coordinates(mesh, e)
    end

    for e in 1:size(mesh.connectivity, 1)
        element_conn = element_level_connectivity(mesh, e)
    end
end