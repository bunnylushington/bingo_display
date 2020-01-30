defmodule BingoDisplay.Scene.BoardCache do
  use Agent
  alias BingoDisplay.Scene.Board
  
  def start() do
    case Process.whereis(__MODULE__) do
      nil ->
        data = Board.build_graph
        Agent.start(fn -> data end, name: __MODULE__)
        data
      _ ->
        get()
    end
  end

  def restart() do
    stop()
    start()
  end
  
  def get() do
    case Process.whereis(__MODULE__) do
      nil -> nil
      _   -> Agent.get(__MODULE__, & &1)
    end
  end

  def stop() do
    case Process.whereis(__MODULE__) do
      nil -> nil
      _   -> Agent.stop(__MODULE__)
    end
  end

  def set(graph, state) do
    Agent.update(__MODULE__, fn(_) -> {graph, state} end)
    {graph, state}
  end

end

