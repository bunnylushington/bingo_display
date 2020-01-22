## to burn to card

``` shell
mix firmware.burn
```

## to use

``` shell
telnet nerves.local 8800
```

and then numbers 1 - 75 to flip the number and clear to clear the board.

## a note

I spent too much time wondering how to use `Scenic.Scene.cast` --
specifically, I had no idea (and couldn't find in the documentation)
what the `scene_or_graph_key` might be.  It turns out that this

``` elixir
  def graph_ref() do
    {:ok, info} = Scenic.ViewPort.info(:main_viewport)
    info.root_graph
  end
```

is what I was looking for.
