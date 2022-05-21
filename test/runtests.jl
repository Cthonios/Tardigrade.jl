using Test

using Tardigrade.Parser
using Tardigrade.Meshes
# using Tardigrade.Quadratures

test_set_name = rpad("Parser.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
end

test_set_name = rpad("Meshes.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    @show pwd()
    mesh = Meshes.Mesh(settings["mesh"])
    @show mesh
end