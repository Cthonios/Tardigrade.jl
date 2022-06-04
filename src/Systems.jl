module Systems

abstract type AbstractSystem end
abstract type UncoupledSystem end
abstract type CoupledSystem end

mutable struct ScalarSystem <: UncoupledSystem
    # assembly::A
    n_dof::Int64
    cell_sections::CellSections
    #
    solution::Vector{Float64}
end


end # module