module Assembly

using SparseArrays

# function gather_element_level_residuals_and_tangents!(Nₑ, Nₙ_per_e, conn,
#                                                       coords, u,
#                                                       quadrature, Nξ_method, ∇Nξ_method,
#                                                       kernel,
#                                                       connₑs, Rₑs, Kₑs)
#     local_nodes = zeros(Int64, Nₙ_per_e)
#     local_coords = zeros(Float64, 4, 2)
#     local_u = zeros(Float64, 4, 2)
#     N_d = size(coords, 2)
#     # TODO: figure out broadcasting
#     for e = 1:Nₑ
#         # set up local conn, coords, and us arrays
#         #
#         local_nodes[:] = conn[Nₙ_per_e*(e - 1) +_1:Nₙ_per_e*e]
#         local_coords .= zero(Float64)
#         local_u .= zero(Float64)
#         @simd for i=1:Nₙ_per_e
#             @simd for j=1:N_d
#                 local_coords[i, j] = coords[local_nodes[i], j]
#             end
#             local_u[i] = u[local_nodes[i]]
#         end
#
#         connₑs[e, :] = local_nodes[:]
#
#         # now update the residuals and tangents
#         #
#         kernel(local_coords, local_u, quadrature, Nξ_method, ∇Nξ_method,
#                Rₑs[e, :], Kₑs[e, :, :])
#     end
# end

# function assemble_element_level_residual_and_tangents!(Nₑ, Nₙ_per_e, conn,
#                                                        Kₑs, Rₑs, K, R)
function assemble_element_level_residual_and_tangents!(connₑs, Kₑs, Rₑs, K, R)
    Nₑ, Nₙ_per_e = size(connₑs, 1), size(connₑs, 2)

    # do residual first since this is dense
    #
    @simd for e =

    ii = Vector{Int64}(Nₙ_per_e * Nₙ_per_e * Nₑ)
    jj = Vector{Int64}(Nₙ_per_e * Nₙ_per_e * Nₑ)
    values = Vector{Float64}(Nₙ_per_e * Nₙ_per_e * Nₑ)
    index = 0
    for i=1:Nₙ_per_e; j=1:Nₙ_per_e
        @inbounds begin
            ii[index + 1:index + Nₑ] = connₑs[:, i]
            jj[index + 1:index + Nₑ] = connₑs[:, j]
            values = sum(Kₑs[:, :, i] .*)
        end
    end
end

end
