"""
`Quadratures`

A module for organizing quadrature integration rules
"""
module Quadratures

export Quadrature
export QuadratureStatic

using Base
using StaticArrays

# need to set up a map between element type and quadrature array shape
element_dims = Dict(
    "quad4" => 2, # add more orders when supported
    "hex8"  => 3 # not functional right now just an example
)
"""
`Quadrature`

Interface\n
`Base.getindex(q::Quadrature, index::Int64)`\n
`Base.iterate(q::Quadrature, q_point=1)`\n
`Base.length(q::Quadrature)`\n
"""
struct Quadrature
    n_q_points::Int64
    xi::Matrix{Float64}
    w::Vector{Float64}
    function Quadrature(element_type::String, q_order::Int64)
        method_symbol = Symbol(lowercase(element_type) * "_quadrature_points_and_weights_old")
        n_q_points, xi, w = getfield(Quadratures, method_symbol)(q_order)
        return new(n_q_points, xi, w)
    end
end

Base.getindex(q::Quadrature, index::Int64) = (q.xi[index, :], q.w[index])
Base.iterate(q::Quadrature, q_point=1) = q_point > q.n_q_points ? nothing : ((q.xi[q_point, :], q.w[q_point]), q_point + 1)
Base.length(q::Quadrature) = q.n_q_points

struct QuadratureStatic{Q,D}
    n_q_points::Int64
    xi::SMatrix{Q,D,Float64}
    w::SVector{Q,Float64}
    function QuadratureStatic(element_type::String, q_order::Int64)
        method_symbol = Symbol(lowercase(element_type) * "_quadrature_points_and_weights")
        n_q_points, xi, w = getfield(Quadratures, method_symbol)(q_order)
        return new{n_q_points,element_dims[lowercase(element_type)]}(n_q_points, xi, w)
    end
end

Base.getindex(q::QuadratureStatic, index::Int64) = (q.xi[index, :], q.w[index])
Base.iterate(q::QuadratureStatic, q_point=1) = q_point > q.n_q_points ? nothing : ((q.xi[q_point, :], q.w[q_point]), q_point + 1)
Base.length(q::QuadratureStatic) = q.n_q_points

function quadrautre_order_error(q_order)
    @show q_order
    error("q_order = " * q_order * " not supported yet")
end

"""
`quad4_quadrature_points_and_weights(q_order::Int64)`
"""
function quad4_quadrature_points_and_weights_old(q_order::Int64)
    if q_order == 1
        n_q_points = 1
        xi = reshape([0.0 0.0], (1, 2)) # maybe not the most elegant
        w = [4.0]
    elseif q_order == 2
        n_q_points = 4
        xi = (1.0 / sqrt(3.0)) * [-1.0 -1.0
                                  1.0 -1.0
                                  1.0 1.0
                                  -1.0 1.0]
        w = [1.0, 1.0, 1.0, 1.0]
    else
        quadrautre_order_error(q_order)
    end
    return n_q_points, xi, w
end

function quad4_quadrature_points_and_weights(q_order::Int64)
    if q_order == 1
        n_q_points = 1
        xi = SMatrix{1,2}(0.0, 0.0)
        w = SVector{1}(4.0)
    elseif q_order == 2
        n_q_points = 4
        xi = SMatrix{4,2}((1.0 / sqrt(3.0)) * [-1.0 -1.0;
                                               1.0 -1.0;
                                               1.0 1.0;
                                               -1.0 1.0])
        w = SVector{4}(1.0, 1.0, 1.0, 1.0)
    else
        quadrautre_order_error(q_order)
    end
    return n_q_points, xi, w
end

end # module