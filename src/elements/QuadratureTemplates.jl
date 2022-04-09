module QuadratureTemplates

export QuadraturePoints
export quadrature_factory

include("./quadrature_templates/QuadQuadrature.jl")

struct QuadraturePoints
    Nq::Int
    w::Vector{Float64}
    ξ::Matrix{Float64}
    function QuadraturePoints(element_type::String, q_order::Int64)
        if element_type == "QUAD4"
            w, ξ = quad_quadrature_points_init(q_order)
            return new(q_order^2, w, ξ)
        else
            throw(AssertionError("Unsupported element in quadrature"))
        end
    end
end

end # module
