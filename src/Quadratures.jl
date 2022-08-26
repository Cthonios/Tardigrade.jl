"""
    Quadratures
A module for organizing quadrature integration rules.
"""
module Quadratures

export Quadrature

using Base

# need to set up a map between element type and quadrature array shape
element_dims = Dict(
    "quad4" => 2, # add more orders when supported
    "hex8"  => 3 # not functional right now just an example
)
"""
    Quadrature
Container for managing quadrature points and weights.
# Arguments
`ξ::Matrix{Float64}`: Quadrature points
`w::Vector{Float64}`: Quadrature weights
"""
struct Quadrature
    ξ::Matrix{Float64}
    w::Vector{Float64}
end

"""
    Quadrature(element_type::String, q_order::Int64)
Init method for Quadrature
# Arguments
- `element_type::String`: The type of element in string format
- `q_order::Int64`: The order of the quadrature rule for element_type
"""
function Quadrature(element_type::String, q_order::Int64)
    method_symbol = Symbol(lowercase(element_type) * "_quadrature_points_and_weights")
    ξ, w = getfield(Quadratures, method_symbol)(q_order)
    return Quadrature(ξ, w)
end

"""
    Base.getindex(q::Quadrature, index::Int64)
# Arguments
- `q::Quadrature`: Quadrature object
- `index::Int64`: Quadrature point index
"""
Base.getindex(q::Quadrature, index::Int64) = (q.ξ[index, :], q.w[index])
"""
    Base.iterate(q::Quadrature, q_point=1)
# Arguments
- `q::Quadrature`: Quadrature object
- `index::Int64`: Quadrature point index
"""
Base.iterate(q::Quadrature, q_point=1) = q_point > size(q.w, 1) ? nothing : ((q.ξ[q_point, :], q.w[q_point]), q_point + 1)
"""
    Base.length(q::Quadrature)
Returns the number of quadrature points.
- `q::Quadrature`: Quadrature object
"""
Base.length(q::Quadrature) = size(q.w, 1)

"""
    quadrature_order_error(q_order::Int64)
Pre-defined error for improrper quadrature order.
# Arguments
- `q_order::Int64`: quadrature order
"""
function quadrautre_order_error(q_order::Int64)
    @show q_order
    error("q_order = " * q_order * " not supported yet")
end

"""
    quad4_quadrature_points_and_weights(q_order::Int64)
Defines quadrature rule for quad4 elements.
# Arguments
- `q_order::Int64`: quadrature order
"""
function quad4_quadrature_points_and_weights(q_order::Int64)
    if q_order == 1
        ξ = [0.0 0.0;]
        w = [4.0]
    elseif q_order == 2
        ξ = (1.0 / sqrt(3.0)) * [-1.0 -1.0
                                 1.0 -1.0
                                 1.0 1.0
                                 -1.0 1.0]
        w = [1.0, 1.0, 1.0, 1.0]
    else
        quadrautre_order_error(q_order)
    end
    return ξ, w
end

end # module