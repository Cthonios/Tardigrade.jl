"""
`Sections`
"""
module Sections

export initialize_cell_sections

# import Exouds: Block
import ..Meshes: Coordinates
import ..Meshes: Connectivity
import ..Meshes: FEMContainer
import ..Meshes: Mesh
import ..ShapeFunctions: ShapeFunctionValuesAndGradients

abstract type Section <: FEMContainer end

struct CellSection <: Section
    coordinates::Coordinates
    connectivity::Connectivity
    φ::Matrix{Float64}
    ∇φ_X::Array{Float64,4}
    JxW::Matrix{Float64}
    function CellSection(section_settings::Dict{Any,Any}, mesh::Mesh)
        @show section_settings

    end
end

# CellSections = Vector{CellSection}

function initialize_cell_sections!(cell_sections::Vector{CellSection},
                                   sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    for (n, section) in enumerate(sections_settings)
        @show section
    end
end

function initialize_cell_sections(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    cell_sections = Vector{CellSection}(undef, length(sections_settings))
    initialize_cell_sections!(cell_sections, sections_settings, mesh)
end

end # module