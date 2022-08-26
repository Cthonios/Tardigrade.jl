module Fields

export AbstractField
export AbstractScalarField
export UncoupledScalarField
export element_level_values
export update_field!

using Base
using ..Meshes

abstract type AbstractField end
abstract type AbstractScalarField <: AbstractField end

mutable struct UncoupledScalarField <: AbstractScalarField
    u::Vector{Float64}
    function UncoupledScalarField(n_nodes::I) where {I <: Integer}
        return new(zeros(Float64, n_nodes))
    end
end 

element_level_values(mesh::SingleBlockExodusMesh, u::UncoupledScalarField) = @view u.u[mesh.connectivity]
element_level_values(mesh::SingleBlockExodusMesh, u::UncoupledScalarField, e::T) where {T <: Integer} = 
@view u.u[element_level_connectivity(mesh, e)]
Base.length(u::UncoupledScalarField) = length(u.u)
function update_field!(u::UncoupledScalarField, u_new::Vector{T}) where {T <: Real}
    u.u = u_new
end 

end # module