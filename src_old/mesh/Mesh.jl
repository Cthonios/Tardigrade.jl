module Mesh

import Exodus: Initialization,
               Blocks,
               NodeSets,
               open_exodus_database,
               close_exodus_database,
               read_coordinates,
               read_block_ids,
               read_blocks,
               read_node_set_ids,
               read_node_sets

export initialize_mesh
export MeshStruct

struct MeshStruct
    N_n::Int64              # number of nodes
    N_e::Int64              # number of elements
    N_blocks::Int64
    N_node_sets::Int64
    coords::Array{Float64} # coordinates
    blocks::Blocks
    node_sets::NodeSets
end

function initialize_mesh(file_name::String)::MeshStruct
    message = rpad("Setting up mesh...", 48)
    print(message)

    exo_id = open_exodus_database(file_name)

    init = Initialization(exo_id)

    coords = read_coordinates(exo_id, init.num_dim, init.num_nodes)

    block_ids = read_block_ids(exo_id, init.num_elem_blk)
    blocks = read_blocks(exo_id, block_ids)

    node_set_ids = read_node_set_ids(exo_id, init.num_node_sets)
    node_sets = read_node_sets(exo_id, node_set_ids)

    close_exodus_database(exo_id)

    return MeshStruct(init.num_nodes, init.num_nodes, size(blocks, 1), size(node_sets, 1),
                      coords, blocks, node_sets)
end

end
