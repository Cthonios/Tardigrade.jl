module Sections

export Connectivity
export Coordinates
export Section
export initialize_sections
export element_level_nodal_values
export element_level_quadrature_values
export element_level_quadrature_gradients
export element_level_quadrature_values_and_gradients

import ..Mesh: MeshStruct # needs to be imported first
import Exodus: Block

include("../connectivity/Connectivity.jl")
include("../coordinates/Coordinates.jl")
include("../quadrature_templates/QuadratureTemplates.jl")
include("../function_spaces/FunctionSpaces.jl")

using LinearAlgebra

import ..Mesh: MeshStruct
import .CoordinatesModule: Coordinates
import .ConnectivityModule: Connectivity
import .QuadratureTemplates: QuadratureTemplate
import .FunctionSpaces: FunctionSpace

abstract type AbstractSection end

# we probably want to build arrays of containers and parse through those
# struct CellData
#     coords::Matrix{Float64}
#     conn::Vector{Float64}
#     JxWs::Matrix{Float64}
#     Ns::Matrix{Float64}
#     ∇N_Xs::Array{Float64,3}
# end

# CellSection = Vector{CellData}

# function Base.getindex(c::CellSection, e)
#     return c[e].coords, c[e].conn, c[e].JxWs, c[e].Ns, c[e].∇N_Xs
# end

# Base.iterate(c::CellSection, state) = state > length(c) ? nothing : (getindex(c, state), state + 1)

# section to organize all block quantities
struct Section <: AbstractSection
    N_d::Int64        # for easy indexing
    N_e::Int64        # for easy indexing
    N_n_per_e::Int64  # for easy indexing
    N_q::Int64        # for easy indexing
    coords::Coordinates
    conn::Connectivity
    function_space::FunctionSpace
    function Section(coords, conn, function_space)
        N_d = size(function_space.∇N_ξs, 3)
        N_e = size(coords, 1)
        N_n_per_e = size(function_space.Ns, 2)
        N_q = size(function_space.Ns, 1)
        return new(N_d, N_e, N_n_per_e, N_q, coords, conn, function_space)
    end
end

#interface
Base.length(s::Section) = size(s.coords)[1]

function Base.getindex(s::Section, e)
    coords = getindex(s.coords, e)
    conn = getindex(s.conn, e)
    Ns, ∇N_Xs, JxWs = getindex(s.function_space, e)
    return coords, conn, Ns, ∇N_Xs, JxWs
end

Base.iterate(s::Section, state=1) = state > length(s) ? nothing : (getindex(s, state), state + 1)
element_level_nodal_values(u::Vector{Float64}, s::Section) = u[s.conn.conn]
element_level_nodal_values(u::Matrix{Float64}, s::Section) = u[s.conn.conn, :]

function element_level_quadrature_values!(u_e_qs::Array{Float64,2}, u_es::Array{Float64,2}, s::Section)
    for e = 1:s.N_e, q = 1:s.N_q
        u_e_qs[e, q] = dot(s.function_space.Ns[q, :], u_es[e, :])
    end
end

function element_level_quadrature_values(u::Vector{Float64}, s::Section)
    u_es = element_level_nodal_values(u, s)
    u_e_qs = zeros(Float64, s.N_e, s.N_q)
    element_level_quadrature_values!(u_e_qs, u_es, s)
    return u_e_qs
end

function element_elevel_quadrature_gradients!(∇u_e_qs::Array{Float64,3}, u_es::Array{Float64,2}, s::Section)
    for e = 1:s.N_e, q = 1:s.N_q
        ∇u_e_qs[e, q, :] = transpose(s.function_space.∇N_Xs[e, q, :, :]) * u_es[e, :]
    end
end

function element_level_quadrature_gradients(u::Vector{Float64}, s::Section)
    u_es = element_level_nodal_values(u, s)
    ∇u_e_qs = zeros(Float64, s.N_e, s.N_q, s.N_d)
    element_elevel_quadrature_gradients!(∇u_e_qs, u_es, s)
    return ∇u_e_qs
end

function element_level_quadrature_values_and_gradients!(u_e_qs::Array{Float64,2}, ∇u_e_qs::Array{Float64,3},
                                                        u_es::Array{Float64,2}, s::Section)
    for e = 1:s.N_e, q = 1:s.N_q
        u_e_qs[e, q] = dot(s.function_space.Ns[q, :], u_es[e, :])
        ∇u_e_qs[e, q, :, :] = transpose(s.function_space.∇N_Xs[e, q, :, :]) * u_es[e, :]
    end
end

function element_level_quadrature_values_and_gradients(u::Vector{Float64}, s::Section)
    u_es = element_level_nodal_values(u, s)
    u_e_qs = zeros(Float64, s.N_e, s.N_q)
    ∇u_e_qs = zeros(Float64, s.N_e, s.N_q, s.N_d)
    element_level_quadrature_values_and_gradients!(u_e_qs, ∇u_e_qs, u_es, s)
    return u_e_qs, ∇u_e_qs
end


#implementation
function initialize_sections!(sections, sections_settings, mesh)
    for (n, section_settings) in enumerate(sections_settings)
        block_id = section_settings["block"]
        q_order = section_settings["quadrature order"]
        block = mesh.blocks[findall(x -> x.block_id == block_id, mesh.blocks)][1]  # this only does 1 block per section
        
        conn = Connectivity(block)
        coords = Coordinates(mesh.coords, conn)
        q_template = QuadratureTemplate(block.elem_type, q_order)
        f_space = FunctionSpace(coords, block.elem_type, q_template)
        @inbounds sections[n] = Section(coords, conn, f_space)
    end
end

function initialize_sections(sections_settings::Vector{Dict{Any,Any}}, mesh::MeshStruct)
    message = rpad("Setting up sections...", 48)
    print(message)
    sections = Vector{Section}(undef, size(sections_settings, 1))
    initialize_sections!(sections, sections_settings, mesh)
    return sections
end

end # module