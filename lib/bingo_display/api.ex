defmodule BingoDisplay.API do

  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line,
                             active: false, reuseaddr: true])

    loop_acceptor(socket)
  end


  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(BingoDisplay.APISupervisor,
      fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    cmd = String.trim(read_line(socket))
    input = try do
              String.to_integer(cmd)
            rescue
              ArgumentError ->
                cmd
            end
    msg = case is_integer(input) do
            true ->
              BingoDisplay.Scene.Board.flip_number(input)
              "Flipped #{ input }\n"
            false ->
              case input do
                "clear" -> 
                  BingoDisplay.Scene.Board.clear
                  "Cleared\n"
                _ ->
                  "Not a command (#{ input })\n"
              end
          end
    write_line(msg, socket)
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end

end
