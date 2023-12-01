using BenchmarkTools
using GeometryBasics
using MarchingCubes
using Meshes
using PlyIO
using Test

@testset "cushin" begin
    mc = MarchingCubes.scenario(case = :cushin)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 302
    @test length(mc.triangles) == 600
    @test sum(mc.triangles) == [88_810, 92_082, 91_975]
end

@testset "torus2" begin
    mc = MarchingCubes.scenario(case = :torus2)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_620
    @test sum(mc.triangles) == [127_813_396, 128_380_399, 128_374_999]
end

@testset "sphere" begin
    mc = MarchingCubes.scenario(case = :sphere)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 792
    @test length(mc.triangles) == 1572
    @test sum(mc.triangles) == [614_971, 624_389, 630_865]
end

@testset "plane" begin
    mc = MarchingCubes.scenario(case = :plane)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 7_038
    @test length(mc.triangles) == 13_720
    @test sum(mc.triangles) == [47_894_663, 47_913_678, 48_518_860]
end

@testset "cassini" begin
    mc = MarchingCubes.scenario(case = :cassini)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 554
    @test length(mc.triangles) == 1_104
    @test sum(mc.triangles) == [300_530, 308_212, 310_781]
end

@testset "blooby" begin
    mc = MarchingCubes.scenario(case = :blooby)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 2_168
    @test length(mc.triangles) == 4_352
    @test sum(mc.triangles) == [4_671_795, 4_741_706, 4_748_335]
end

@testset "hyperboloid" begin
    mc = MarchingCubes.scenario(case = :hyperboloid)
    bytes = @allocated march(mc)
    @test bytes == 0
    @test length(mc.vertices) == 12_297
    @test length(mc.triangles) == 24_118
    @test sum(mc.triangles) == [147_850_754, 148_522_888, 148_543_731]
end

@testset "march" begin
    mc = MarchingCubes.scenario()

    march(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_620
    MarchingCubes.output(PlyIO, mc, tempname(); verbose = false)

    march_legacy(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_732
    MarchingCubes.output(PlyIO, mc, tempname(); verbose = false)
end

@testset "types" begin
    for F ∈ (Float16, Float32, Float64)
        for I ∈ (Int16, Int32, Int64, Int128, UInt16, UInt32, UInt64, UInt128)
            @test march(MarchingCubes.scenario(4, 4, 4; F, I)) isa Nothing
        end
    end
end

@testset "normalize" begin
    nx, ny, nz = 10, 20, 30
    start_x, stop_x = -0.1, 0.1
    start_y, stop_y = -10, 10
    start_z, stop_z = 100, 200
    mc = MC(
        rand(nx, ny, nz) .- 0.5,
        Int;
        x = collect(Float64, range(start_x, stop_x, length = nx)),
        y = collect(Float64, range(start_y, stop_y, length = ny)),
        z = collect(Float64, range(start_z, stop_z, length = nz)),
    )
    for callable ∈ (march, march_legacy)
        callable(mc)
        @test all(map(v -> start_x ≤ v[1] ≤ stop_x, mc.vertices))
        @test all(map(v -> start_y ≤ v[2] ≤ stop_y, mc.vertices))
        @test all(map(v -> start_z ≤ v[3] ≤ stop_z, mc.vertices))
    end
end

@testset "isovalue" begin
    dat = Float32[(x - 3)^2 + (y - 3)^2 + (z - 3)^2 for x ∈ 1:5, y ∈ 1:5, z ∈ 1:5]

    m1 = MC(dat)
    march(m1, 5.0)

    m2 = MC(dat .- 5.0)
    march(m2)

    @test all(m1.triangles .≈ m2.triangles)
    @test all(m1.vertices .≈ m2.vertices)
    @test all(m1.normals .≈ m2.normals)
end

@testset "invert normals" begin
    dat = Float32[(x - 3)^2 + (y - 3)^2 + (z - 3)^2 for x ∈ 1:5, y ∈ 1:5, z ∈ 1:5]

    m1 = MC(dat)
    march(m1)

    m2 = MC(dat, normal_sign = -1)
    march(m2)

    @test all(MarchingCubes.norm.(m1.normals) .≈ MarchingCubes.norm.(m2.normals))

    @test_throws ArgumentError MC(dat; normal_sign = +2)
    @test_throws ArgumentError MC(dat; normal_sign = -2)
end

@testset "makemesh" begin
    mc = MarchingCubes.scenario()
    march(mc)

    msh = MarchingCubes.makemesh(Meshes, mc)
    @test msh isa Meshes.SimpleMesh
    @test nvertices(msh) == length(mc.vertices)
    @test nelements(topology(msh)) == length(mc.triangles)

    msh = MarchingCubes.makemesh(GeometryBasics, mc)
    @test msh isa GeometryBasics.Mesh
    @test length(msh.position) == length(mc.vertices)
    @test length(msh.normals) == length(mc.normals)

    @test_throws ArgumentError MarchingCubes.makemesh(PlyIO, mc)
end
