using Documenter
push!(LOAD_PATH, "../src/")
using Tardigrade
using Tardigrade.Meshes
# using Tardigrade.Parser
using Tardigrade.Quadratures
# using Tardigrade.Sections
# using Tardigrade.ShapeFunctions

pages = [
    "Home"                   => "index.md",
    "Table of Contents"      => "toc.md",
    "Tardigrade"             => "Tardigrade.md",
    "Tardigrade.Meshes"      => "Meshes.md",
    "Tardigrade.Quadratures" => "Quadratures.md"
]

# makedocs(sitename="Tardigrade.jl",
#          modules=[Tardigrade],
#          pages=["Home" => "index.md"])

makedocs(sitename="Tardigrade.jl",
         format=Documenter.HTML(),
         modules=[Tardigrade],
         pages=pages)

deploydocs(repo="github.com/cmhamel/Tardigrade.jl.git")