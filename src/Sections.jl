"""
`Sections`
"""
module Sections

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


end # module