use Mix.Config

config :bingo_display, :viewport, %{
  name: :main_viewport,
  default_scene: {BingoDisplay.Scene.Board, nil},
  size: {800, 480},
  opts: [scale: 1.8],
  drivers: [
    %{
      module: Scenic.Driver.Nerves.Rpi
    },
  ]
}
