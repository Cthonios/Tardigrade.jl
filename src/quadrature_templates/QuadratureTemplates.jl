module QuadratureTemplates

export QuadraturePoints
export quadrature_factory

include("./QuadQuadrature.jl")

struct QuadraturePoints
    Nq::Int
    w::Array{Float64,1}
    ξ::Array{Float64,2} # general type that is really Array{Float64,N_dimensions}
end

function quadrature_factory(element_type::String, quadrature_order::Int)
    if element_type == "QUAD4"
        w = zeros(Float64, quadrature_order^2)
        ξ = zeros(Float64, quadrature_order^2, 2)
        quad_quadrature_points_init!(quadrature_order, w, ξ)
        return QuadraturePoints(quadrature_order^2, w, ξ)
    else
        throw(AssertionError("Unsupported element in quadrature"))
    end
end

end
