# Benchmark Report for */Users/wnuijten/.julia/dev/BitSetTuples*

## Job Properties
* Time of benchmark: 26 Feb 2024 - 16:34
* Package commit: dirty
* Julia commit: 7790d6
* Julia command flags: None
* Environment variables: None

## Results
Below is a table of this job's results, obtained by running the benchmarks.
The values listed in the `ID` column have the structure `[parent_group, child_group, ..., key]`, and can be used to
index into the BaseBenchmarks suite to retrieve the corresponding benchmarks.
The percentages accompanying time and memory values in the below table are noise tolerances. The "true"
time/memory value for a given benchmark is expected to fall within this percentage of the reported value.
An empty cell means that the value was zero.

| ID                                   | time            | GC time | memory          | allocations |
|--------------------------------------|----------------:|--------:|----------------:|------------:|
| `["bounded_constructor_10"]`         |  69.800 ns (5%) |         |  288 bytes (1%) |           3 |
| `["bounded_constructor_100"]`        |   1.771 μs (5%) |         |  11.38 KiB (1%) |           3 |
| `["bounded_constructor_2"]`          |  48.436 ns (5%) |         |  176 bytes (1%) |           3 |
| `["bounded_constructor_5"]`          |  52.221 ns (5%) |         |  192 bytes (1%) |           3 |
| `["bounded_intersect_10"]`           |   0.001 ns (5%) |         |                 |             |
| `["bounded_intersect_100"]`          |   0.001 ns (5%) |         |                 |             |
| `["bounded_intersect_5"]`            |   0.001 ns (5%) |         |                 |             |
| `["bounded_intersect_50"]`           |   0.001 ns (5%) |         |                 |             |
| `["bounded_is_valid_partition_10"]`  |   1.083 μs (5%) |         |   3.98 KiB (1%) |          26 |
| `["bounded_is_valid_partition_100"]` |  55.125 μs (5%) |         |  45.70 KiB (1%) |         215 |
| `["bounded_is_valid_partition_5"]`   | 538.086 ns (5%) |         |   1.83 KiB (1%) |          16 |
| `["bounded_is_valid_partition_50"]`  |  17.959 μs (5%) |         |  31.28 KiB (1%) |         115 |
| `["bounded_union_10"]`               |   0.001 ns (5%) |         |                 |             |
| `["bounded_union_100"]`              |   0.001 ns (5%) |         |                 |             |
| `["bounded_union_5"]`                |   0.001 ns (5%) |         |                 |             |
| `["bounded_union_50"]`               |   0.001 ns (5%) |         |                 |             |
| `["constructor_10"]`                 | 483.549 ns (5%) |         |   1.34 KiB (1%) |          21 |
| `["constructor_100"]`                |   5.286 μs (5%) |         |  13.30 KiB (1%) |         201 |
| `["constructor_2"]`                  | 230.155 ns (5%) |         |  288 bytes (1%) |           5 |
| `["constructor_5"]`                  | 460.332 ns (5%) |         |  688 bytes (1%) |          11 |
| `["intersect_10"]`                   |  41.000 ns (5%) |         |   96 bytes (1%) |           1 |
| `["intersect_100"]`                  |   3.250 μs (5%) |         |  816 bytes (1%) |           1 |
| `["intersect_5"]`                    |  41.000 ns (5%) |         |   48 bytes (1%) |           1 |
| `["intersect_50"]`                   | 541.000 ns (5%) |         |  448 bytes (1%) |           1 |
| `["is_valid_partition_10"]`          |   7.945 μs (5%) |         |  10.54 KiB (1%) |         138 |
| `["is_valid_partition_100"]`         | 342.792 μs (5%) |         | 435.05 KiB (1%) |        1740 |
| `["is_valid_partition_5"]`           |   4.351 μs (5%) |         |   5.44 KiB (1%) |          77 |
| `["is_valid_partition_50"]`          | 108.291 μs (5%) |         | 106.45 KiB (1%) |         774 |
| `["union_10"]`                       | 125.000 ns (5%) |         |   96 bytes (1%) |           1 |
| `["union_100"]`                      |   3.084 μs (5%) |         |  816 bytes (1%) |           1 |
| `["union_5"]`                        |   0.001 ns (5%) |         |   48 bytes (1%) |           1 |
| `["union_50"]`                       | 458.000 ns (5%) |         |  448 bytes (1%) |           1 |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `[]`

## Julia versioninfo
```
Julia Version 1.10.1
Commit 7790d6f0641 (2024-02-13 20:41 UTC)
Build Info:
  Official https://julialang.org/ release
Platform Info:
  OS: macOS (arm64-apple-darwin22.4.0)
  uname: Darwin 23.2.0 Darwin Kernel Version 23.2.0: Wed Nov 15 21:53:18 PST 2023; root:xnu-10002.61.3~2/RELEASE_ARM64_T6000 arm64 arm
  CPU: Apple M1 Pro: 
              speed         user         nice          sys         idle          irq
       #1  2400 MHz    1230629 s          0 s     741879 s    2921827 s          0 s
       #2  2400 MHz    1229133 s          0 s     732262 s    2950732 s          0 s
       #3  2400 MHz     565206 s          0 s     207698 s    4264483 s          0 s
       #4  2400 MHz     398416 s          0 s     129993 s    4519571 s          0 s
       #5  2400 MHz     254354 s          0 s      75893 s    4723840 s          0 s
       #6  2400 MHz     214202 s          0 s      54852 s    4788974 s          0 s
       #7  2400 MHz     123954 s          0 s      30622 s    4906576 s          0 s
       #8  2400 MHz      83905 s          0 s      21685 s    4957059 s          0 s
  Memory: 32.0 GB (227.546875 MB free)
  Uptime: 2.35325e6 sec
  Load Avg:  6.4326171875  4.1796875  3.6689453125
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, apple-m1)
Threads: 1 default, 0 interactive, 1 GC (on 6 virtual cores)
```