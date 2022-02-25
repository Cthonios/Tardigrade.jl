function quad_quadrature_points_init!(quadrature_order::Int8,
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
