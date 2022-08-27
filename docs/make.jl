using Documenter
push!(LOAD_PATH, "../src/")
using Tardigrade

pages = [
    "Home"              => "index.md",
    "Table of Contents" => "toc.md",
    "Tardigrade"        => "Tardigrade.md",
    "Elements"          => "Elements.md",
    "Fields"            => "Fields.md",
    "Meshes"            => "Meshes.md",
    "Quadratures"       => "Quadratures.md",
    "ShapeFunctions"    => "ShapeFunctions.md"
]

makedocs(
    sitename = "Tardigrade.jl",
    modules  = [Tardigrade],
    pages    = pages,
    strict   = true
)

deploydocs(
    repo="github.com/cmhamel/Tardigrade.jl.git"
)