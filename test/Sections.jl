test_set_name = rpad("Sections.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    sections = settings["sections"]

    @time cell_section = CellSection(sections[1], mesh)
    @time cell_section = CellSection(sections[1], mesh)

    u = zeros(Float64, length(mesh.coordinates))
    @time u_element_level = ElementLevelNodalValues(u, cell_section.connectivity)
    @time u_element_level = ElementLevelNodalValues(u, cell_section.connectivity)

    cell_section.u = u_element_level

    @time vol = volume(cell_section)
    @time vol = volume(cell_section)

    @test vol == 1.0

    # now testing some CellSections containers

    cell_sections = CellSections(sections, mesh)

    @time vol = volume(cell_sections)
    @time vol = volume(cell_sections)

    @test vol == 1.0
end