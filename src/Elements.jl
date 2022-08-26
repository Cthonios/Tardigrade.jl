module Elements

using ..Quadratures

"""
    AbstractElement
Parent type for all elements.
"""
abstract type AbstractElement end

"""
    Element{N, D}
Empty container for passing around types
"""
struct Element{N, D} <: AbstractElement
    quadrature::Quadrature
    φ::Function
    ∇φ::Function
end

Quad4 = Element{4, 2}()
# Hex8 = Element{8, 3}



end # modules