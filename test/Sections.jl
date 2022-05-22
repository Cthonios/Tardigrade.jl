test_set_name = rpad("Sections.jl", 64)
@testset "$test_set_name" begin
    settings = Parser.parse_input_file("input_file/test_input_file.yaml")
    mesh = Meshes.Mesh(settings["mesh"])
    sections = settings["sections"]

    @show mesh.blocks
    @show mesh.blocks[1].block_id

    cell_sections = initialize_cell_sections(sections, mesh)
    # for section in sections
    #     @show section

    #     # blocks = findall(x -> x.block_id == section["block"], mesh.blocks)
    #     # if length(blocks) > 1
    #     #     error("only one block per section is currently supported. To be addressed.")
    #     # end
    # end
end