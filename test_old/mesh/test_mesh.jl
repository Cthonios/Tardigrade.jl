using Suppressor
using Test
using Tardigrade.Mesh

mesh_file_names = ["./mesh/mesh_test_1.g",
                   "./mesh/mesh_test_0.5.g",
                   "./mesh/mesh_test_0.25.g",
                   "./mesh/mesh_test_0.125.g",
                   "./mesh/mesh_test_0.0625.g",
                   "./mesh/mesh_test_0.03125.g",
                   "./mesh/mesh_test_0.015625.g",
                   "./mesh/mesh_test_0.0078125.g"]

number_of_nodes = [4, 9, 25, 81, 289, 1089, 4225, 16641]
number_of_elements = [1, 2^2, 4^2, 8^2, 16^2, 32^2, 64^2, 128^2]

function test_coordinate_dimensions(coords::Array, Nₙ::Int, N_d::Int)
    @test size(coords, 1) == Nₙ
    @test size(coords, 2) == N_d
end


function test_square_mesh(n::Int)
    test_name = rpad("Testing square mesh: $(mesh_file_names[n])", 64)
    @testset "$test_name" begin
        @suppress begin
            # read method test
            #
            exo = Mesh.read_exodus_database(mesh_file_names[n])

            # tests on the simple numbers
            #
            @test exo.num_dimensions() == 2
            @test exo.num_blks() == 1
            @test exo.num_node_sets() == 4
            @test exo.num_side_sets() == 4
            @test exo.num_nodes() == number_of_nodes[n]
            @test exo.num_elems() == number_of_elements[n]

            # test coordinates
            #
            coords = Mesh.read_coordinates(exo)
            test_coordinate_dimensions(coords, number_of_nodes[n], 2)

            # test block initialization
            #
            block = Mesh.initialize_block(exo, 1)
            @test block.block_number == 1
            @test block.Nₑ == number_of_elements[n]
            @test block.Nₙ_per_e == 4
            @test block.element_type == "QUAD4"

            # test node set initialization
            #
            node_set = Mesh.initialize_node_set(exo, 1)
            @test node_set.node_set_number == 1

            # test mesh initialization
            #
            # mesh = Mesh.MeshStruct()

            Mesh.close_exodus_database(exo)
        end
    end

    test_set_name = rpad("Testing square mesh with struct", 64)
    @testset "$test_set_name" begin
        mesh = Mesh.initialize_mesh(mesh_file_names[n])
        @test mesh.Nₙ == number_of_nodes[n]
        @test mesh.Nₑ == number_of_elements[n]
        @test size(mesh.blocks, 1) == 1
        @test size(mesh.nodesets, 1) == 4
    end
end

function test_square_meshes()
    for n = 1:size(mesh_file_names, 1)
        test_square_mesh(n)
    end
end
