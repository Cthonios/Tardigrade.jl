function quad_quadrature_points_init(quadrature_order)
    if quadrature_order == 1
        w = [4.0]
        ξ = zeros(Float64, 1, 2)
    elseif quadrature_order == 2
        w = [1.0, 1.0, 1.0, 1.0]
        ξ = zeros(Float64, 4, 2)
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
    return w, ξ
end