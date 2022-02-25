using Test

include("./mesh/test_mesh.jl")
include("./quadrature_templates/test_quadrature.jl")
include("./function_spaces/test_function_spaces.jl")

test_set_name = rpad("mesh io", 64)
@testset "$test_set_name" begin
    test_square_meshes()
end

test_set_name = rpad("quadrature templates correctness", 64)
@testset "$test_set_name" begin
    test_quad_element_quadrature_template()
end

test_set_name = rpad("function space correctness tests", 64)
@testset "$test_set_name" begin
    test_quad_element_reference_element()
end
