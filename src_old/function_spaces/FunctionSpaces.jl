module FunctionSpaces

export initialize_function_space

using LinearAlgebra

import Exodus: Block
import ..CoordinatesModule: Coordinates

include("./QUAD4.jl")

struct FunctionSpace
    # N_e::Int64
    # N_q::Int64
    Ns::Matrix{Float64}
    ∇N_ξs::Array{Float64,3}
    ∇N_Xs::Array{Float64,4}
    JxWs::Matrix{Float64}
    function FunctionSpace(coords, elem_type, q_template)
        N_q = length(q_template)
        N_e, N_n, N_d = size(coords)
        N, ∇N_ξ = create_function_space_functions(elem_type)
        Ns = Array{Float64}(undef, N_q, N_n)
        ∇N_ξs = Array{Float64}(undef, N_q, N_n, N_d)
        ∇N_Xs = Array{Float64,4}(undef, N_e, N_q, N_n, N_d)
        JxWs = Array{Float64,2}(undef, N_e, N_q)
        initialize_function_space!(coords, q_template, N, ∇N_ξ, Ns, ∇N_ξs, ∇N_Xs, JxWs)
        return new(Ns, ∇N_ξs, ∇N_Xs, JxWs)
    end
end

# interface
Base.length(f::FunctionSpace) = size(f.Ns, 1)
Base.getindex(f::FunctionSpace, e) = (f.Ns[:, :], f.∇N_Xs[e, :, :, :], f.JxWs[e, :])
Base.iterate(f::FunctionSpace, e=1) = e > length(f) ? nothing : (getindex(f, e), e + 1) 

# implementation
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

function initialize_function_space!(coords, q_template, N, ∇N_ξ, Ns, ∇N_ξs, ∇N_Xs, JxWs)
    for (q, (w, ξ)) in enumerate(q_template)
        @inbounds Ns[q, :] = N(ξ)
        @inbounds ∇N_ξs[q, :, :] = ∇N_ξ(ξ)
        for (e, X) in enumerate(coords)
            @inbounds JxWs[e, q] = w * detJ(X, ∇N_ξs[q, :, :])
            @inbounds ∇N_Xs[e, q, :, :] = ∇N_X(X, ∇N_ξs[q, :, :])
        end 
    end
end

end # module
