using BitSetTuples
using BenchmarkTools
using PkgBenchmark

args = ARGS == [] ? ["main"] : ARGS
arg = first(args)

result = BenchmarkTools.judge(BitSetTuples, arg)
export_markdown("benchmark_vs_$(arg)_result.md", result)
