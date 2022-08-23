test_set_name = rpad("Assembly.jl - DenseStaticAssembly", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    # sections = settings["sections"]
    sections = CellSections(settings["sections"], mesh)
    assembly = DenseStaticAssembly(mesh, sections)

    zero!(assembly)
    assemble!(assembly, sections[1])

    @show size(assembly.K)
    @show size(assembly.F)
end