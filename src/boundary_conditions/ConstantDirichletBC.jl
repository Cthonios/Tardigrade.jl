struct ConstantDirichletBC{I, F} <: AbstractDirichletBC
    nodes::Vector{I}
    value::F
end

function ConstantDirichletBC(bc_settings::Dict{Any, Any}, node_set)
    return ConstantDirichletBC(node_set.nodes, bc_settings["value"])
end

function update_residual!(R::Vector{F}, bc::ConstantDirichletBC) where {F <: Real}
    R[bc.nodes] .= 0.0
end

function update_jacobian!(J::Matrix{F}, bc::ConstantDirichletBC) where {F <: Real}
    for node in bc.nodes
        J[node, node] = 1.0 # maybe add some kind of scaling
    end
end