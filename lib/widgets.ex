defmodule BingoDisplay.Widgets do
  import Scenic.Primitives

  @yaxes  {40, 140, 240, 340, 440}
  @xoffset  120   # transform of first numbered circle
  @xincrement  65 # distance between numbered circles
  
  def letter(graph, l, xform) do
    group(graph,
      fn g -> g 
      |> circle(30, fill: {:color, :black}, stroke: {2, :white})
      |> text(l, text_align: :center, translate: {0, 13})
      end,
      t: xform
    )
  end

  def number(graph, n, {x,y}, inverted?) do
    fg = case inverted? do
           true -> :white
           false -> {30,30,30,100}
         end
    graph |> text(to_string(n), fill: fg, text_align: :center, font: :roboto,
      translate: {x, y+14}, id: n, r: 0)
  end

  def wrong(graph) do
    {x,y} = BingoDisplay.Scene.Feud.center()
    group(graph,
      fn g -> g
      |> rrect({200,250,10}, stroke: {4, :red})
      |> text("X", text_align: :center, fill: :red,
        font_size: 256, translate: {100, 200})
      end,
      t: {x-100, y-125},
      id: :wrong_x
    )
  end

  def coordinate(number) do
    y = elem(@yaxes, div(number - 1, 15))
    position = case rem(number, 15) do
                 0 -> 15
                 r -> r
               end
    x = @xoffset + ((position - 1) * @xincrement)
    {x, y}
  end

end
