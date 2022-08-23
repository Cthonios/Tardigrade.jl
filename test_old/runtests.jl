# using BenchmarkTools
using Test

using Tardigrade.Assembly
using Tardigrade.Kernels
using Tardigrade.Meshes
using Tardigrade.Parser
using Tardigrade.Quadratures
using Tardigrade.Sections
using Tardigrade.ShapeFunctions


# TODO figure out which modules make sense to make a standalone test input_file
# so this isn't massive
include("Assembly.jl")
include("Kernels.jl")
include("Meshes.jl")
include("Parser.jl")
include("Quadratures.jl")
include("Sections.jl")
include("ShapeFunctions.jl")
