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
            PlyIO.ArrayProperty("x", map(v -> Float32(v[1]), m.vertices)),
            PlyIO.ArrayProperty("y", map(v -> Float32(v[2]), m.vertices)),
            PlyIO.ArrayProperty("z", map(v -> Float32(v[3]), m.vertices)),
            PlyIO.ArrayProperty("nx", map(n -> Float32(n[1]), m.normals)),
            PlyIO.ArrayProperty("ny", map(n -> Float32(n[2]), m.normals)),
            PlyIO.ArrayProperty("nz", map(n -> Float32(n[3]), m.normals)),
        ),
    )
    vertex_indices = PlyIO.ListProperty("vertex_indices", UInt8, Int32)
    for i ∈ eachindex(m.triangles)
        push!(vertex_indices, m.triangles[i] .- 1)
    end
    push!(ply, PlyIO.PlyElement("face", vertex_indices))

    PlyIO.save_ply(ply, fn, ascii = true)
    nothing
end

makemesh_Meshes(Meshes::Module, m::MC) = begin
    points = map(Meshes.Point3 ∘ Tuple, m.vertices)
    tris = Meshes.connect.(map(Tuple, m.triangles), Meshes.Triangle)
    Meshes.SimpleMesh(points, [tris;])
end

makemesh_GeometryBasics(GeometryBasics::Module, m::MC, invert_normals::Bool=false) = begin
    vertices = map(GeometryBasics.Point3f, m.vertices)
    normals = map(GeometryBasics.Vec3f, m.normals)
    triangles = map(t -> GeometryBasics.TriangleFace(t...), m.triangles)
    GeometryBasics.Mesh(GeometryBasics.meta(vertices; normals), triangles)
end

makemesh(mod::Module, m::MC) =
    if (mod_str = string(mod)) == "Meshes"
        makemesh_Meshes(mod, m)
    elseif mod_str == "GeometryBasics"
        makemesh_GeometryBasics(mod, m)
    else
        throw(ArgumentError("un-supported module `$mod`"))
    end
