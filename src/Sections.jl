"""
`Sections`
"""
module Sections

export CellSection
export CellSections
export volume

using Exodus

import ..Meshes: Coordinates
import ..Meshes: Connectivity
import ..Meshes: ElementLevelNodalValues
import ..Meshes: FEMContainer
import ..Meshes: Mesh
import ..Quadratures: Quadratures 
import ..ShapeFunctions: ShapeFunctionValuesAndGradients

"""
`Section`
"""
abstract type Section <: FEMContainer end

# maybe generalize this a bit to include the different shape functions containers we made.

"""
`CellSection`
"""
mutable struct CellSection <: Section
    coordinates::ElementLevelNodalValues
    connectivity::Connectivity
    φ::Matrix{Float64}
    ∇φ_X::Array{Float64,4}
    JxW::Matrix{Float64}
    u::ElementLevelNodalValues
    function CellSection(section_settings::Dict{Any,Any}, mesh::Mesh)
        block_ids = findall(x -> x.block_id == section_settings["block"], mesh.blocks)
        if length(block_ids) > 1
            error("only single block sections are currently supported")
        end
        block_id = block_ids[1]

        quadrature = Quadratures.Quadrature(mesh.blocks[block_id].elem_type, section_settings["quadrature order"])
        connectivity = Connectivity(mesh.blocks[block_id])
        coordinates = ElementLevelNodalValues(mesh.coordinates, connectivity)
        shape_functions = ShapeFunctionValuesAndGradients(mesh.blocks[block_id].elem_type,
                                                          quadrature, coordinates)

        # don't create temps, it will eat up memory, I think?
        return new(coordinates, connectivity,
                   shape_functions.φ, shape_functions.∇φ_X, shape_functions.JxW)
    end
end

Base.getindex(c::CellSection, e::Int64) = (c.coordinates[e], c.connectivity[e], c.φ, c.∇φ_X[e, :, :, :], c.JxW[e, :], c.u[e])
# Base.iterate(c::CellSection, e=1) = e
Base.length(c::CellSection) = length(c.connectivity)
volume(c::CellSection) = sum(c.JxW)

"""
`CellSections`
"""
mutable struct CellSections
    sections::Vector{CellSection}
    function CellSections(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
        return new(initialize_cell_sections(sections_settings, mesh))
    end
end

Base.getindex(c::CellSections, s::Int64) = c.sections[s]
Base.iterate(c::CellSections, s=1) = s > length(c.sections) ? nothing : (c.sections[s], s + 1)
Base.length(c::CellSections) = length(c.sections)
volume(c::CellSections) = volume.(c) |> sum

# CellSections = Vector{CellSection}

"""
`initialize_cell_sections!(cell_sections::Vector{CellSection}, sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)`
"""
function initialize_cell_sections!(cell_sections::Vector{CellSection},
                                   sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    for (n, section) in enumerate(sections_settings)
        cell_sections[n] = CellSection(section, mesh)
    end
end

"""
`initialize_cell_sections(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)`
"""
function initialize_cell_sections(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    cell_sections = Vector{CellSection}(undef, length(sections_settings))
    initialize_cell_sections!(cell_sections, sections_settings, mesh)
    return cell_sections
end

end # module