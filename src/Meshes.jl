"""
`Meshes`

Module for storing mesh containers
"""
module Meshes

export Connectivity
export ConnectivityStatic
export Coordinates
export CoordinatesStatic
export ElementLevelNodalValues
export ElementLevelNodalValuesStatic
export Mesh
export MeshStatic

using Base
using Exodus
using StaticArrays

"""
`FEMContainer`
"""
abstract type FEMContainer end
abstract type AbstractCoordinates <: FEMContainer end
abstract type AbstractConnectivity <: FEMContainer end
abstract type AbstractElementLevelNodalValues <: FEMContainer end

"""
`Connectivity`

Interface\n
`Base.getindex(c::Connectivity, element::Int64)`\n
`Base.getindex(c::Connectivity, element::Int64, node::Int64)`\n
`Base.iterate(c::Connectivity, element=1)`\n
`Base.length(c::Connectivity)`\n
`Base.size(c::Connectivity)`\n
`Base.size(c::Connectivity, dim::Int)`\n
"""
struct Connectivity <: AbstractConnectivity
    connectivity::Matrix{Int64}
    function Connectivity(block::Exodus.Block)
        new_conn = reshape_block_connectivity(block)
        return new(new_conn)
    end
end

struct ConnectivityStatic{N} <: AbstractConnectivity
    connectivity::Vector{SVector{N,Int64}}
    function ConnectivityStatic(block::Exodus.Block)
        new_conn = reshape_block_connectivity_static(block, block.num_nodes_per_elem)
        return new{block.num_nodes_per_elem}(new_conn)
    end
end

Base.getindex(c::AbstractConnectivity, element::Int64) = c.connectivity[element, :]
Base.getindex(c::AbstractConnectivity, element::Int64, node::Int64) = c.connectivity[element, node]
Base.iterate(c::AbstractConnectivity, element=1) = element > size(c.connectivity, 1) ? nothing : (c.connectivity[element, :], element + 1)
Base.length(c::AbstractConnectivity) = size(c.connectivity, 1)
Base.size(c::AbstractConnectivity) = size(c.connectivity)
Base.size(c::AbstractConnectivity, dim::Int) = dim > 2 ? error("connectivity array is 2D") : size(c.connectivity, dim)

Base.getindex(c::ConnectivityStatic, element::Int64) = c.connectivity[element]
Base.getindex(c::ConnectivityStatic, element::Int64, node::Int64) = c.connectivity[element][node]
Base.iterate(c::ConnectivityStatic, element=1) = element > length(c.connectivity) ? nothing : (c.connectivity[element], element + 1)

"""
`Coordinates`

Interface\n
`Base.getindex(c::Coordinates, node::Int64)`\n
`Base.getindex(c::Coordinates, node::Int64, dim::Int64)`\n
`Base.getindex(c::Coordinates, conn::Connectivity)`\n
`Base.iterate(c::Coordinates, node=1)`\n
`Base.length(c::Coordinates)`\n
`Base.size(c::Coordinates)`\n
`Base.size(c::Coordinates, dim::Int64)`\n
"""
struct Coordinates <: AbstractCoordinates
    coordinates::Matrix{Float64}
    function Coordinates(coords::Matrix{Float64})
        return new(coords)
    end
end

struct CoordinatesStatic{D} <: AbstractCoordinates
    coordinates::Vector{SVector{D}}
    function CoordinatesStatic(coords::Matrix{Float64})
        new_coords = Vector{SVector{size(coords, 2)}}(undef, size(coords, 1))
        for n = 1:size(coords, 1)
            new_coords[n] = coords[n, :]
        end
        return new{size(coords, 2)}(new_coords)
    end
end

