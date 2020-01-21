defmodule BingoDisplay.Scene.Board do
  use Scenic.Scene
  alias Scenic.Graph

  import BingoDisplay.Widgets

  @number_count 75
  
  @graph Graph.build(font_size: 48, font: :roboto_mono, id: :board)
  |> letter("B", {45, 40})
  |> letter("I", {45, 140})
  |> letter("N", {45, 240})
  |> letter("G", {45, 340})
  |> letter("O", {45, 440})

  def init(_, _) do
    graph = build_graph(@graph)
    {:ok, %{graph: graph, active: []}, push: graph}
  end

  def build_graph(graph) do
    build_graph(graph, 1)
  end

  def build_graph() do
    graph = build_graph(@graph)
    {graph, %{graph: graph, active: []}, push: graph}
  end

  def build_graph(graph, count) do
    case count > @number_count do
      true -> graph
      false ->
        build_graph(number(graph, count, coordinate(count), false), count + 1)
    end
  end

  def handle_cast({:flip, n}, %{graph: graph, active: active}) do
    {is_active, active_list} = case Enum.member?(active, n) do
                                 false -> {true, active ++ [n]}
                                 true  -> {false, List.delete(active, n)}
                               end
    new_graph = graph |>
      Graph.delete(n) |>
      number(n, coordinate(n), is_active)
    {:noreply, %{graph: new_graph, active: active_list}, push: new_graph}
  end

  def handlle_cast(:clear_board, _state) do
    {graph, state} = build_graph()
    {:noreply, state, push: graph}
  end
  
  def flip_number(n) do
    Scenic.Scene.cast(graph_ref(), {:flip, n})
  end

  def clear() do
    Scenic.Scene.cast(graph_ref(), :clear_board)
  end

  def graph_ref() do
    {:ok, info} = Scenic.ViewPort.info(:main_viewport)
    info.root_graph
  end
    

  
end

