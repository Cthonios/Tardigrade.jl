"""
`Quadratures`

A module for organizing quadrature integration rules
"""
module Quadratures

export Quadrature

using Base

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
        method_symbol = Symbol(lowercase(element_type) * "_quadrature_points_and_weights")
        n_q_points, xi, w = getfield(Quadratures, method_symbol)(q_order)
        return new(n_q_points, xi, w)
    end
end

Base.getindex(q::Quadrature, index::Int64) = (q.xi[index, :], q.w[index])
Base.iterate(q::Quadrature, q_point=1) = q_point > q.n_q_points ? nothing : ((q.xi[q_point, :], q.w[q_point]), q_point + 1)
Base.length(q::Quadrature) = q.n_q_points

function quadrautre_order_error(q_order)
    @show q_order
    error("q_order = " * q_order * " not supported yet")
end

"""
`quad4_quadrature_points_and_weights(q_order::Int64)`
"""
function quad4_quadrature_points_and_weights(q_order::Int64)
    if q_order == 1
        n_q_points = 1
        xi = zeros(Float64, 1, 2)
        xi[1, 1] = 0.0
        xi[1, 2] = 0.0
        w = [4.0]
    elseif q_order == 2
        n_q_points = 4
        xi = (1.0 / sqrt(3.0)) * [-1.0, -1.0; 1.0, -1.0; 1.0, 1.0; -1.0, 1.0]
        w = [1.0, 1.0, 1.0, 1.0]
    else
        quadrautre_order_error(q_order)
    end
    return n_q_points, xi, w
end

# """
# `hex8_quadrature_points_and_weights(q_order::Int64)`
# """
# function hex8_quadrature_points_and_weights(q_order::Int64)
#     if q_order == 1
#         n_q_points = 1
#         xi[1, 1] = 0.0
#         xi[1, 2] = 0.0
#         xi[1, 3] = 0.0
#         w = [8.0]
#     elseif q_order == 2
#         n_q_points = 8
#         xi[]
#     else
#         quadrautre_order_error(q_order)
#     end
#     return n_q_points, xi, w
# end


end # module