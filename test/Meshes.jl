test_set_name = rpad("Meshes.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    Meshes.Mesh(settings["mesh"])
end