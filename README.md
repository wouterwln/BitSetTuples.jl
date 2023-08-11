# BitSetTuple

[![Build Status](https://github.com/wouterwln/BitSetTuple.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/wouterwln/BitSetTuple.jl/actions/workflows/CI.yml?query=branch%3Amain)  [![codecov](https://codecov.io/gh/wouterwln/BitSetTuples.jl/branch/main/graph/badge.svg?token=KA2MZFLB89)](https://codecov.io/gh/wouterwln/BitSetTuples.jl)

This package exports the `BitSetTuple` data structure and functions to manipulate them. A `BitSetTuple` is a tuple of `BitSet` objects that can be used to efficiently track multiple sets of low cardinality to which we have to concurrently apply set operations. 

## Usage
We can create a `BitSetTuple` using:
```julia
n = 5
BitSetTuple(n)
```
This will create a tuple of length 5 where all elements are `BitSet`s containing integers 1 through 5. `BitSetTuple`s can also be created by directly passing vectors or tuples of integers:
```julia
BitSetTuple([[1,2,3], [2,3,4], [4,5,6]])

BitSetTuple(((1,2,3), (2,3,4), (4,5,6)))
```

## Example Usage
Say we want to track, for a set of graphs over the same vertex set, which edges exist in all graphs. First, we will generate a collection of graphs:
```julia
using Graphs

n_graphs = 20
n_vertices = 30
e_prob = 0.8

function random_graph(n, e_prob)
    g = Graph(n)
    for i in 1:n
        for j in i:n
            if rand() < e_prob
                add_edge!(g, i, j)
            end
        end
    end
    return g
end
graphs = []
for _ in 1:n_graphs
    g = random_graph(n_vertices, e_prob)
    push!(graphs, g)
end
```
Next, we will write a function that uses a `BitSetTuple` to track the edges that exist in all graphs:
```julia
using BitSetTuples

function edges_in_all_graphs(graphs, n_vertices)
    edges = BitSetTuple(n_vertices)
    for graph in graphs
        g_edges = BitSetTuple(Graphs.neighbors.(Ref(graph), 1:n_vertices))
        intersect!(edges, g_edges)
    end
    return edges
end
```
We can use `BenchmarkTools` to benchmark our `BitSetTuple` implementation against a naive implementation that uses a `Set` under the hood:
```julia
using BenchmarkTools

# naive implementation
edges_in_all_graphs(graphs) = intersect(Set.(collect.(edges.(graphs)))...)

@benchmark edges_in_all_graphs(graphs, n_vertices)
@benchmark edges_in_all_graphs(graphs)
```

```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):   80.500 μs …   6.431 ms  ┊ GC (min … max): 0.00% … 93.84%
 Time  (median):      82.375 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   120.328 μs ± 246.504 μs  ┊ GC (mean ± σ):  8.47% ±  5.09%

  █▄▂▃▂▂▄▃▁           ▃▁                                        ▁
  ██████████▇▇▇▇▇▇█▇▇████▇▇▇▆▇▆▆▅▅▄▅▅▅▆▅▄▄▅▄▄▃▃▅▁▃▄▄▄▄▃▃▄▃▁▃▄▄▄ █
  80.5 μs       Histogram: log(frequency) by time        487 μs <

 Memory estimate: 132.28 KiB, allocs estimate: 2091.


BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  151.834 μs …   8.156 ms  ┊ GC (min … max):  0.00% … 96.01%
 Time  (median):     188.458 μs               ┊ GC (median):     0.00%
 Time  (mean ± σ):   280.975 μs ± 386.313 μs  ┊ GC (mean ± σ):  12.22% ±  9.57%

  █▆▅▅▃▃▂▂▁▃▂▁                                                  ▂
  ██████████████▆▆▆▆▆▅▆▄▅▅▄▅▅▄▅▁▄▃▄▄▁▃▁▄▁▃▃▃▃▁▄▃▃▁▄▁▄▁▄▄▁▁▄▁▄▁▅ █
  152 μs        Histogram: log(frequency) by time       2.52 ms <

 Memory estimate: 501.38 KiB, allocs estimate: 371.
```

We see that our implementation using `BitSetTuples` is faster and more memory efficient. However, we do allocate significantly more often than the naive implementation, suggesting there might be additional optimizations possible in this package.
