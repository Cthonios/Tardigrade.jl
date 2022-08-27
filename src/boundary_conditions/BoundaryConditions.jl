module BoundaryConditions

export AbstractBC
export AbstractDirichletBC
export ConstantDirichletBC
export setup_dirichlet_bcs

using ..Meshes

abstract type AbstractBC end
abstract type AbstractDirichletBC <: AbstractBC end

function update_residual!(R::Vector{F}, bc::AbstractDirichletBC) where {F <: Real}

end

# this is for a dense matrix, stupid but easy to start with
function update_jacobian!(K::Matrix{F}, bc::AbstractDirichletBC) where {F <: Real}

end

# add sparse matrix

# eventuall move all the different types to different files
# and keep generic stuff in here
struct ConstantDirichletBC{I, F} <: AbstractDirichletBC
    nodes::Vector{I}
    value::F
end

function ConstantDirichletBC()

end

function setup_dirichlet_bcs(mesh::AbstractMesh, bcs::Vector{Dict{Any, Any}})
    # for node_set in mesh.node_sets

    # end 
end

end # module