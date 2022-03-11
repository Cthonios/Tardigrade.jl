module Mesh

using PyCall
using Suppressor

include("./Block.jl")
include("./NodeSet.jl")

# TODO: implement SideSet struct
#
export initialize_mesh
export MeshStruct

struct MeshStruct
    Nₙ::Int64              # number of nodes
    Nₑ::Int64              # number of elements
    N_blocks::Int64
    N_node_sets::Int64
    coords::Array{Float64} # coordinates
    blocks::Array{Block,1}
    nodesets::Array{NodeSet,1}
    # TODO: add side sets
end

function initialize_mesh(file_name::String)::MeshStruct
    @suppress begin
        exo = read_exodus_database(file_name)
        #
        # get nodal coordinates
        #
        coords = read_coordinates(exo)
        #
        # setup blocks, TODO: add optional blocks in parser
        #
        blocks = Array{Block,1}(undef, exo.num_blks())
        initialize_blocks!(exo, blocks)
        #
        # setup node sets, TODO: add optional nodesets in parser
        #
        node_sets = Array{NodeSet,1}(undef, exo.num_node_sets())
        initialize_node_sets!(exo, node_sets)
        #
        # set up mesh data structure
        #
        mesh = MeshStruct(exo.num_nodes(), exo.num_elems(),
                          exo.num_blks(), exo.num_node_sets(),
                          coords, blocks, node_sets)
        close_exodus_database(exo)
        return mesh
    end
end

function read_exodus_database(file_name::String)
    exodus3 = pyimport("exodus3")
    return exodus3.exodus(file_name)
end

function close_exodus_database(exo)
    exo.close()
end

function read_coordinates(exo)
    N_d = exo.num_dimensions()
    x_coords, y_coords, z_coords = exo.get_coords()
    coords = zeros(Float64, size(x_coords, 1), N_d)
    if N_d == 2
        coords[:, 1] = x_coords
        coords[:, 2] = y_coords
    elseif N_d == 3
        coords[:, 1] = x_coords
        coords[:, 2] = y_coords
        coords[:, 3] = z_coords
    end
    return coords
end

end
