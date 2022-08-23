using Tardigrade

# @time mesh = Meshes.SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")
# @time mesh = Meshes.SingleBlockExodusMesh("./mesh/mesh_test_0.0078125.g")

@time mesh = Meshes.SingleBlockExodusMesh("./mesh/mesh_test_0.25.g")
@time mesh = Meshes.SingleBlockExodusMesh("./mesh/mesh_test_0.25.g")

@time element_coords = Meshes.element_level_coordinates(mesh)
@time element_coords = Meshes.element_level_coordinates(mesh)

@show element_coords
