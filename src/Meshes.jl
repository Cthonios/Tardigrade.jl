module Meshes

export AbstractMesh
export ExodusMesh
export SingleBlockExodusMesh

export element_level_connectivity
export element_level_coordinates

using Exodus

"""
    AbstractMesh
Parent type for all meshes.
"""
abstract type AbstractMesh end
"""
    AbstractExodusMesh
Parent type for all different exodus meshes.
"""
abstract type AbstractExodusMesh <: AbstractMesh end

"""
    SingleBlockExodusMesh{I, F}
Exodus mesh that only has a single block, good for eductational purposes.
"""
struct SingleBlockExodusMesh{I, F} <: AbstractExodusMesh
    nodal_coordinates::Matrix{F}
    connectivity::Matrix{I}
    node_sets::Vector{Exodus.NodeSet{I, I}}
end

"""
    SingleBlockExodusMesh
Exodus mesh that only has a single block.
# Arguments
- `file_name::String`: string of absolute path of mesh file name.
"""
function SingleBlockExodusMesh(file_name::String)
    exo = ExodusDatabase(file_name, "r")
    init = Initialization(exo)
    nodal_coordinates = Exodus.read_coordinates(exo, init)
    block_ids = Exodus.read_block_ids(exo, init)
    if length(block_ids) > 1
        error("This only supports single block meshes")
    end
    block = Exodus.read_blocks(exo, Exodus.read_block_ids(exo, init))[1]
    conn = convert_connectivity(block)
    node_sets = Exodus.read_node_sets(exo, Exodus.read_node_set_ids(exo, init))
    close(exo)
    return SingleBlockExodusMesh{Int32, Float64}(nodal_coordinates, conn, node_sets)
end

function convert_connectivity!(conn_out::Matrix{I}, block::Exodus.Block{I, I}) where {I <: Exodus.ExoInt}
    for e in 1:block.num_elem
        conn_out[e, :] = block.conn[(e - 1) * size(conn_out, 2) + 1:e * size(conn_out, 2)]
    end
end

function convert_connectivity(block::Exodus.Block{I, I}) where {I <: Exodus.ExoInt}
    conn_out = Matrix{I}(undef, block.num_elem, block.num_nodes_per_elem)
    convert_connectivity!(conn_out, block)
    return conn_out
end


"""
    element_level_connectivity
# Arguments
- `mesh::SingleBlockExodusMesh`: exodus mesh object
- `e::T`: element id, can be either Int32 or Int64
"""
element_level_connectivity(mesh::SingleBlockExodusMesh, e::T) where {T <: Integer} = @view mesh.connectivity[e, :]

# need this to have block be a different Matrix

"""
    element_level_coordinates
# Arguments
- `mesh::SingleBlockExodusMesh`: exodus mesh object
"""
element_level_coordinates(mesh::SingleBlockExodusMesh) = @view mesh.nodal_coordinates[mesh.connectivity, :]
"""
    element_level_coordinates
# Arguments
- `mesh::SingleBlockExodusMesh`: exodus mesh object
- `e::T`: element id, can be either Int32 or Int64
"""
element_level_coordinates(mesh::SingleBlockExodusMesh, e::T) where {T <: Integer} = @view mesh.nodal_coordinates[element_level_connectivity(mesh, e), :]

end # module