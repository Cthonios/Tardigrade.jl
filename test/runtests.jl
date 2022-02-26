using Test

include("./parser/test_parser.jl")
include("./mesh/test_mesh.jl")
include("./quadrature_templates/test_quadrature.jl")
include("./function_spaces/test_function_spaces.jl")
include("./boundary_conditions/test_boundary_conditions.jl")

# figure out how to make this macro work!
#
# macro run_test_set(test_set_name, func)
#     test_set_name = rpad(test_set_name, 64)
#     @testset "$test_set_name" begin
#         # test_input_files()
#         return :($(func)(;))
#     end
# end

test_set_name = rpad("parser", 64)
@testset "$test_set_name" begin
    test_input_files()
end
# @run_test_set("parser", test_input_files)

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
    test_quad_calculate_shape_function_values()
    test_quad_calculate_shape_function_gradients()
    test_J_on_quad_element()
end

test_set_name = rpad("boundary conditions tests", 64)
@testset "$test_set_name" begin
    test_boundary_conditions_input_files()
end
