module Mesh

using Exodus

export initialize_mesh
export MeshStruct

struct MeshStruct
    Nₙ::Int64              # number of nodes
    Nₑ::Int64              # number of elements
    N_blocks::Int64
    N_node_sets::Int64
    coords::Array{Float64} # coordinates
    blocks::Exodus.Blocks
    node_sets::Exodus.NodeSets
end

function initialize_mesh(file_name::String)::MeshStruct
    message = rpad("Setting up mesh...", 48)
    print(message)

    exo_id = Exodus.open_exodus_database(file_name)

    init = Exodus.Initialization(exo_id)

    coords = Exodus.read_coordinates(exo_id, init.num_dim, init.num_nodes)

    block_ids = Exodus.read_block_ids(exo_id, init.num_elem_blk)
    blocks = Exodus.read_blocks(exo_id, block_ids)

    node_set_ids = Exodus.read_node_set_ids(exo_id, init.num_node_sets)
    node_sets = Exodus.read_node_sets(exo_id, node_set_ids)

    Exodus.close_exodus_database(exo_id)

    return MeshStruct(init.num_nodes, init.num_nodes, size(blocks, 1), size(node_sets, 1),
                      coords, blocks, node_sets)
end

end
