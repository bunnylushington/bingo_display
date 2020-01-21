use Mix.Config

config :bingo_display, :viewport, %{
  name: :main_viewport,
  # default_scene: {BingoDisplay.Scene.Crosshair, nil},
  default_scene: {BingoDisplay.Scene.Board, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :bingo_display"]
    }
  ]
}
