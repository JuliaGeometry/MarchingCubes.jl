# MarchingCubes

Julia port of [Efficient Implementation of Marching Cubes' Cases with Topological Guarantees](https://www.tandfonline.com/doi/abs/10.1080/10867651.2003.10487582).

[Public article](http://thomas.lewiner.org/pdfs/marching_cubes_jgt.pdf).

# C++ implementation

Adapted to `Julia` (`1`-based indexing) from the original [c++ implementation](http://thomas.lewiner.org/srcs/marching_cubes_jgt.zip) (`0`-based indexing).

# Tiny benchmark

```bash
$ g++ -O3 ply.c main.cpp MarchingCubes.cpp
$ ./a.out
Marching Cubes ran in 0.007834 secs.
$ julia -e 'using BenchmarkTools, MarchingCubes; mc = MarchingCubes.test_scenario(); @btime march(mc)'
  7.936 ms (0 allocations: 0 bytes)
```

# Original BibTeX

```
@article{marching_cubes_jgt,
    author = {Thomas Lewiner and Hélio Lopes and Antônio Wilson Vieira and Geovan Tavares},
    title = {Efficient implementation of marching cubes cases with topological guarantees},
    year = {2003},
    month = {december},
    journal = {Journal of Graphics Tools},
    volume = {8},
    number = {2},
    pages = {1--15},
    publisher = {A.K.Peters},
    doi = {10.1080/10867651.2003.10487582},
    url = {\url{http://thomas.lewiner.org/pdfs/marching_cubes_jgt.pdf}}
}
```
