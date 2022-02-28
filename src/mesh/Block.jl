export Block  # not really sure why I need this

struct Block
    block_number::Int64
    Nₑ::Int64
    Nₙ_per_e::Int64
    element_type::String
    connectivity::Array{Int64,2}
end

function initialize_block(exo, block_number)
    connectivity, Nₑ, Nₙ_per_e = exo.get_elem_connectivity(block_number)
    element_type = exo.elem_type(block_number)
    connectivity = reshape(connectivity, Nₙ_per_e, Nₑ)'
    return Block(block_number, Nₑ, Nₙ_per_e, element_type, connectivity)
end

function initialize_blocks!(exo, blocks)
    for (n, block_number) in enumerate(exo.get_elem_blk_ids())
        blocks[n] = initialize_block(exo, block_number)
    end
    return blocks
end
