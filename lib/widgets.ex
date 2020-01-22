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

  def number(graph, n, xform, inverted?) do
    {stroke, fg, bg} = case inverted? do
                         true  -> {:red, :black, :white}
                         false -> {:blue, :white, :black}
                       end
    group(graph,
      fn g -> g
      |> circle(30, fill: {:color, bg}, stroke: {2, stroke})
      |> text(to_string(n), fill: fg, text_align: :center, translate: {0, 14})
      end,
      t: xform, id: n
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
