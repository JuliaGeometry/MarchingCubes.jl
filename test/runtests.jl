using BenchmarkTools
using MarchingCubes
using PlyIO
using Test

@testset "march" begin
    mc = MarchingCubes.scenario()

    march(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_620
    MarchingCubes.output(PlyIO, mc, tempname())

    march_legacy(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_732
    MarchingCubes.output(PlyIO, mc, tempname())
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
    march(mc)
    @test all(map(v -> start_x ≤ v[1] ≤ stop_x, mc.vertices))
    @test all(map(v -> start_y ≤ v[2] ≤ stop_y, mc.vertices))
    @test all(map(v -> start_z ≤ v[3] ≤ stop_z, mc.vertices))
end

@testset "plane" begin
    mc = MarchingCubes.scenario(case = :plane)
    march(mc)
    @test length(mc.vertices) == 7_038
    @test length(mc.triangles) == 13_720
end

@testset "sphere" begin
    mc = MarchingCubes.scenario(case = :sphere)
    march(mc)
    @test length(mc.vertices) == 792
    @test length(mc.triangles) == 1572
end

@testset "hyperboloid" begin
    mc = MarchingCubes.scenario(case = :hyperboloid)
    march(mc)
    @test length(mc.vertices) == 12_297
    @test length(mc.triangles) == 24_118
end