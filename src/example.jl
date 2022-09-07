scenario(nx = 60, ny = 60, nz = 60; F = Float32, I = Int32, case = :torus2) = begin
    vol = zeros(F, nx, ny, nz)

    sx, sy, sz = size(vol) ./ F(16)
    tx = F(nx) / 2sx
    ty = F(ny) / 2sy + F(1.5)
    tz = F(nz) / 2sz

    r = F(1.85)
    R = F(4)

    callback = if case ≡ :cushin
        (x, y, z) ->
            z^2 * x^2 - z^4 - 2z * x^2 + 2z^3 + x^2 - z^2 - (x^2 - z)^2 - y^4 - 2x^2 * y^2 - y^2 * z^2 +
            2y^2 * z +
            y^2
    elseif case ≡ :torus2
        (x, y, z) ->
            ((x^2 + y^2 + z^2 + R^2 - r^2)^2 - 4R^2 * (x^2 + y^2)) *
            ((x^2 + (y + R)^2 + z^2 + R^2 - r^2)^2 - 4R^2 * ((y + R)^2 + z^2))
    elseif case ≡ :sphere
        (x, y, z) -> (
            ((x - 2)^2 + (y - 2)^2 + (z - 2)^2 - 1) *
            ((x + 2)^2 + (y - 2)^2 + (z - 2)^2 - 1) *
            ((x - 2)^2 + (y + 2)^2 + (z - 2)^2 - 1)
        )
    elseif case ≡ :plane
        (x, y, z) -> x + y + z - 3
    elseif case ≡ :cassini
        (x, y, z) ->
            (x^2 + y^2 + z^2 + F(0.45)^2)^2 - 16 * F(0.45)^2 * (x^2 + z^2) - F(0.5)^2
    elseif case ≡ :blooby
        (x, y, z) -> x^4 - 5x^2 + y^4 - 5y^2 + z^4 - 5z^2 + F(11.8)
    elseif case ≡ :hyperboloid
        (x, y, z) -> x^2 + y^2 - z^2 - 1
    end

    for k ∈ 1:nz, j ∈ 1:ny, i ∈ 1:nx
        vol[i, j, k] = callback((i - 1) / sx - tx, (j - 1) / sy - ty, (k - 1) / sz - tz)
    end

    MC(vol, I)
end

output(PlyIO::Module, m::MC, fn::AbstractString = "test.ply") = begin
    ply = PlyIO.Ply()
    push!(
        ply,
        PlyIO.PlyElement(
            "vertex",
            PlyIO.ArrayProperty("x", Float32[v[1] for v ∈ m.vertices]),
            PlyIO.ArrayProperty("y", Float32[v[2] for v ∈ m.vertices]),
            PlyIO.ArrayProperty("z", Float32[v[3] for v ∈ m.vertices]),
            PlyIO.ArrayProperty("nx", Float32[n[1] for n ∈ m.normals]),
            PlyIO.ArrayProperty("ny", Float32[n[2] for n ∈ m.normals]),
            PlyIO.ArrayProperty("nz", Float32[n[3] for n ∈ m.normals]),
        ),
    )
    vertex_indices = PlyIO.ListProperty("vertex_indices", UInt8, Int32)
    for i ∈ eachindex(m.triangles)
        push!(vertex_indices, m.triangles[i] .- 1)
    end
    push!(ply, PlyIO.PlyElement("face", vertex_indices))

    PlyIO.save_ply(ply, fn, ascii = true)
    return
end

makemesh(Meshes::Module, m::MC) = begin
    points = Meshes.Point3[Tuple(pt) for pt ∈ m.vertices]
    tris = Meshes.connect.([Tuple(tri) for tri ∈ m.triangles], Meshes.Triangle)
    Meshes.SimpleMesh(points, [tris;])
end
