module BoundaryConditions

using Parameters

export boundary_condition_factory

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

    # nodes = convert(Array{Int64,1}, nodes)
    # println(nodes)
    # println(size(nodes))
    # println(convert(Array{Int64,1}, nodes))

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

end
