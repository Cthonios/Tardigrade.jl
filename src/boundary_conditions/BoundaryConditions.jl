module BoundaryConditions

using Parameters

export boundary_condition_factory

# TODO move different BC types to different jl files
#
abstract type AbstractBC end
abstract type AbstractDirichletBC <: AbstractBC end

struct ConstantScalarDirichletBC <: AbstractDirichletBC
    variable::String
    nodes::Array{Int64,1}
    value::Float64
end

function initialize_boundary_condition(input_settings, mesh, bc_type)

    # get the first one first
    #
    nodes = []
    for nodeset in mesh.nodesets
        if nodeset.node_set_number == input_settings["node sets"][1]
            nodes = nodeset.nodes
        end
    end

    # now for the other node sets
    #
    if size(input_settings["node sets"], 1) > 1
        for m = 2:size(input_settings["node sets"], 1)
            for nodeset in mesh.nodesets
                if nodeset.node_set_number == input_settings["node sets"][m]
                    nodes = vcat(nodes, nodeset.nodes)
                end
            end
        end
    end

    return bc_type(input_settings["variable"],
                   nodes,
                   input_settings["constant value"])  # TODO need to do args approach here
end

function boundary_condition_factory(input_settings, mesh)
    if input_settings["boundary condition type"] == "constant scalar dirichlet"
        return initialize_boundary_condition(input_settings, mesh,
                                             ConstantScalarDirichletBC)
    else
        throw(AssertionError("Unsupported boundary condition"))
    end
end

function update_bc_solution_constant_scalar_dirichlet!(bc::ConstantScalarDirichletBC,
    u::Vector{Float64})
    @inbounds u[bc.nodes] .= bc.value
end

# TODO fix array type to bc types
#
function update_bcs_solution!(bcs, u)
    @simd for bc = 1:size(bcs, 1)
        @inbounds update_bc_solution!(bcs[bc], u)
    end
end

function update_bc_residual_constant_scalar_dirichlet!(bc::ConstantScalarDirichletBC,
    R::Vector{Float64})
    @inbounds R[bc.nodes] .= 0.0
end

# TODO fix array type to bc types
#
function update_bcs_residual!(bcs, R)
    @simd for bc = 1:size(bcs, 1)
        @inbounds update_bc_residual!(bcs[bc], R)
    end
end

# TODO figure out the best way to type the stiffness matrix
#
function update_bc_tangent!(bc::ConstantScalarDirichletBC, K)
    @simd for node in bc.nodes
        @inbounds K[node, node] = 1.0e6
    end
end

# TODO fix array type to bc types
#
function update_bcs_tangent!(bcs, K)
    @simd for bc = 1:size(bcs, 1)
        update_bc_tangent!(bcs[bc], K)
    end
end

# method signatures
#
update_bc_solution!(bc::ConstantScalarDirichletBC, u::Vector{Float64}) =
update_bc_solution_constant_scalar_dirichlet!(bc, u)
update_bc_residual!(bc::ConstantScalarDirichletBC, R::Vector{Float64}) =
update_bc_residual_constant_scalar_dirichlet!(bc, R)

function update_bcs_residual_and_tangent!(bcs, R, K)
    @simd for bc = 1:size(bcs,1)
        update_bc_residual!(bcs[bc], R)
        update_bc_tangent!(bcs[bc], K)
    end
end
end
