using Documenter
push!(LOAD_PATH, "../src/")
using Tardigrade
using Tardigrade.Meshes
using Tardigrade.Parser
using Tardigrade.Quadratures

makedocs(sitename="Tardigrade.jl",
         modules=[Tardigrade],
         pages=["Home" => "index.md"])