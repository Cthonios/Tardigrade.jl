"""
    Fields
A module for handling FEM field solutions.
"""
module Fields

export AbstractField
export AbstractScalarField
export UncoupledScalarField
export element_level_values
export update_field!

using Base
using ..Meshes

"""
    AbstractField
Parent type for all FEM fields.
"""
abstract type AbstractField end
"""
    AbstractScalarField
Parent type for all FEM scalar fields.
"""
abstract type AbstractScalarField <: AbstractField end

"""
    UncoupledScalarField
Container for an uncoupled scalar field.
"""
mutable struct UncoupledScalarField <: AbstractScalarField
    u::Vector{Float64}
    
end 

"""
    UncoupledScalarField(n_nodes::I) where {I <: Integer}
Init method for an uncoupled scalar field.
"""
function UncoupledScalarField(n_nodes::I) where {I <: Integer}
    return UncoupledScalarField(zeros(Float64, n_nodes))
end

"""
    element_level_values(mesh::SingleBlockExodusMesh, u::UncoupledScalarField)
Method to gather element level values using views
"""
element_level_values(mesh::SingleBlockExodusMesh, u::UncoupledScalarField) = @view u.u[mesh.connectivity]
element_level_values(mesh::SingleBlockExodusMesh, u::UncoupledScalarField, e::T) where {T <: Integer} = 
@view u.u[element_level_connectivity(mesh, e)]
Base.length(u::UncoupledScalarField) = length(u.u)
function update_field!(u::UncoupledScalarField, u_new::Vector{T}) where {T <: Real}
    u.u = u_new
end 

end # module