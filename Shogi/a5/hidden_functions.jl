#These are all copies of functions used in display.jl, but with print statements removed
#they are used in validate.jl so it only prints out movenumber where a cheat was detected, or 0 if no cheating is detected

function hidden_updateboard(game, moves)
  #moves is the DataFrame returned by query("SELECT * FROM moves")
  num = length(moves[:move_number])'
  #printBoard(game)
  team = "w"
  validity = true
  for move in 1:num
    team = move % 2 == 0 ? "w" : "b"
    if moves[:move_type][move].value == "move"
    	promote = !isnull(moves[:option][move])


      sx = moves[:sourcex][move].value
      sy = moves[:sourcey][move].value
      tx = moves[:targetx][move].value
      ty = moves[:targety][move].value


      if !isnull(moves[:targety2][move])
        ty2 = moves[:targety2][move].value
        tx2 = moves[:targetx2][move].value
      else
        ty2 = 0
        tx2 = 0
      end
      if promote && !valid_promote(game, sx, sy, tx2 == 0 ? tx : tx2, ty2 == 0 ? ty : ty2, team)
        validity = false
      end

      if validity == false
        println(move)
        break;
      end
    	validity = valid_move(game,
                sx,
                sy,
                tx,
                ty,
                team,
                tx2,
                ty2)
        #println("move #", move, " validity == ", validity)
        if validity == false
        	println(move)
        	break;
        end
        move_move(game,
                  sx,
                  sy,
                  tx,
                  ty,
                  promote,
                  team,
                  tx2,
                  ty2)
    elseif moves[:move_type][move].value == "drop"
      validity = valid_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          team,
          moves[:option][move].value)
      hidden_move_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          moves[:option][move].value,
          team
          )
        #println("move #", move, " validity == ", validity)
      if validity == false
        println(move)
        break;
      end
    elseif moves[:move_type][move].value == "resign"
      break;
    end
  end
  if validity == true
  	println("0")
  end
end

function hidden_move_move(game, sourcex, sourcey, targetx, targety, promote::Bool, player)
  validity = valid_move(game, sourcex, sourcey, targetx, targety, player)
  #print(sourcex, sourcey, targetx, targety, promote)
  s_piece = game.board[sourcey, sourcex]
  #println(s_piece)
  #println(validity)
  #check if theres a piece at the source
  if s_piece != "."
    t_piece = game.board[targety, targetx]
    #if theres a piece at the target, capture it
    if t_piece != "."
      a = lowercase(t_piece[2:2])

      if t_piece[1] == 'b'
        push!(game.cap_white, a)
      else
        push!(game.cap_black, a)
      end
    end

    if promote
      s_piece = string(s_piece[1], uppercase(s_piece[2]))
		end
    game.board[targety, targetx] = s_piece
    game.board[sourcey, sourcex] = "."
    return validity
  else
    #println("no piece at source $sourcex, $sourcey\n")
		return validity
  end
end

function hidden_valid_move(game, sourcex, sourcey, targetx, targety, player)
  #returns true if the move can be made without cheating
  #does not actually make the move

  #check if source and target are within the board
  if (sourcex > game.boardcols ||
    sourcex < 1 ||
    sourcey > game.boardrows ||
    sourcey < 1 ||
    targetx > game.boardcols ||
    targetx < 1 ||
    targety > game.boardrows ||
    targety < 1)
    return false
  end
  #check that the source and target are not the same
  if sourcex == targetx && sourcey == targety
    return false
  end

  #check if theres a piece at source
  s_piece = game.board[sourcey, sourcex]
  if s_piece == "."
    return false
  end
  #check if the piece being moved is owned by the player
  if s_piece[1:1] != player
    return false
  end

  #find whats at target
  t_piece = game.board[targety, targetx]
  #if the target is a piece make sure it's not a teamkill
  if t_piece[1:1] == player
    return false
  end
  #check if the piece can actually move there.
  p = s_piece[2:2]
  if p == "p"
    return pawn_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "k"
    return king_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "r"
    return rookmove(game, sourcex, sourcey, targetx, targety, player)
  elseif p == "b"
    return bishopmove(game, sourcex, sourcey, targetx, targety, player)
  elseif p == "g"
    return goldgeneral_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "s"
    return silvergeneral_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "n"
    return knight_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "l"
    return lancemove(game, sourcex, sourcey, targetx, targety, player)
  elseif p == "R"
    return rookp_move(sourcex, sourcey, targetx, targety, player)
  elseif p == "B"
    return bishopp_move(sourcex, sourcey, targetx, targety, player)
  else
    return goldgeneral_move(sourcex, sourcey, targetx, targety, player)
  end

  return true
end

function hidden_move_drop(game, targetx, targety, piece, team)
  #println("hidden_move_drop")
  #println(valid_drop(game, targetx, targety, team, piece))
  if game.board[targety, targetx] == "."
    pieceexists = false
    if team == "b"
      for cpiece in eachindex(game.cap_black)
        if game.cap_black[cpiece] == piece
          deleteat!(game.cap_black, cpiece)
          pieceexists = true
          break
        end
      end
    else
      for cpiece in eachindex(game.cap_white)
        if game.cap_white[cpiece] == piece
          deleteat!(game.cap_white, cpiece)
          pieceexists = true
          break
        end
      end
    end
    if pieceexists
      game.board[targety, targetx] = "$team$piece"
    else
      #println("piece not available to drop")

    end
  else
    #println("piece exists at target")
  end
end

function hidden_valid_drop(game, Tx, Ty, player, piece)
  if (Tx < 1) || (Tx > game.boardcols) || (Ty < 1) || (Ty > game.boardrows)
    return false
  end

  if game.board[Ty, Tx] != "." #must be an empty tile
    return false
  end

  pieceexists = false
    if player == "b"
      for cpiece in eachindex(game.cap_black)
        if game.cap_black[cpiece] == piece
          pieceexists = true
          break
        end
      end
    else
      for cpiece in eachindex(game.cap_white)
        if game.cap_white[cpiece] == piece
          pieceexists = true
          break
        end
      end
    end
  if pieceexists == false
    return false
  end

  if player == "b"
    if piece == "p"
      if (Ty == game.boardrows) #cant drop pawns on the end of the board.
        return false
      end

      for i in 1:game.boardrows #one pawn per team per column
        if game.board[i, Tx] == "bp"
          return false
        end
      end

      if game.board[Ty-1, Tx] == "wk" #can't drop pawn directly in front of king
        return false
      end

    elseif piece == "l"
      if (Ty == game.boardrows) #cant drop lancers on the end of the board.
        return false
      end

    elseif piece == "n"
      if (Ty < 3) #cant drop knights on the last 2 rows of the board
        return false
      end
    end

  else
    if piece == "p"
      if (Ty == 1) #cant drop pawns on the end of the board.
        return false
      end

      for i in 1:game.boardrows #one pawn per team per column
        if game.board[i, Tx] == "wp"
          return false
        end
      end

      if game.board[Ty+1, Tx] == "bk" #can't drop pawn directly in front of king
        return false
      end

    elseif piece == "l"
      if (Ty == game.boardrows) #cant drop lancers on the end of the board.
        return false
      end

    elseif piece == "n"
      if (Ty > game.boardrows - 2) #cant drop knights on the last 2 rows of the board
        return false
      end
    end
  end
  return true
end
