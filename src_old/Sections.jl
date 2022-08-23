"""
`Sections`
"""
module Sections

export Cell
export CellSection
export CellSection2
export CellSections
export CellSections2
export Section
# export Sections
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
abstract type AbstractCell <: FEMContainer end
abstract type Section <: FEMContainer end
# Sections = Vector{Section}

# maybe generalize this a bit to include the different shape functions containers we made.

"""
`Cell`
"""
mutable struct Cell <: AbstractCell
    coordinates::Matrix{Float64}
    connectivity::Vector{Int64}
    φ::Matrix{Float64}
    ∇φ_X::Array{Float64,3}
    JxW::Vector{Float64}
    u::Vector{Float64}
    # ∇u::Matrix{Float64}
end
volume(c::Cell) = sum(c.JxW)

"""
`CellSection2`
"""
mutable struct CellSection2 <: Section
    cells::Vector{Cell}
    function CellSection2(section_settings::Dict{Any,Any}, mesh::Mesh)
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
        # for now initialize to zero
        temp_u = zeros(Float64, size(mesh.coordinates, 1))
        temp_u = ElementLevelNodalValues(temp_u, connectivity)

        cells = Vector{Cell}(undef, length(connectivity))

        for e in 1:length(connectivity)
            cells[e] = Cell(coordinates[e], connectivity[e],
                            shape_functions.φ, shape_functions.∇φ_X[e, :, : ,:], shape_functions.JxW[e, :],
                            temp_u[e])
        end
        return new(cells)
    end
end

Base.getindex(c::CellSection2, e::Int64) = (c.cells[e].coordinates, c.cells[e].connectivity,
                                            c.cells[e].φ, c.cells[e].∇φ_X, c.cells[e].JxW,
                                            c.cells[e].u)
Base.iterate(c::CellSection2, e=1) = e > length(c.cells) ? nothing : (getindex(c, e), e + 1)
Base.length(c::CellSection2) = length(c.cells)
volume(c::CellSection2) = sum([volume(cell) for cell in c.cells])

"""
`CellSections2`
"""
mutable struct CellSections2 <: FEMContainer
    sections::Vector{CellSection2}
    function CellSections2(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
        return new(initialize_cell_sections2(sections_settings, mesh))
    end
end

Base.getindex(c::CellSections2, s::Int64) = c.sections[s]
Base.iterate(c::CellSections2, s=1) = s > length(c.sections) ? nothing : (c.sections[s], s + 1)
Base.length(c::CellSections2) = length(c.sections)
volume(c::CellSections2) = volume.(c) |> sum # the beauty of Julia right here

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
        # for now initialize to zero
        temp_u = zeros(Float64, size(mesh.coordinates, 1))
        temp_u = ElementLevelNodalValues(temp_u, connectivity)
        # don't create temps, it will eat up memory, I think?
        return new(coordinates, connectivity,
                   shape_functions.φ, shape_functions.∇φ_X, shape_functions.JxW,
                   temp_u)
    end
end

Base.getindex(c::CellSection, e::Int64) = (c.coordinates[e], c.connectivity[e], c.φ, c.∇φ_X[e, :, :, :], c.JxW[e, :], c.u[e])
Base.iterate(c::CellSection, e=1) = e > length(c.connectivity) ? nothing : (getindex(c, e), e + 1)
Base.length(c::CellSection) = length(c.connectivity)
volume(c::CellSection) = sum(c.JxW)

"""
`CellSections`
"""
mutable struct CellSections <: FEMContainer
    sections::Vector{CellSection}
    function CellSections(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
        return new(initialize_cell_sections(sections_settings, mesh))
    end
end

Base.getindex(c::CellSections, s::Int64) = c.sections[s]
Base.iterate(c::CellSections, s=1) = s > length(c.sections) ? nothing : (c.sections[s], s + 1)
Base.length(c::CellSections) = length(c.sections)
volume(c::CellSections) = volume.(c) |> sum # the beauty of Julia right here

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

function initialize_cell_sections2!(cell_sections::Vector{CellSection2},
                                    sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    for (n, section) in enumerate(sections_settings)
        cell_sections[n] = CellSection2(section, mesh)
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

function initialize_cell_sections2(sections_settings::Vector{Dict{Any,Any}}, mesh::Mesh)
    cell_sections = Vector{CellSection2}(undef, length(sections_settings))
    initialize_cell_sections2!(cell_sections, sections_settings, mesh)
    return cell_sections
end

end # module