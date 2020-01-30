defmodule BingoDisplay.Scene.Feud do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives

  import BingoDisplay.Widgets

  @graph Graph.build(font_size: 48, font: :roboto_mono, id: :ff)
  |> text("This is Family Feud")


  def init(_, _) do
    graph = @graph
    {:ok, %{graph: graph, question: 1, errors: 0}, push: graph}
  end


end
