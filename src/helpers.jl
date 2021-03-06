############################################################
# FactCheck.jl
# A testing framework for Julia
# http://github.com/JuliaLang/FactCheck.jl
# MIT Licensed
############################################################
# Assertion helpers
# - not
# - anything
# - truthy, falsey/falsy
# - exactly
# - roughly
# - anyof
############################################################

# not: logical not for values and functions
not(x) = isa(x, Function) ? (y) -> !x(y) :
                            (y) -> x != y

# anything: anything but nothing
anything(x) = (x != nothing)

# truthy: not `nothing`, false (== 0)
# falsy/falsey: not truthy
truthy(x) = (x != nothing) && (x != false)
falsey(x) = not(truthy(x))
falsy = falsey

# exactly: tests object/function equality (i.e. ===)
exactly(x) = (y) -> is(x, y)

# approx/roughly: Comparing numbers approximately
roughly(x::Number, atol) = (y::Number) -> isapprox(y, x, atol=atol)
roughly(x::Number; kvtols...) = (y::Number) -> isapprox(y, x; kvtols...)

roughly(A::AbstractArray, atol) = (B::AbstractArray) -> begin
    size(A) != size(B) && return false
    for i in 1:length(A)
        !isapprox(A[i], B[i], atol=atol) && return false
    end
    return true
end
roughly(A::AbstractArray; kvtols...) = (B::AbstractArray) -> begin
    size(A) != size(B) && return false
    for i in 1:length(A)
        !isapprox(A[i], B[i]; kvtols...) && return false
    end
    return true
end

# anyof: match any of the arguments
anyof(x...) = y -> any(arg->(isa(arg,Function) ? arg(y) : (y==arg)), x)

# less_than: Comparing two numbers
less_than(compared) = (compare) -> compare < compared

# less_than_or_equal: Comparing two numbers
less_than_or_equal(compared) = (compare) -> compare <= compared

# greater_than: Comparing two numbers
greater_than(compared) = (compare) -> compare > compared

# greater_than_or_equal: Comparing two numbers
greater_than_or_equal(compared) = (compare) -> compare >= compared
