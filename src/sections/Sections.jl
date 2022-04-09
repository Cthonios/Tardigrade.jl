module Sections

export Section
export initialize_sections

include("../elements/QuadratureTemplates.jl")
include("../elements/FunctionSpaces.jl")

import Exodus: Block
import ..Mesh: MeshStruct
import .QuadratureTemplates: QuadraturePoints
import .FunctionSpaces: FunctionSpace

abstract type AbstractSection end

# eventually we may want to define derived sections
# also need to add in constitutive equations and type them based on physcs
# this will likely be the main workhorse moduel for making all the conenctions
# between material state to nodal what not
struct Section <: AbstractSection
    N_e::Int64
    N_n::Int64
    N_q::Int64
    conn::Matrix{Float64}
    function_space::FunctionSpace
end

function initialize_connectivity!(conn::Vector{Int64}, new_conn::Matrix{Int64})
    N_e, N_n = size(new_conn)
    @simd for e = 1:N_e
        @inbounds local_conn = conn[(e - 1)*N_n + 1:e*N_n]
        @simd for n = 1:N_n
            @inbounds new_conn[e, n] = local_conn[n]
        end
    end
end

function initialize_connectivity(block::Block)
    N_e, N_n = block.num_elem, block.num_nodes_per_elem
    new_conn = Matrix{Int64}(undef, N_e, N_n)
    initialize_connectivity!(block.conn, new_conn)
    return new_conn
end

function initialize_coordinates(coords::Matrix{Float64}, conn::Matrix{Int64})
    new_coords = coords[conn, :]
    return new_coords
end

function initialize_sections(sections_settings::Vector{Dict{Any,Any}}, mesh::MeshStruct)
    sections = Vector{Section}(undef, size(sections_settings, 1))
    for (n, section_settings) in enumerate(sections_settings)
        block_id = section_settings["block"]
        q_order = section_settings["quadrature order"]

        block = mesh.blocks[findall(x -> x.block_id == block_id, mesh.blocks)][1]  # this only does 1 block per section

        # q_template = quadrature_factory(block.elem_type, q_order)
        q_template = QuadraturePoints(block.elem_type, q_order)
        conn = initialize_connectivity(block)
        coords = initialize_coordinates(mesh.coords, conn)

        # initialize_function_space(coords, block.elem_type, q_template)
        f_space = FunctionSpace(coords, block.elem_type, q_template)
    end
end

end # module