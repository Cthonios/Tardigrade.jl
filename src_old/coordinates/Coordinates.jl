module CoordinatesModule

export Coordinates

import ..ConnectivityModule: Connectivity
import ..ConnectivityModule: scatter_nodal_values

abstract type AbstractCoordinates end

# coordinates for this block organized by elements
struct Coordinates <: AbstractCoordinates
    coords::Array{Float64,3}
    function Coordinates(coords::Matrix{Float64}, conn::Connectivity)
        return new(scatter_nodal_values(coords, conn))
    end
end

# interface
Base.getindex(c::Coordinates, e) = c.coords[e, :, :]
Base.size(c::Coordinates) = size(c.coords)
Base.size(c::Coordinates, dim) = size(c.coords, dim)
Base.iterate(c::Coordinates, state=1) = state > size(c.coords, 1) ? nothing : (getindex(c, state), state + 1)

end # module