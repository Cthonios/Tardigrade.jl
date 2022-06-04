"""
`Assembly`

Module for all things assembly
"""

module Assembly

export DenseStaticAssembly
export zero!
export assemble!

import ..Meshes: Mesh
import ..Sections: CellSection
import ..Sections: CellSections

abstract type AbstractAssembly end
abstract type StaticAssembly end  # meant for static problems
abstract type DynamicAssembly end # meant for dynamic problems

mutable struct DenseStaticAssembly <: StaticAssembly
    K::Matrix{Float64}
    F::Vector{Float64}
    sections::CellSections
    #
    u::Vector{Float64}
    function DenseStaticAssembly(mesh::Mesh, sections::CellSections)
        K = zeros(Float64, length(mesh.coordinates), length(mesh.coordinates))
        F = zeros(Float64, length(mesh.coordinates))
        return new(K, F, sections)
    end
end

function assemble!(d::DenseStaticAssembly, s::CellSection)
    for e in s
        # @show e
    end
end

# function assemble(d::DenseStaticAssembly, c::CellSections)

# end

# zero(d::DenseStaticAssembly)
function zero!(d::DenseStaticAssembly)
    d.K .= zero(Float64)
    d.F .= zero(Float64)
end

end # module