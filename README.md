# GrayCodeIterator.jl

GrayCodeIterator.jl provides an iterator for all binary vectors of length $n$ and weight $k$, optionally with a supplied prefix.

```julia
for v in GrayCode(4,2)
    println(v)
end
```


