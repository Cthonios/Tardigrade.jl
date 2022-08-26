[![CI](https://github.com/cmhamel/Tardigrade.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/cmhamel/Tardigrade.jl/actions/workflows/ci.yml)
[![codecov.io](http://codecov.io/github/cmhamel/Tardigrade.jl/coverage.svg?branch=master)](http://codecov.io/github/cmhamel/Tardigrade.jl?branch=master)

# Tardigrade.jl

The main purpose of Tardigrade.jl is to provide an educational and free to use for both a library and production finite element level tools.
All modules are intended to be standalone such that researches can pick and choose pieces of the library without being glued into it.
Certain modules are meant to be generic (i.e. the Meshes module) where new types (such as Exodus vs. vtk meshes) can be readily added through a common
interface. 

Our hopes is to provide a tool that can handle multi-material multi-physics computational mechanics with state. Think highly coupled
multiphysics behavior of materials in solid mechanics.

Currently the only supported mesh type is the exodusII format through Exodus.jl but if you'd like a different mesh format please create
a pull request.

Some of the structure of the library is heavily inspired by the MOOSE finite elmenet program from Idaho National Laboratories, but our goal is to 
have a completely Julian (except for maybe some artifacts) implementation of highly coupled finite elements.

This is still very much a work in progress...

WTF JEKYLL!!!
