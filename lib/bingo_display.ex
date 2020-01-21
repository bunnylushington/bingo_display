defmodule BingoDisplay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: SnTest.Supervisor]

    children = [
      {Task.Supervisor, name: BingoDisplay.APISupervisor},
#      {Task, fn -> BingoDisplay.API.accept(8800) end}
      Supervisor.child_spec({Task, fn -> BingoDisplay.API.accept(8800) end},
        restart: :permanent)
    ]

    Supervisor.start_link(children(@target) ++ children, opts)
  end

  
  # List all child processes to be supervised
  def children("host") do
    main_viewport_config = Application.get_env(:bingo_display, :viewport)

    [
      {Scenic, viewports: [main_viewport_config]}
    ]
  end

  def children(_target) do
    main_viewport_config = Application.get_env(:bingo_display, :viewport)

    [
      {Scenic, viewports: [main_viewport_config]}
    ]
  end
end
