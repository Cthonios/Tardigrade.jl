using Test
using Tardigrade.BoundaryConditions
using Tardigrade.Mesh
using Tardigrade.Parser

input_file_names = ["./boundary_conditions/test_single_node_set_bc.yaml",
                    "./boundary_conditions/test_multiple_node_set_bc.yaml"]

function test_boundary_conditions_input_files()
    for input_file in input_file_names
        test_set_name = rpad(input_file, 64)
        @testset "$test_set_name" begin
            test_boundary_condition_initialization(input_file)
        end
    end
end

function test_boundary_condition_initialization(input_file::String)
    input_settings = Parser.read_input_file(input_file)
    mesh_settings = Parser.parse_mesh_block(input_settings)
    bc_settings = Parser.parse_boundary_conditions_block(input_settings)
    mesh = Mesh.initialize_mesh(mesh_settings)
    for bc in bc_settings
        temp_bc = boundary_condition_factory(bc, mesh)
    end
    @test true
end
