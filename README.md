[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)
[![CI](https://github.com/JuliaGeometry/MarchingCubes.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaGeometry/MarchingCubes.jl/actions/workflows/ci.yml)
[![PkgEval](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/M/MarchingCubes.svg)](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html)
[![Coverage Status](https://codecov.io/gh/JuliaGeometry/MarchingCubes.jl/branch/main/graphs/badge.svg)](https://app.codecov.io/gh/JuliaGeometry/MarchingCubes.jl)
[![MarchingCubes Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FMarchingCubes&query=total_requests&suffix=%2Fmonth&label=Downloads)](https://juliapkgstats.com/pkg/MarchingCubes)

# MarchingCubes

Julia port of [Efficient Implementation of Marching Cubes' Cases with Topological Guarantees](https://www.tandfonline.com/doi/abs/10.1080/10867651.2003.10487582).

Public article available [here](http://thomas.lewiner.org/pdfs/marching_cubes_jgt.pdf).

# Implementation

Adapted to `Julia` (`1` based indexing) from the original [c++ implementation](http://thomas.lewiner.org/srcs/marching_cubes_jgt.zip) (`0` based indexing).

# Tiny benchmark - visualization with ParaView

```bash
$ g++ -O3 ply.c main.cpp MarchingCubes.cpp
$ ./a.out
Marching Cubes ran in 0.007834 secs.
$ julia --check-bounds=no
julia> using BenchmarkTools, MarchingCubes
julia> mc = MarchingCubes.scenario();
julia> @btime march($mc)
  7.865 ms (0 allocations: 0 bytes)
julia> @btime march_legacy($mc)
  9.268 ms (0 allocations: 0 bytes)
julia> using PlyIO
julia> MarchingCubes.output(PlyIO, mc)  # writes "test.ply" (can be opened in a viewer, e.g. ParaView)
```

Test scenario output:
![ParaView Torus](https://github.com/JuliaGeometry/MarchingCubes.jl/raw/marchingcubes-docs/paraview-torus.png)

# MWE demonstrating visualization with MeshViz.jl

```julia
using MarchingCubes
using GLMakie
using MeshViz
using Meshes

mc = MarchingCubes.scenario()
march(mc)
msh = MarchingCubes.makemesh(Meshes, mc)
display(viz(msh))
```

![Meshviz Mesh](https://github.com/JuliaGeometry/MarchingCubes.jl/raw/marchingcubes-docs/meshviz-mesh.png)

# MWE demonstrating visualization with GeometryBasics.jl and Makie.jl

```julia
using GeometryBasics
using MarchingCubes
using GLMakie

mc = MarchingCubes.scenario()
march(mc)
msh = MarchingCubes.makemesh(GeometryBasics, mc)

fap = mesh(msh; color = :gray)
display(fap)
```

![Makie Mesh](https://github.com/JuliaGeometry/MarchingCubes.jl/raw/marchingcubes-docs/makie-mesh.png)


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

# License

This code is free to use under the terms of the MIT license.
