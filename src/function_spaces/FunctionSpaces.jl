module FunctionSpaces
include("./QuadFunctionSpace.jl")
using ..QuadratureTemplates

export reference_element_factory

struct ReferenceElement
    Nξ::Array{Float64,2}
    ∇Nξ::Array{Float64,3}
end

function reference_element_factory(element_type::String, quadrature_order::Int8)

    if element_type == "QUAD4"
        q = quadrature_factory(element_type, quadrature_order)
        Nξ = zeros(Float64, 4, q.Nq)
        ∇Nξ = zeros(Float64, 4, 2, q.Nq)
        quad_reference_element_init!(convert(Int8, 1), q, Nξ, ∇Nξ)  # TODO make parameteric on shape function order
        reference_element = ReferenceElement(Nξ, ∇Nξ)
        return reference_element
    else
        throw(AssertionError("Unsupported element type"))
    end
end

end

function map_reference_element_gradient(coords::Array{Float64,1},
                                        ∇Nξ::Array{Float64,3})
    ∇Nₓ = zeros(Float64, size(∇Nξ))
    for q = 1:size(∇Nξ, 3)
        ∇Nₓ[:, :, q] = ∇Nξ'[:, :, q] * coords
    end
end
