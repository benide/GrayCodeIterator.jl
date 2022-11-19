# GrayCodeIterator.jl

[![Build Status](https://github.com/benide/GrayCodeIterator.jl/actions/workflows/Test.yml/badge.svg?branch=master)](https://github.com/benide/GrayCodeIterator.jl/actions/workflows/Test.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/benide/GrayCodeIterator.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/benide/GrayCodeIterator.jl)

GrayCodeIterator.jl provides an iterator for all binary vectors of length $n$ and weight $k$, optionally with a supplied prefix.

```julia-repl
julia> for v in GrayCode(4,2)
           println(v)
       end
[0, 0, 1, 1]
[0, 1, 1, 0]
[0, 1, 0, 1]
[1, 1, 0, 0]
[1, 0, 1, 0]
[1, 0, 0, 1]

julia> for v in GrayCode(4,2,[1,0])
           println(v)
       end
[1, 0, 0, 1]
[1, 0, 1, 0]
```

The vector can be modified in-place to save allocations:

```julia-repl
julia> using BenchmarkTools

julia> @btime sum(maximum(v) for v in GrayCode(23,13))
  54.801 ms (1144073 allocations: 261.86 MiB)
1144066

julia> @btime sum(maximum(v) for v in GrayCode(23,13,mutate=true))
  15.782 ms (7 allocations: 1.12 KiB)
1144066
```

Note that this only saves allocations for Julia 1.8+.

# References

The algorithm is based on the following paper:

Bitner, J. R., Ehrlich, G., & Reingold, E. M. (1976). Efficient generation of the binary reflected Gray code and its applications. *Communications of the ACM, 19*(9), 517-521.
