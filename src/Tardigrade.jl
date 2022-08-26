module Tardigrade

export Elements
export Fields
export Meshes
export Quadratures
export ShapeFunctions

# lots of other things depend on Meshes.jl so load that first
include("Meshes.jl")

# rest can be alphabetical hopefully
include("./elements/Elements.jl")
include("Fields.jl")
include("Quadratures.jl")
include("ShapeFunctions.jl")

end # module
