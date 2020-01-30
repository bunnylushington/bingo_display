defmodule BingoDisplay.Scene.Board do
  use Scenic.Scene
  alias Scenic.Graph
  alias BingoDisplay.Scene.BoardCache, as: Cache

  import BingoDisplay.Widgets

  @number_count 75
  
  @graph Graph.build(font_size: 48, font: :roboto, id: :board)
  |> letter("B", {45, 40})
  |> letter("I", {45, 140})
  |> letter("N", {45, 240})
  |> letter("G", {45, 340})
  |> letter("O", {45, 440})


  def init(_, _) do
    {graph, state} = Cache.start()
    {:ok, state, push: graph}
  end


  def handle_cast({:flip, n}, _) do
    {graph, %{active: active}=state} = Cache.get
    {is_active, active_list} = case Enum.member?(active, n) do
                                 false -> {true, active ++ [n]}
                                 true  -> {false, List.delete(active, n)}
                               end
    new_graph = number(graph, n, coordinate(n), is_active)
    {_, new_state} = Cache.set(new_graph, %{state | active: active_list})
    {:noreply, new_state, push: new_graph}
  end

  def handle_cast(:clear_board, _state) do
    {graph, state} = Cache.restart
    {:noreply, state, push: graph}
  end


  # -- API
  def flip_number(42) do
    :ok
  end
  
  def flip_number(n) do
    Scenic.Scene.cast(graph_ref(), {:flip, n})
  end

  def clear() do
    Scenic.Scene.cast(graph_ref(), :clear_board)
  end

  def build_graph() do
    graph = build_graph(@graph)
    {graph, %{active: []}}
  end

  # -- private functions
  defp graph_ref() do
    {:ok, info} = Scenic.ViewPort.info(:main_viewport)
    info.root_graph
  end
  
  defp build_graph(graph) do
    build_graph(graph, 1)
  end

  defp build_graph(graph, count) when count == 42 do
    build_graph(graph, count + 1)
  end
  
  defp build_graph(graph, count) do
    case count > @number_count do
      true -> graph
      false ->
        build_graph(number(graph, count, coordinate(count), false), count + 1)
    end
  end

  

  
end

