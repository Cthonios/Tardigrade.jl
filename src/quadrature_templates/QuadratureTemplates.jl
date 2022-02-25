module QuadratureTemplates

export QuadraturePoints
export quadrature_factory

include("./QuadQuadrature.jl")

struct QuadraturePoints
    Nq::Int
    w::Vector{Float64}
    ξ::Matrix{Float64}
end

function quadrature_factory(element_type::String, quadrature_order)
    if element_type == "QUAD4"
        w, ξ = quad_quadrature_points_init(quadrature_order)
        return QuadraturePoints(quadrature_order^2, w, ξ)
    else
        throw(AssertionError("Unsupported element in quadrature"))
    end
end

end
