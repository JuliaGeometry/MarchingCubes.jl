@inline cb_cushin(x, y, z) = (
    z^2 * x^2 - z^4 - 2z * x^2 + 2z^3 + x^2 - z^2 - (x^2 - z)^2 - y^4 - 2x^2 * y^2 -
    y^2 * z^2 +
    2y^2 * z +
    y^2
)
@inline cb_torus2(x::F, y::F, z::F, r = F(1.85), R = F(4)) where {F} = (
    ((x^2 + y^2 + z^2 + R^2 - r^2)^2 - 4R^2 * (x^2 + y^2)) *
    ((x^2 + (y + R)^2 + z^2 + R^2 - r^2)^2 - 4R^2 * ((y + R)^2 + z^2))
)
@inline cb_sphere(x, y, z) = (
    ((x - 2)^2 + (y - 2)^2 + (z - 2)^2 - 1) *
    ((x + 2)^2 + (y - 2)^2 + (z - 2)^2 - 1) *
    ((x - 2)^2 + (y + 2)^2 + (z - 2)^2 - 1)
)
@inline cb_plane(x, y, z) = x + y + z - 3
@inline cb_cassini(x::F, y::F, z::F) where {F} =
    (x^2 + y^2 + z^2 + F(0.45)^2)^2 - 16 * F(0.45)^2 * (x^2 + z^2) - F(0.5)^2
@inline cb_blooby(x::F, y::F, z::F) where {F} =
    x^4 - 5x^2 + y^4 - 5y^2 + z^4 - 5z^2 + F(11.8)
@inline cb_hyperboloid(x, y, z) = x^2 + y^2 - z^2 - 1

fill_volume!(vol::AbstractArray{F}, cb::Function) where {F} = begin
    nx, ny, nz = shape = size(vol)

    sx, sy, sz = F.(shape ./ 16)
    tx = F(nx / 2sx)
    ty = F(ny / 2sy + 1.5)
    tz = F(nz / 2sz)

    @inbounds for k ∈ 1:nz, j ∈ 1:ny, i ∈ 1:nx
        vol[i, j, k] = cb(F((i - 1) / sx - tx), F((j - 1) / sy - ty), F((k - 1) / sz - tz))
    end

    nothing
end

scenario(nx = 60, ny = 60, nz = 60; F = Float32, I = Int32, case = :torus2, kw...) = begin
    vol = zeros(F, nx, ny, nz)

    callback = if case ≡ :cushin
        cb_cushin
    elseif case ≡ :torus2
        cb_torus2
    elseif case ≡ :sphere
        cb_sphere
    elseif case ≡ :plane
        cb_plane
    elseif case ≡ :cassini
        cb_cassini
    elseif case ≡ :blooby
        cb_blooby
    elseif case ≡ :hyperboloid
        cb_hyperboloid
    end::Function

    fill_volume!(vol, callback)

    MC(vol, I; kw...)
end

output(PlyIO::Module, m::MC{F,I}, fn::AbstractString = "test.ply") where {F,I} = begin
    nv, nt = length(m.vertices), length(m.triangles)
    println("Writing $nv vertices and $nt triangles using `PlyIO`.")

    ply = PlyIO.Ply()
    push!(
        ply,
        PlyIO.PlyElement(
            "vertex",
            PlyIO.ArrayProperty("x", getindex.(m.vertices, 1)),
            PlyIO.ArrayProperty("y", getindex.(m.vertices, 2)),
            PlyIO.ArrayProperty("z", getindex.(m.vertices, 3)),
            PlyIO.ArrayProperty("nx", getindex.(m.normals, 1)),
            PlyIO.ArrayProperty("ny", getindex.(m.normals, 2)),
            PlyIO.ArrayProperty("nz", getindex.(m.normals, 3)),
        ),
    )

    vertex_indices = PlyIO.ListProperty("vertex_indices", I, eltype(Triangle))
    for i ∈ eachindex(m.triangles)
        push!(vertex_indices, m.triangles[i] .- 1)  # 1-based indexing -> 0-based indexing
    end
    push!(ply, PlyIO.PlyElement("face", vertex_indices))

    PlyIO.save_ply(ply, fn; ascii = true)
    nothing
end

makemesh_Meshes(Meshes::Module, m::MC) = begin
    points = map(Meshes.Point3 ∘ Tuple, m.vertices)
    tris = Meshes.connect.(map(Tuple, m.triangles), Meshes.Triangle)
    Meshes.SimpleMesh(points, [tris;])
end

makemesh_GeometryBasics(GeometryBasics::Module, m::MC) = begin
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
