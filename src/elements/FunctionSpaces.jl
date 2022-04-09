module FunctionSpaces

export initialize_function_space

using LinearAlgebra

import Exodus: Block

include("./function_spaces/QUAD4.jl")

struct FunctionSpace
    Ns::Matrix{Float64}
    ∇N_ξs::Array{Float64,3}
    ∇N_Xs::Array{Float64,4}
    JxWs::Matrix{Float64}
    # TODO: adjust to make certain fields optional such as Ns or ∇N_Xs
    function FunctionSpace(coords, elem_type, q_template)
        N_q, w, ξ = q_template.Nq, q_template.w, q_template.ξ
        N_e, N_n, N_d = size(coords)
        N, ∇N_ξ = create_function_space_functions(elem_type)
        Ns = Array{Float64}(undef, N_q, N_n)
        ∇N_ξs = Array{Float64}(undef, N_q, N_n, N_d)
        ∇N_Xs = Array{Float64,4}(undef, N_e, N_q, N_n, N_d)
        JxWs = Array{Float64,2}(undef, N_e, N_q)
        initialize_function_space!(coords, w, ξ, N, ∇N_ξ, Ns, ∇N_ξs, ∇N_Xs, JxWs)
        return new(Ns, ∇N_ξs, ∇N_Xs, JxWs)
    end
end

J(X::Matrix{Float64}, ∇N_ξ::Matrix{Float64}) = transpose(∇N_ξ) * X
detJ(X::Matrix{Float64}, ∇N_ξ::Matrix{Float64}) = det(J(X, ∇N_ξ))
∇N_X(X::Matrix{Float64}, ∇N_ξ::Matrix{Float64}) = transpose(inv(J(X, ∇N_ξ)) * transpose(∇N_ξ))

function create_function_space_functions(element_type::String)
    if element_type == "QUAD4"
        N(x::Vector{Float64}) = quad4_calculate_shape_function_values(x)
        ∇N_ξ(x::Vector{Float64}) = quad4_calculate_shape_function_gradients(x)
        return N, ∇N_ξ
    else
        throw(AssertionError("Unsupported element type"))
    end
end

# TODO:
# add typing
# maybe also figure out how to use maps and broadcasts to vectorize this
function initialize_function_space!(coords, w, ξ, N, ∇N_ξ, Ns, ∇N_ξs, ∇N_Xs, JxWs)
    N_q = size(w, 1)
    N_e = size(coords, 1)
    @simd for q = 1:N_q
        @inbounds Ns[q, :] = N(ξ[q, :])
        @inbounds ∇N_ξs[q, :, :] = ∇N_ξ(ξ[q, :])
        @inbounds temp_∇N_ξ = ∇N_ξ(ξ[q, :])
        @simd for e = 1:N_e
            @inbounds X = coords[e, :, :]
            @inbounds JxWs[e, q] = w[q] * detJ(X, temp_∇N_ξ)
            @inbounds ∇N_Xs[e, q, :, :] = ∇N_X(X, temp_∇N_ξ)
        end
    end
end

end # module
