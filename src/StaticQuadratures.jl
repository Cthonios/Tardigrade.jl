module StaticQuadratures

export StaticQuadrature

using Base
using StaticArrays
import ..Elements: quad4_quadrature_points_and_weights_static

"""
    StaticQuadrature{Q, D, F}
StaticArrays implementation of Quadrature
"""
struct StaticQuadrature{Q, D, F}
    ξ::SMatrix{Q, D, F}
    w::SVector{Q, F}
end

"""
    StaticQuadrature(element_type::String, q_order::Int64)

# Arguments
- `element_type::String`: type of element
- `q_order::Int64`: quadrature order
"""
function StaticQuadrature(element_type::String, q_order::Int64)
    method_symbol = Symbol(lowercase(element_type) * "_quadrature_points_and_weights_static")
    ξ, w = getfield(StaticQuadratures, method_symbol)(q_order)
    return StaticQuadrature{size(ξ, 1), size(ξ, 2), Float64}(ξ, w)
end

"""
    Base.getindex(q::StaticQuadrature, index::Int64)
"""
Base.getindex(q::StaticQuadrature, index::Int64) = (q.ξ[index, :], q.w[index])
"""
    Base.iterate(q::StaticQuadrature, q_point=1)
"""
Base.iterate(q::StaticQuadrature, q_point=1) = q_point > size(q.w, 1) ? nothing : ((q.ξ[q_point, :], q.w[q_point]), q_point + 1)
"""
    Base.length(q::StaticQuadrature)
"""
Base.length(q::StaticQuadrature) = size(q.w, 1)

end # module