using Tardigrade.Parser

input_file_names = ["./parser/test_input_file.yaml"]

function test_input_files()
    for input_file in input_file_names
        test_set_name = rpad(input_file, 64)
        @testset "$test_set_name" begin
            test_input_file_parser(input_file)
        end
    end
end


function test_input_file_parser(input_file)
    input_settings = Parser.read_input_file(input_file)
    @test typeof(input_settings) == Dict{Any, Any}
    test_mesh_parser(input_file)
    test_variables_parser(input_file)
end


function test_mesh_parser(input_file)
    # TODO add code to check for file existness
    # TODO add test for above code
end

function test_variables_parser(input_file)

end
