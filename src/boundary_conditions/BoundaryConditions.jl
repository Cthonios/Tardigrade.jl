module BoundaryConditions

export AbstractBC
export AbstractDirichletBC
export ConstantDirichletBC
export DirichletBCs

export update_residual!
export update_jacobian!

using Base
using Exodus
using ..Meshes

abstract type AbstractBC end
abstract type AbstractDirichletBC <: AbstractBC end

function update_residual!(R::Vector{F}, bc::AbstractDirichletBC) where {F <: Real}
    error("you need to define update_residual! for this type")
end

# this is for a dense matrix, stupid but easy to start with
function update_jacobian!(K::Matrix{F}, bc::AbstractDirichletBC) where {F <: Real}
    error("you need to define update_jacobian! for this type")
end

# add sparse matrix

struct DirichletBCs 
    bcs::Vector{AbstractDirichletBC}
end
Base.getindex(bcs::DirichletBCs, bc::I) where {I <: Integer} = bcs.bcs[bc]
Base.iterate(bcs::DirichletBCs, bc=1) = bc > 1 ? nothing : (bcs.bcs[bc], bc + 1)
Base.length(bcs::DirichletBCs) = length(bcs.bcs)


function DirichletBCs(bcs_settings::Vector{Dict{Any, Any}}, mesh::AbstractMesh)
    bcs = Vector{AbstractDirichletBC}(undef, length(bcs_settings))
    node_set_ids = map(nset -> nset.node_set_id, mesh.node_sets)
    for (n, bc) in enumerate(bcs_settings)
        type_name = Symbol(bc["type"])
        node_set_id = getindex(node_set_ids, bc["node set id"])
        bcs[n] = getfield(BoundaryConditions, type_name)(bc, mesh.node_sets[node_set_id])
    end
    return DirichletBCs(bcs)
end

include("ConstantDirichletBC.jl")

end # module