module Tardigrade

include("parser/Parser.jl")
include("mesh/Mesh.jl")
# include("connectivity/Connectivity.jl")
include("sections/Sections.jl")
include("boundary_conditions/BoundaryConditions.jl")
include("kernels/Kernels.jl")
include("systems/Systems.jl")

import Tardigrade.Parser: read_input_file, 
                          parse_mesh_block, 
                          parse_variables_block,
                          parse_sections_block,
                          parse_kernels_block,
                          parse_boundary_conditions_block
import Tardigrade.Mesh: initialize_mesh
import Tardigrade.Sections: Section, initialize_sections
import Tardigrade.BoundaryConditions: initialize_boundary_conditions,
                                      update_bcs_solution!,
                                      update_bcs_residual!,
                                      update_bcs_tangent!
import Tardigrade.Kernels: initialize_kernels
# import Tardigrade.Systems: initialize_system
import Tardigrade.Systems: poisson_problem

function tardigrade(input_file::String)
    @show input_file
    input_settings = Parser.read_input_file(input_file)

    @time mesh = initialize_mesh(parse_mesh_block(input_settings))
    @time sections = initialize_sections(parse_sections_block(input_settings), mesh)
    @time bcs = initialize_boundary_conditions(parse_boundary_conditions_block(input_settings), mesh)
    @time kernels = initialize_kernels(parse_kernels_block(input_settings))
    @time poisson_problem(mesh.N_n, sections, bcs, kernels)

    println()
end

end # module
