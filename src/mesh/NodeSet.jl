export NodeSet

struct NodeSet
    node_set_number::Int64
    nodes::Array{Int64,1}
end

function initialize_node_set(exo, node_set_number)
    node_set_nodes = exo.get_node_set_nodes(node_set_number)
    return NodeSet(node_set_number, node_set_nodes)
end

function initialize_node_sets!(exo, node_sets::Array{NodeSet,1})
    for (n, node_set_number) in enumerate(exo.get_node_set_ids())
        node_sets[n] = initialize_node_set(exo, node_set_number)
    end
    return node_sets
end
