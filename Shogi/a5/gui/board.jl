
function display_board(game)
  display_board(game, "b")
end
function display_board(game, player)
  w = Toplevel("Shogi")
  f = Frame(w, padding = [3, 3, 2, 2], relief = "groove")
  pack(f, expand = true, fill = "both")
  tcl("ttk::style", "configure", "TButton", foreground="red", background = "plum2",font="helvetica 15")
  labels = Array(Tk.Tk_Label, game.boardcols, game.boardrows)
  pieces = fetchpieces(game.gametype)
  for r in 1:game.boardrows
    for c in 1:game.boardcols
      if game.board[c, r] == "."
        kanji = "."
      else
        kanji = fetchvalue(pieces, game.board[c, r][2:2], 3)
      end
      b = Button(f, kanji)
      grid(b, 2 * c,r)
      a = Label(f,"")
      labels[c, r] = a
      grid(a, 2 * c + 1,r)
      bind(b, "command", path -> click(r, c))
    end
  end
  e = Entry(f, "")
  string = ""
  grid(e, 3 * game.boardcols + 1, 1)
  l = Label(f, "state")
  grid(l, 3 * game.boardcols + 1, 2)
  sx = 0
  sy = 0
  tx = 0
  ty = 0
  tx2 = 0
  ty2 = 0
  tx3 = 0
  ty3 = 0
  state = 1
  g = Button(f, "go")
  #bind(g, "command", go)
  grid(g, 3 * game.boardcols + 1, 3)

  function go(path)
    if state != 1
      move_move(game, sx, sy, tx, ty, false, player, tx2, ty2, tx3, ty3)
      destroy(w)
      s = ai(game, player == "b" ? "w" : "b")
      move(game, player == "b" ? "w" : "b", s.move)
      display_board(game, player)

    end
  end
  bind(g, "command", go)
  function click(r::Int, c::Int)
    if state == 1
      if game.board[c, r][1:1] == "."
        return
      end
      sx = r
      sy = c
      state = 2
      for j in 1:game.boardrows
        for i in 1:game.boardcols
          println("$i, $j")
          if valid_move(game, sx, sy, j, i, player)
            set_value(labels[i, j], "valid^")
          else
            set_value(labels[i, j], "")
          end
        end
      end

    elseif state == 2
      tx = r
      ty = c
      if valid_move(game, sx, sy, tx, ty, player)
        state = 3
      else
        state = 1
        sx = r
        sy = c
        tx = 0
        ty = 0
        click(r, c)
      end
    elseif state == 3
      tx2 = r
      ty2 = c
      if valid_move(game, sx, sy, tx, ty, player, tx2, ty2)
        state = 4
      else
        state = 1
        sx = r
        sy = c
        tx = 0
        ty = 0
        tx2 = 0
        ty2 = 0
        click(r, c)
      end
    elseif state == 4
      tx3 = r
      ty3 = c
      if valid_move(game, sx, sy, tx, ty, player, tx2, ty2, tx3, ty3)
        state = 5
      else
        state = 1
        sx = r
        sy = c
        tx = 0
        ty = 0
        tx2 = 0
        ty2 = 0
        tx3 = 0
        ty3 = 0
        click(r, c)
      end
    end
    println("state = $state")
    println("s = $sx, $sy")
    println("t1 = $tx, $ty")
    println("t2 = $tx2, $ty2")
    println("t3 = $tx3, $ty3")
    set_value(l, "$state")

  end

end
