module QuadratureTemplates

export QuadraturePoints
export quadrature_factory

struct QuadraturePoints
    Nq::Int
    w::Array{Float64,1}
    ξ::Array{Float64,2} # general type that is really Array{Float64,N_dimensions}
end

function quad_quadrature_points_init!(quadrature_order::Int,
                                      w::Array{Float64,1},
                                      ξ::Array{Float64,2})
    if quadrature_order == 1
        w[1] = 4.0
        #
        ξ[1, 1] = 0.0
        ξ[1, 2] = 0.0
    elseif quadrature_order == 2
        w[1] = 1.0
        w[2] = 1.0
        w[3] = 1.0
        w[4] = 1.0
        #
        ξ[1, 1] = -1.0 / √3
        ξ[1, 2] = -1.0 / √3
        #
        ξ[2, 1] = -1.0 / √3
        ξ[2, 2] = 1.0 / √3
        #
        ξ[3, 1] = 1.0 / √3
        ξ[3, 2] = 1.0 / √3
        #
        ξ[4, 1] = 1.0 / √3
        ξ[4, 2] = -1.0 / √3
    else
        throw(AssertionError("unsupported quadrature order"))
    end
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
