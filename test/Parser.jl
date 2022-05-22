test_set_name = rpad("Parser.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    Parser.parse_input_file("input_file/test_input_file.yaml")
end