module PostProcessor

using PyCall
using Suppressor
# using Tardigrade.Mesh

function copy_mesh_to_exodus_database(mesh_file_name::String)
    exodus3 = pyimport("exodus3")
    exo = exodus3.exodus(mesh_file_name)
    return exo.copy("output.e")
end

function setup_exodus_variable_fields(exo)
    exo.set_node_variable_number(1)
    exo.put_node_variable_name("u", 1)
end

function setup_initial_time_step(exo)
    exo.put_time(1, 0.0)
    # exo.put_node_variable_values("u", 1, )
end

function write_exodus_time_step(exo, u)
    exo.put_time(2, 1.0)
    exo.put_node_variable_values("u", 2, u)
end

function close_exodus_database(exo)
    exo.close()
end

end
