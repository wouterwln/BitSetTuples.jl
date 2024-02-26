using BitSetTuples
using BenchmarkTools
using PkgBenchmark

result, name = if ARGS == []
    PkgBenchmark.benchmarkpkg(BitSetTuples), "current"
else
    BenchmarkTools.judge(
        BitSetTuples,
        ARGS[1];
        judgekwargs = Dict(:time_tolerance => 0.1, :memory_tolerance => 0.05),
    ),
    ARGS[1]
end

export_markdown("benchmark_vs_$(name)_result.md", result)