# abstract interface for coordinates
Base.getindex(c::AbstractCoordinates, node::Int64) = c.coordinates[node, :]
Base.getindex(c::AbstractCoordinates, node::Int64, dim::Int64) = c.coordinates[node, dim]
Base.getindex(c::AbstractCoordinates, conn::Connectivity) = c.coordinates[conn.connectivity, :]
Base.iterate(c::AbstractCoordinates, node=1) = node > size(c.coordinates, 1) ? nothing : (c.coordinates[node, :], node + 1)
Base.length(c::AbstractCoordinates) = size(c.coordinates, 1)
Base.size(c::AbstractCoordinates) = size(c.coordinates)
Base.size(c::AbstractCoordinates, dim::Int64) = dim > 2 ? error("coordinates array is 2D") : size(c.coordinates, dim)
# overriding a few methods for the static type

Base.getindex(c::CoordinatesStatic, node::Int64) = c.coordinates[node]
Base.getindex(c::CoordinatesStatic, node::Int64, dim::Int64) = c.coordinates[node][dim]
# Base.getindex(c::CoordinatesStatic, conn::ConnectivityStatic) = c.coordinates[conn.connectivity]
Base.getindex(c::CoordinatesStatic, conn::SVector) = c.coordinates[conn][:]

"""
`ElementLevelNodalValues`

Interface\n
`Base.getindex(values::ElementLevelNodalValues, element::Int64)`\n
`Base.iterate(values::ElementLevelNodalValues, element=1)`\n
`Base.length(values::ElementLevelNodalValues)`\n
`Base.size(values::ElementLevelNodalValues)`\n
`Base.size(values::ElementLevelNodalValues, dim::Int64)`\n
"""
struct ElementLevelNodalValues{T} <: AbstractElementLevelNodalValues
    values::Array{Float64,T}
    function ElementLevelNodalValues(coords::Coordinates, conns::Connectivity)
        values = coords[conns]
        return new{3}(values)
    end
    function ElementLevelNodalValues(values::Vector{Float64}, conns::Connectivity)
        new_values = values[conns.connectivity]
        @show size(new_values)
        return new{2}(new_values)
    end
    # function ElementLevelNodalValues(conns::Connectivity)

    # end
    # function ElementLevelNodalValues(values::Matrix{Float64}, conns::Connectivity)
    #     new_values = values[conns.connectivity, :]
    #     return new(new_values)
    # end
end

struct ElementLevelNodalValuesStatic{N,D} <: AbstractElementLevelNodalValues
    values::Vector{SMatrix{N,D,Float64}}
    function ElementLevelNodalValuesStatic(coords::CoordinatesStatic, conns::ConnectivityStatic)
        N, D = length(conns[1]), length(coords[1]) # just grab the first element sizes
        values = Vector{SMatrix{N,D,Float64}}(undef, length(coords))
        for (n, conn) in enumerate(conns)
            # @show conn
            # values[n] = coords[conn]
            # @show conn
            # @show coords.coordinates[conn]
            # @show coords[conn]
            @show length(coords)
            # @show size(coords[[1 2]])``
            @show N
            @show D
            @show size(coords[conn])
            # @show coords[conn, :]
            # values[n] = coords[conn]
        end
        return new{N,D}(values)
    end
    # function ElementLevelNodalValuesStatic(values::Matrix{Float64}, conns::ConnectivityStatic)
    #     new_values = values[conns.connectivity, :]
    #     return new(new_values)
    # end
end

Base.getindex(values::ElementLevelNodalValues{2}, element::Int64) = values.values[element, :]
Base.getindex(values::ElementLevelNodalValues{3}, element::Int64) = values.values[element, :, :]
Base.iterate(values::ElementLevelNodalValues{2}, element=1) = element > size(values, 1) ? nothing : (values.values[element, :], element + 1)
Base.iterate(values::ElementLevelNodalValues{3}, element=1) = element > size(values, 1) ? nothing : (values.values[element, :, :], element + 1)
Base.length(values::ElementLevelNodalValues) = size(values.values, 1)
Base.size(values::ElementLevelNodalValues) = size(values.values)
Base.size(values::ElementLevelNodalValues, dim::Int64) = dim > 3 ? error("ElementLevelNodalValues value array is 2D or 3D") : size(values.values, dim)


