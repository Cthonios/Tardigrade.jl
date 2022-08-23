module Meshes

export AbstractMesh
export ExodusMesh
export SingleBlockExodusMesh

using Exodus

# building type hierarchy of meshes so if someone
# wanted a different format they could add it
abstract type AbstractMesh end
abstract type ExodusMesh <: AbstractMesh end

struct SingleBlockExodusMesh{I, F} <: AbstractMesh
    nodal_coordinates::Matrix{F}
    connectivity::Matrix{I}
    node_sets::Vector{Exodus.NodeSet{I, I}}
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

        return new{Int32, Float64}(nodal_coordinates, conn, node_sets) # TODO dispatch this better
    end
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

# need this to have block be a different Matrix
element_level_coordinates(exo::SingleBlockExodusMesh) = @view exo.nodal_coordinates[exo.connectivity, :]

# function element_level_coordinates

end # module