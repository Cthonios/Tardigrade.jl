test_set_name = rpad("Meshes.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    @time mesh = Meshes.Mesh(settings["mesh"])
    @time mesh = Meshes.Mesh(settings["mesh"])

    @time static_mesh = Meshes.MeshStatic(settings["mesh"])
    @time static_mesh = Meshes.MeshStatic(settings["mesh"])

    for n = 1:size(mesh.coordinates, 1)
        for d = 1:size(mesh.coordinates, 2)
            @test mesh.coordinates[n, d] == static_mesh.coordinates[n, d]
        end
    end

    # try out connectivity on one block
    conn = Meshes.Connectivity(mesh.blocks[1])
    conn_static = Meshes.ConnectivityStatic(mesh.blocks[1])

    for e = 1:size(conn, 1)
        for n = 1:size(conn, 2)
            @test conn[e, n] == conn_static[e, n]
        end
    end

    # try out the element level coords
    element_level_coords = Meshes.ElementLevelNodalValues(mesh.coordinates, conn)

    #TODO finish up some static container implementations
    # element_level_coords_static = Meshes.ElementLevelNodalValuesStatic(static_mesh.coordinates, conn_static)

end