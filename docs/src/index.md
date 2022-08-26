# Tardigrade

## Inspiration
The main inspiration for Tardigrade.jl came from the INL FEM code Moose. Moose is a fully-implicit FEM code meant for highly coupled physics problems. It has shown great success in various fields such as coupled phase-field/solid mechanics, nuclear reactor design, etc. After using Moose for sometime, this package's author found the solid mechanics modules slightly cumbersome, especially for generalizing constitutive models for materials with state. Also, developing in C++ is not nearly as fun as julia!

## Documentation
```@contents
Pages = [
    "Tardigrade.md",
    "Fields.md",
    "Meshes.md",
    "Quadratures.md",
    "ShapeFunctions.md"
]
```
