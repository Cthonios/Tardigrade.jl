module ConnectivityModule

export Connectivity
export initialize_connectivity!
export scatter_nodal_values

import Exodus: Block

abstract type AbstractConnectivity end

# connectivity arrays for gather and scatter operations
#
struct Connectivity <: AbstractConnectivity
    conn::Matrix{Int64}
    function Connectivity(block::Block)
        N_e, N_n = block.num_elem, block.num_nodes_per_elem
        new_conn = Matrix{Int64}(undef, N_e, N_n)
        initialize_connectivity!(block.conn, new_conn)
        return new(new_conn)
    end
end

# interface
Base.getindex(c::Connectivity, e) = c.conn[e, :]
scatter_nodal_values(u::Vector{Float64}, conn::Connectivity) = u[conn.conn]
scatter_nodal_values(u::Matrix{Float64}, conn::Connectivity) = u[conn.conn, :]

# implementation
function initialize_connectivity!(conn::Vector{Int64}, new_conn::Matrix{Int64})
    N_e, N_n = size(new_conn)
    for e = 1:N_e
        @inbounds local_conn = conn[(e - 1)*N_n + 1:e*N_n]
        for n = 1:N_n
            @inbounds new_conn[e, n] = local_conn[n]
        end
    end
end

end # module