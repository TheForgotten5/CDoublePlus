function random_move(game, player)
  other = player == "b" ? "w" : "b"
  if is_checkmate(game, player)
    #we resign
    return 0
  end
  #we have a winning move (somehow)
  #step 1: find the king
  kingx = 0
  kingy = 0
  for row in 1:game.boardrows
    for col in 1:game.boardcols
      if game.board[row, col] == "$(other)k"
        kingx = col
        kingy = row
        break
      end
    end
  end
  #println("king at $kingx , $kingy")
  #step 2: check if theres a valid move for the us to move into the kings square
  #we can stop if we find just one
  for row in 1:game.boardrows
    for col in 1:game.boardcols
      if valid_move(game, col, row, kingx, kingy, player)
        #print("winning move?")
        #println("A $(game.board[row, col]) at $col, $row can move into $kingx, $(kingy)!")
        move_move(game, col, row, kingx, kingy, false, player)
        return 1
      end
    end
  end



  #otherwise we pick a random move
  #seed the RNGeesuz




  s = ai(game, player)


  if s == "resign"
    return 0
  end

  if typeof(s.move) == move
    sx = s.move.sourcex
    sy = s.move.sourcey
    tx = s.move.location.column
    ty = s.move.location.row
    tx2 = s.move.location.column2
    ty2 = s.move.location.row2
    promote = s.move.promote

    move_move(game, sx, sy, tx,ty,  promote, player, tx2, ty2)
    return 1

  elseif typeof(s.move) == drop
    tx = s.move.targetx
    ty = s.move.targety
    p = s.move.piece
    #println(p)
    move_drop(game, tx, ty, p, player)
    return 1
  end


end
