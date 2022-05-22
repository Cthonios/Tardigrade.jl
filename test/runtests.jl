using Test

using Tardigrade.Parser
using Tardigrade.Meshes
using Tardigrade.Quadratures
using Tardigrade.ShapeFunctions
using Tardigrade.Sections

# TODO figure out which modules make sense to make a standalone test input_file
# so this isn't massive
include("Parser.jl")
include("Meshes.jl")
include("Quadratures.jl")
include("ShapeFunctions.jl")
include("Sections.jl")
