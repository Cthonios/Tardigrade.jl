"""
`BoundaryConditions`
"""
module BoundaryConditions

export ZeroDirichletBoundaryCondition

using Exodus

bcs_map = Dict("zero"     => "ZeroDirichletBoundaryCondition",
               "one"      => "OneDirichletBoundaryCondition",
               "constant" => "ConstantDirichletBoundaryCondition") # etc

abstract type AbstractBoundaryCondition end
abstract type DirichletBoundaryCondition end

struct ZeroDirichletBoundaryCondition <: DirichletBoundaryCondition
    nodes::Vector{Int64}
    function ZeroDirichletBoundaryCondition(node_set::Exodus.NodeSet)
        return new(node_set.nodes)
    end
end

function update_residual!(bc::ZeroDirichletBoundaryCondition, a::AbstractAssembly)

end

# function update_rhs()

# mutable struct BoundaryConditions

# end 

end # module