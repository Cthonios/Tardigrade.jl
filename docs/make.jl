using Documenter
push!(LOAD_PATH, "../src/")
using Tardigrade
using Tardigrade.Meshes
using Tardigrade.Quadratures

pages = [
    "Home"              => "index.md",
    "Table of Contents" => "toc.md",
    "Tardigrade"        => "Tardigrade.md",
    "Meshes"            => "Meshes.md",
    "Quadratures"       => "Quadratures.md"
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