"""
`Mesh`

TODO add side set support among other things that might be useful
"""
struct Mesh <: FEMContainer
    coordinates::Coordinates
    blocks::Vector{Exodus.Block}
    node_sets::Vector{Exodus.NodeSet}
    function Mesh(mesh_settings::Dict{Any,Any})
        if lowercase(mesh_settings["type"]) == "exodus"
            coords, blocks, node_sets = read_exodus_mesh(mesh_settings)
            coords = Coordinates(coords) # convert to the Tardigrade container
            # TODO: specify static vs. non-static coordinates
            return new(coords, blocks, node_sets)
        else
            @show mesh_settings
            error("Unsupported mesh type" * mesh_settings["type"])
        end
    end
end

struct MeshStatic <: FEMContainer
    coordinates::CoordinatesStatic
    blocks::Vector{Exodus.Block}
    node_sets::Vector{Exodus.NodeSet}
    function MeshStatic(mesh_settings::Dict{Any,Any})
        if lowercase(mesh_settings["type"]) == "exodus"
            coords, blocks, node_sets = read_exodus_mesh(mesh_settings)
            coords = CoordinatesStatic(coords) # convert to the Tardigrade container
            return new(coords, blocks, node_sets)
        else
            @show mesh_settings
            error("Unsupported mesh type" * mesh_settings["type"])
        end
    end
end


"""
`read_exodus_mesh(mesh_settings::Dict{Any,Any})`

reads an exodus database and currently returns the 
set of nodal coordinates, blocks, and node node_sets
in the database. TODO: add side sets and potentially other
stuff from exodus. This is light weight currently
"""
function read_exodus_mesh(mesh_settings::Dict{Any,Any})
    file_name = abspath(mesh_settings["file name"])
    exo = Exodus.open_exodus_database(file_name)
    init = Exodus.Initialization(exo)
    coords = Exodus.read_coordinates(exo, init.num_dim, init.num_nodes)
    block_ids = Exodus.read_block_ids(exo, init.num_elem_blk)
    blocks = Exodus.read_blocks(exo, block_ids)
    node_set_ids = Exodus.read_node_set_ids(exo, init.num_node_sets)
    node_sets = Exodus.read_node_sets(exo, node_set_ids)
    Exodus.close_exodus_database(exo)
    return coords, blocks, node_sets
end

"""
TODO add VTK support for those weirdos that may want it
over exodus
"""

"""
`reshape_block_connectivity!(conn::Vector{Int64}, new_conn::Matrix{Int64})`

In place initialization for robustness.
"""
#TODO change method signature so the in place is the first arg
function reshape_block_connectivity!(conn::Vector{Int64}, new_conn::Matrix{Int64})
    for n = 1:size(new_conn, 1)
        new_conn[n, :] = conn[(n - 1) * size(new_conn, 2) + 1:n * size(new_conn, 2)]
    end
end

function reshape_block_connectivity_static!(conn::Vector{Int64}, new_conn, N) # add type to new_conn
# function reshape_block_connectivity_static!(conn::Vector{Int64}, new_conn::Vector{SVector{N,Int64}}) where {N}
    for n = 1:length(new_conn)
        new_conn[n] = conn[(n - 1) * N + 1:n * N]
    end
end

"""
`reshape_block_connectivity(block::Exodus.Block)::Matrix{Int64}`

Interface for initializing the connectivity array for a block. Will return a matrix where
rows are the elements and columns are the nodes. TODO Maybe the transpose is more efficient in julia?
"""
function reshape_block_connectivity(block::Exodus.Block)::Matrix{Int64}
    new_conn = zeros(Int64, block.num_elem, block.num_nodes_per_elem)
    reshape_block_connectivity!(block.conn, new_conn)
    return new_conn
end

function reshape_block_connectivity_static(block::Exodus.Block, N::Int64)
    new_conn = Vector{SVector{N}}(undef, block.num_elem)
    reshape_block_connectivity_static!(block.conn, new_conn, N)
    return new_conn
end

end # module