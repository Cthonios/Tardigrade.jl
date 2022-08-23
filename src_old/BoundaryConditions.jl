"""
`BoundaryConditions`
"""
module BoundaryConditions

export ZeroDirichletBoundaryCondition

using Exodus

bcs_map = Dict("zero"     => "ZeroDirichletBC",
               "one"      => "OneDirichletBC",
               "constant" => "ConstantDirichletBC") # etc

abstract type AbstractBC end
abstract type DirichletBC end

struct ZeroDirichletBC <: DirichletBC
    nodes::Vector{Int64}
    function ZeroDirichletBoundaryCondition(node_set::Exodus.NodeSet)
        return new(node_set.nodes)
    end
end

function update_residual!(bc::ZeroDirichletBC)

end

function update_tangent!(bc::DirichletBC)

end



# function update_rhs()

# mutable struct BoundaryConditions

# end 

end # module