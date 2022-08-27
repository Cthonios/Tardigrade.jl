using Tardigrade
using Tardigrade.BoundaryConditions
using Tardigrade.Meshes
using Tardigrade.Quadratures
using Tardigrade.ShapeFunctions

f(x) = 1.

@tardigrade_test_set "Poisson Problem" begin
    input_settings = parse_input_file("./input_file/test_input_file.yaml")
    mesh = Mesh(input_settings["mesh"])
    shape_functions = ShapeFunction(input_settings["shape functions"], "quad4")
    quadrature = Quadrature(input_settings["quadrature"], "quad4")
    bcs = DirichletBCs(input_settings["boundary conditions"], mesh)
end