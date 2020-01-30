defmodule BingoDisplay.Scene.Feud do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives

  import BingoDisplay.Widgets


  @questions [ {"What does the Groundhog like to eat?",
                ["(3 Points) Champagne and Cheese",
                 "(2 Points) Drugs",
                 "(1 Point) Plants of Any Kind"]},
               {"Why does the Groundhog scream?",
                ["(3 Points) The World Is Terrifying and Meaningless",
                 "(2 Points) Shadows",
                 "(1 Point) RPredators"]},
               {"How do you get a Groundhog out of their hole?",
                ["(3 Points) A Good Party",
                 "(2 Points) A Weather Report",
                 "(1 Point) Repellents and Traps"]} ]
                 
  @yoffset 200
  @ystep 100
  
  def init(_, _) do
    graph = Graph.build(font_size: 72, font: :roboto, id: :ff)
    |> text("Psychedelic Friendship Trivia!",
    text_align: :center, translate: center())
    {:ok, %{graph: graph}, push: graph}
  end

  def handle_cast({:question, question}, _state) do
    graph = Graph.build(font_size: 36, font: :roboto)
    |> text(question, text_align: :left, translate: {100,100})
    {:noreply, %{graph: graph}, push: graph}
  end

  def handle_cast({:answer, n, answer}, %{graph: graph}) do
    y = @yoffset + (n * @ystep)
    new_graph = graph |> text(answer, text_aligh: :left, translate: {150,y})
    {:noreply, %{graph: new_graph}, push: new_graph}
  end

  def handle_cast({:answer, answer}, %{graph: graph}) do
    y = @yoffset
    a = <<"(4 Points) ">> <> answer
    new_graph = graph |> text(a, text_align: :left, translate: {150,y})
    {:noreply, %{graph: new_graph}, push: new_graph}
  end
  
  def handle_cast(:wrong, %{graph: graph}) do
    new_graph = wrong(graph)
    {:noreply, %{graph: new_graph}, push: new_graph}
  end

  def handle_cast(:nox, %{graph: graph}) do
    new_graph = graph |> Graph.delete(:wrong_x)
    {:noreply, %{graph: new_graph}, push: new_graph}
  end
                                          
  
  # -- API
  def show_question(n) do
    {question, answers} = Enum.at(@questions, n-1)
    case question do
      nil -> "Question out of bounds"
      _ ->
        Scenic.Scene.cast(graph_ref(), {:question, question})
        """
Showing question #{n}
\t#{ Enum.join(answers, "\n\t") }

"""
        
    end
  end

  def show_answer(i, j) do
    {_, answers} = Enum.at(@questions, i-1)
    case answers do
      nil -> "Answer out of bound"
      _ ->
        Scenic.Scene.cast(graph_ref(), {:answer, j, Enum.at(answers, j-1)})
        "Showing answer #{j} to question #{i}"
    end
  end

  def show_adhoc_answer(answer) do
    Scenic.Scene.cast(graph_ref(), {:answer, answer})
  end
  
  def wrong() do
    Scenic.Scene.cast(graph_ref(), :wrong)
  end

  def nox() do
    Scenic.Scene.cast(graph_ref(), :nox)
  end

  def center() do
    {{x, y}, {x_scale, y_scale}} = port_size()
    {x/2/(x_scale - 1), y/2/(y_scale - 1)}
  end

  
  # -- private functions
  defp graph_ref() do
    {:ok, info} = Scenic.ViewPort.info(:main_viewport)
    info.root_graph
  end

  defp port_size() do
    {:ok, info} = Scenic.ViewPort.info(:main_viewport)
    scale = info.transforms[:scale]
    {info.size, scale}
  end

  
end
