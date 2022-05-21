module QuadratureTemplates

export QuadratureTemplate

include("./QUAD.jl")

abstract type AbstractQuadratureTemplate end

struct QuadratureTemplate <: AbstractQuadratureTemplate
    N_q::Int
    w::Vector{Float64}
    ξ::Matrix{Float64}
    function QuadratureTemplate(element_type::String, q_order::Int64)
        if element_type == "QUAD4"
            N_q = q_order^2
            w, ξ = quad_quadrature_points_init(q_order)
        else
            throw(AssertionError("Unsupported element in quadrature"))
        end
        return new(N_q, w, ξ)
    end
end

# interface
Base.getindex(q::QuadratureTemplate, index::Int64) = (q.w[index], q.ξ[index, :])
Base.length(q::QuadratureTemplate) = q.N_q
Base.iterate(q::QuadratureTemplate, state=1) = state > length(q) ? nothing : (getindex(q, state), state + 1)

end # module 
