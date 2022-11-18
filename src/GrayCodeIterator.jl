module GrayCodeIterator

struct GrayCode
    n::Int # length of codewords
    k::Int # weight of codewords
    ns::Int # n for the subcode
    ks::Int # k for the subcode
    prefix::Vector{Int}
    prefix_length::Int
end

GrayCode(n::Int, k::Int) = GrayCode(n, k, n, k, Int[], 0)

function GrayCode(n::Int, k::Int, prefix::Vector{Int})
    GrayCode(n, k,
             n - length(prefix),
             k - count(prefix .!= 0),
             prefix,
             length(prefix))
end

Base.IteratorEltype(::GrayCode) = Base.HasEltype()
Base.eltype(::GrayCode) = Array{Int, 1}
Base.IteratorSize(::GrayCode) = Base.HasLength()
function Base.length(G::GrayCode)
    if 0 <= G.ks <= G.ns
        factorial(big(G.ns)) ÷ (factorial(big(G.ks)) * factorial(big(G.ns - G.ks)))
    else
        0
    end
end
Base.in(v::Vector{Int}, G::GrayCode) = length(v) == G.n && count(v .!= 0) == G.k && view(v, 1:G.prefix_length) == G.prefix

@inline function Base.iterate(G::GrayCode)
    0 <= G.ks <= G.ns || return nothing

    g = [i <= G.ks ? 1 : 0 for i = 1:G.ns+1]
    τ = collect(2:G.ns+2)

    t = G.ks
    τ[1] = G.ks + 1

    # to force stopping with returning the only valid vector when ks == 0 and ns > 0
    if iszero(G.ks)
        τ[1] = G.ns + 1
    end

    v = [G.prefix; g[end-1:-1:1]]

    return (v, (g,τ,t,v))
end

@inline function Base.iterate(G::GrayCode, state)
    g, τ, t, v = state
    i = τ[1]
    i < G.ns + 1 || return nothing

    @inbounds begin

        τ[1] = τ[i]
        τ[i] = i + 1

        if g[i] == 1
            if t != 0
                g[t] = g[t] == 0 ? 1 : 0
                if t < G.ns + 1
                    v[G.prefix_length + G.ns + 1 - t] = g[t]
                end
            else
                g[i-1] = g[i-1] == 0 ? 1 : 0
                if i-1 < G.ns + 1
                    v[G.prefix_length + G.ns + 1 - (i-1)] = g[i-1]
                end
            end
            t = t + 1
        else
            if t != 1
                g[t-1] = g[t-1] == 0 ? 1 : 0
                if t-1 < G.ns + 1
                    v[G.prefix_length + G.ns + 1 - (t-1)] = g[t-1]
                end
            else
                g[i-1] = g[i-1] == 0 ? 1 : 0
                if i-1 < G.ns + 1
                    v[G.prefix_length + G.ns + 1 - (i-1)] = g[i-1]
                end
            end
            t = t - 1
        end

        g[i] = g[i] == 0 ? 1 : 0
        if i < G.ns + 1
            v[G.prefix_length + G.ns + 1 - i] = g[i]
        end

        if t == i-1 || t == 0
            t = t + 1
        else
            t = t - g[i-1]
            τ[i-1] = τ[1]
            if t == 0
                τ[1] = i - 1
            else
                τ[1] = t + 1
            end
        end
    end

    return (v, (g,τ,t,v))
end

export GrayCode

end
