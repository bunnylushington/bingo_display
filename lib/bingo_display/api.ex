defmodule BingoDisplay.API do

  require Logger


  @help """
     [1 - 75] - flip bingo board number
        clear - clear the bingo board
         feud - play family feud
        bingo - play bingo
         q[i] - display feud question i
      a[i][j] - display feud answer j for question i
answer <text> - use <text as feud answer
            x - show feud [X]
          nox - remove feud [X]
         help - this message
"""
  

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
              "Flipped #{ input }."
            false ->
              case input do
                "help" ->
                  @help

                "clear" -> 
                  BingoDisplay.Scene.Board.clear
                  "Board cleared."
                  
                "feud" ->
                  Scenic.ViewPort.set_root(:main_viewport,
                    {BingoDisplay.Scene.Feud, nil})
                  "Playing Family Feud."

                "bingo" ->
                  Scenic.ViewPort.set_root(:main_viewport,
                    {BingoDisplay.Scene.Board, nil})
                  "Playing Bingo."

                <<"q", q::binary-size(1)>> ->
                  BingoDisplay.Scene.Feud.show_question(String.to_integer(q))

                <<"a", q::binary-size(1), a::binary-size(1)>> ->
                  BingoDisplay.Scene.Feud.show_answer(String.to_integer(q),
                    String.to_integer(a))

                <<"answer ", a::binary>> ->
                  BingoDisplay.Scene.Feud.show_adhoc_answer(a)

                "x" ->
                  BingoDisplay.Scene.Feud.wrong()
                  "Wrong answer."

                "nox" ->
                  BingoDisplay.Scene.Feud.nox()
                  "Removed error indicator."

                _ ->
                  "Not a command (#{ input })."
              end
          end
    write_line(msg <> "\n", socket)
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

