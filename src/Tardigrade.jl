module Tardigrade

export BoundaryConditions
export Elements
export Fields
export Meshes
export Quadratures
export ShapeFunctions
export StaticQuadratures

export parse_input_file

import YAML: load_file

# lots of other things depend on Meshes.jl so load that first
include("Meshes.jl")

# rest can be alphabetical hopefully
include("./boundary_conditions/BoundaryConditions.jl")
include("./elements/Elements.jl")
include("Fields.jl")
include("Quadratures.jl")
include("ShapeFunctions.jl")

include("StaticQuadratures.jl")

parse_input_file(file_name::String) = load_file(file_name)

end # module
