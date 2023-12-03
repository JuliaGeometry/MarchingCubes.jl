using MarchingCubes

main() = begin
  run(`gcc main.c`)

  println("== 2d ==")
  for (l, sym) ∈ enumerate((
    :cases,
    :tiling1,
    :tiling2,
    :tiling3_1,
    :tiling3_2,
    :tiling4_1,
    :tiling4_2,
    :tiling5,
    :test6,
    :tiling6_1_1,
    :tiling6_1_2,
    :tiling6_2,
    :test7,
    :tiling7_1,
    :tiling7_4_1,
    :tiling7_4_2,
    :tiling8,
    :tiling9,
    :test10,
    :tiling10_1_1,
    :tiling10_1_1_,
    :tiling10_1_2,
    :tiling10_2,
    :tiling10_2_,
    :tiling11,
    :test12,
    :tiling12_1_1,
    :tiling12_1_1_,
    :tiling12_1_2,
    :tiling12_2,
    :tiling12_2_,
    :test13,
    :tiling13_1,
    :tiling13_1_,
    :tiling14,
    :casesClassic,
  ))
    @show sym, l
    lut = getfield(MarchingCubes, sym)
    o = sym ∈ (:test6, :test7, :test10, :test12, :test13) ? 0 : 1
    for i ∈ 1:length(lut)
      for j ∈ 1:length(first(lut))
        io = PipeBuffer()
        pipeline(`./a.out $l $(i - 1) $(j - 1)`; stdout=io, stderr=devnull) |> run
        val = parse(Int, read(io, String) |> rstrip) + o
        @assert val == lut[i][j] ((i, j), val, lut[i][j])
      end
    end
  end

  println("== 1d ==")
  for (l, sym) ∈ enumerate((
    :test3,
    :test4,
    :subcfg13
  ))
    @show sym, l
    lut = getfield(MarchingCubes, sym)
    for i ∈ 1:length(lut)
      io = PipeBuffer()
      pipeline(`./a.out $(100 + l) $(i - 1)`; stdout=io, stderr=devnull) |> run
      val = parse(Int, read(io, String) |> rstrip)
      @assert val == lut[i] (i, val, lut[i])
    end
  end

  println("== 3d ==")
  for (l, sym) ∈ enumerate((
    :tiling7_2,
    :tiling7_3,
    :tiling13_2,
    :tiling13_2_,
    :tiling13_3,
    :tiling13_3_,
    :tiling13_4,
    :tiling13_5_1,
    :tiling13_5_2,
  ))
    @show sym, l
    lut = getfield(MarchingCubes, sym)
    for i ∈ 1:length(lut)
      for j ∈ 1:length(first(lut))
        for k ∈ 1:length(first(first(lut)))
          io = PipeBuffer()
          pipeline(`./a.out $(200 + l) $(i - 1) $(j - 1) $(k - 1)`; stdout=io, stderr=devnull) |> run
          val = parse(Int, read(io, String) |> rstrip) + 1
          @assert val == lut[i][j][k] ((i, j, k), val, lut[i][j][k])
        end
      end
    end
  end

  return
end

main()
