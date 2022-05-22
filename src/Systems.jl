module Systems

abstract type AbstractSystem end
abstract type UncoupledSystem end
abstract type CoupledSystem end

struct ScalarSystem <: UncoupledSystem
    # assembly::A
    n_dof::Int64
    cell_sections::CellSections
    
end


end # module