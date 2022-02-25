module FunctionSpaces
# TODO: move different element types to different files for clarity
using ..QuadratureTemplates
# using Tardigrade.QuadratureTemplates

export reference_element_factory

struct ReferenceElement
    Nξ::Array{Float64,2}
    ∇Nξ::Array{Float64,3}
end

# function map_reference_element_gradient(coords::Array{Float64,1},
#                                         ∇Nξ::Array{Float64,3})
#     ∇Nₓ = zeros(Float64, size(∇Nξ))
#     for q = 1:size(∇Nξ, 3)
#         ∇Nₓ[:, :, q] = ∇Nξ'[:, :, q] * coords
#     end
# end

function quad_reference_element_init!(shape_function_order::Int,
                                      quadrature::QuadraturePoints,
                                      Nξ::Array{Float64,2},
                                      ∇Nξ::Array{Float64,3})
    one = 1.0
    fourth = 1.0 / 4.0
    if shape_function_order == 1
        for q = 1:quadrature.Nq
            ξ = quadrature.ξ[q, 1]
            η = quadrature.ξ[q, 2]

            # shape function values
            #
            Nξ[1, q] = fourth * (one - ξ) * (one - η)
            Nξ[2, q] = fourth * (one + ξ) * (one - η)
            Nξ[3, q] = fourth * (one + ξ) * (one + η)
            Nξ[4, q] = fourth * (one - ξ) * (one + η)

            # shape function gradients on reference element
            #
            ∇Nξ[1, 1, q] = -fourth * (one - η)
            ∇Nξ[1, 2, q] = -fourth * (one - ξ)
            #
            ∇Nξ[2, 1, q] = fourth * (one - η)
            ∇Nξ[2, 2, q] = -fourth * (one + ξ)
            #
            ∇Nξ[3, 1, q] = fourth * (one + η)
            ∇Nξ[3, 2, q] = fourth * (one + ξ)
            #
            ∇Nξ[4, 1, q] = -fourth * (one + η)
            ∇Nξ[4, 2, q] = fourth * (one - ξ)
        end
    end
end

function reference_element_factory(element_type::String, quadrature_order::Int)

    if element_type == "QUAD4"
        q = quadrature_factory(element_type, quadrature_order)
        Nξ = zeros(Float64, 4, q.Nq)
        ∇Nξ = zeros(Float64, 4, 2, q.Nq)
        quad_reference_element_init!(1, q, Nξ, ∇Nξ)
        reference_element = ReferenceElement(Nξ, ∇Nξ)
        return reference_element
    else
        throw(AssertionError("Unsupported element type"))
    end
end

end
