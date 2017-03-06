type shogi
  gametype::String
  #n * m 2d array for the board
  board
  boardcols::Int
  boardrows::Int
  cap_white  #pieces that white can drop
  cap_black   #pieces that black can drop
end

include("move_functions.jl")
include("piece.jl")
include("move_generator.jl")

function copygame(game::shogi)
  #returns a copy of the game
  newgame = makeGame(game.gametype, game.boardcols, game.boardrows)
  for row in 1:newgame.boardrows
    for col in 1:newgame.boardcols
      newgame.board[row, col] = game.board[row, col]
    end
  end
  for piece in game.cap_white
    push!(newgame.cap_white, piece)
  end
  for piece in game.cap_black
    push!(newgame.cap_black, piece)
  end
  return newgame
end

function makeGame(gametype::String, boardcols, boardrows)
  board = Array{String}(boardcols, boardrows)
    fill!(board, ".")
  if gametype == "tenjikushogi"
    fill!(board, "...")
  end
  return shogi(gametype, board, boardcols,boardrows, Array{String}(0), Array{String}(0))
end

#Description: Prints the board.
function printBoard(game::shogi)
    println("        White")
    #print the board
    print( "  ")
    for col in game.boardcols:-1:1
      print(col, " ")
    end
    print("x\n")
		for row in 1:game.boardrows
      print(row, " ")
			for col in game.boardcols:-1:1
        team = game.board[row,col][1] == 'b' ? "*" : "^"
        team = game.board[row,col][1] == '.' ? " " : team
        if team != " " && game.board[row, col][2] == 'k'
          print_with_color(:yellow, "k$team")
        else
				  print(game.board[row,col] == "." ? "." : game.board[row,col][2], team)
        end
			end
			print("\n")
		end
    println("y       Black")
    print("\n")
    #print capped pieces
    print("White captured pieces: ")
    for piece in game.cap_white
      print(piece, " ")
    end
    print("\n")
    print("Black captured pieces: ")
    for piece in game.cap_black
      print(piece, " ")
    end
    print("\n")
end

#Description: Initializes all pieces of the board
#The setup is:
#	 P	 P	 P	 P	 P	 P	 P	 P	 P
#			 B									 R
#  L 	 N 	 S 	 G 	 K 	 G 	 S 	 N 	 L
function startGame(gamemode::String)
  if gamemode == "standard"
  	return startStandard()
  elseif gamemode == "minishogi"
  	return startMini()
  elseif gamemode == "chushogi"
    return startChu()
  elseif gamemode == "ten"
    return startTen()
  else
    println("invalid gametype $gametype")
    exit(1)
  end
end

function startStandard()
	#Initialize pawns
  game = makeGame("standard", 9, 9)
	for index in 1:9
		#gote
		game.board[7, index] = "bp"
		#sente
		game.board[3, index] = "wp"
	end
	#Bishops and rook
	#sente
	game.board[2, 2] = "wb"
	game.board[2, 8] = "wr"
	#gote
	game.board[8, 8] = "bb"
	game.board[8, 2] = "br"

	#The back row.
	game.board[1, 1] = "wl"
	game.board[1, 9] = "wl"
	game.board[9, 1] = "bl"
	game.board[9, 9] = "bl"
	game.board[1, 2] = "wn"
	game.board[1, 8] = "wn"
	game.board[9, 2] = "bn"
	game.board[9, 8] = "bn"
	game.board[1, 3] = "ws"
	game.board[1, 7] = "ws"
	game.board[9, 3] = "bs"
	game.board[9, 7] = "bs"
	game.board[1, 4] = "wg"
	game.board[1, 6] = "wg"
	game.board[9, 4] = "bg"
	game.board[9, 6] = "bg"
	game.board[1, 5] = "wk"
	game.board[9, 5] = "bk"
  return game
end

#Setup for minishogi is:
# K G S B R
#					P
function startMini()
	#The back row.
  game = makeGame("minishogi", 5,5)
			game.board[1, 1] = "wk"
			game.board[5, 5] = "bk"
			game.board[1, 2] = "wg"
			game.board[5, 4] = "bg"
			game.board[1, 3] = "ws"
			game.board[5, 3] = "bs"
			game.board[1, 4] = "wb"
			game.board[5, 2] = "bb"
			game.board[1, 5] = "wr"
			game.board[5, 1] = "br"
			game.board[4, 5] = "bp"
			game.board[2, 1] = "wp"
      return game
end

function startChu()
  game = makeGame("chushogi", 12, 12)
    game.board[1, 12] = "wl"
    game.board[1, 11] = "wf"
    game.board[1, 10] = "wc"
    game.board[1, 9] = "ws"
    game.board[1, 8] = "wg"
    game.board[1, 7] = "we"
    game.board[1, 6] = "wk"
    game.board[1, 5] = "wg"
    game.board[1, 4] = "ws"
    game.board[1, 3] = "wc"
    game.board[1, 2] = "wf"
    game.board[1, 1] = "wl"
    game.board[2, 12] = "wa"
    game.board[2, 10] = "wb"
    game.board[2, 8] = "wt"
    game.board[2, 7] = "wx"
    game.board[2, 6] = "wn"
    game.board[2, 5] = "wt"
    game.board[2, 3] = "wb"
    game.board[2, 1] = "wa"
    game.board[3, 12] = "wm"
    game.board[3, 11] = "wv"
    game.board[3, 10] = "wr"
    game.board[3, 9] = "wh"
    game.board[3, 8] = "wd"
    game.board[3, 7] = "wq"
    game.board[3, 6] = "wi"
    game.board[3, 5] = "wd"
    game.board[3, 4] = "wh"
    game.board[3, 3] = "wr"
    game.board[3, 2] = "wv"
    game.board[3, 1] = "wm"
    for i in 1:12
      game.board[4, i] = "wp"
    end
    game.board[5, 9] = "wo"
    game.board[5, 4] = "wo"

    game.board[12, 1] = "bl"
    game.board[12, 2] = "bf"
    game.board[12, 3] = "bc"
    game.board[12, 4] = "bs"
    game.board[12, 5] = "bg"
    game.board[12, 6] = "be"
    game.board[12, 7] = "bk"
    game.board[12, 8] = "bg"
    game.board[12, 9] = "bs"
    game.board[12, 10] = "bc"
    game.board[12, 11] = "bf"
    game.board[12, 12] = "bl"
    game.board[11, 1] = "ba"
    game.board[11, 3] = "bb"
    game.board[11, 5] = "bt"
    game.board[11, 6] = "bx"
    game.board[11, 7] = "bn"
    game.board[11, 8] = "bt"
    game.board[11, 10] = "bb"
    game.board[11, 12] = "ba"
    game.board[10, 1] = "bm"
    game.board[10, 2] = "bv"
    game.board[10, 3] = "br"
    game.board[10, 4] = "bh"
    game.board[10, 5] = "bd"
    game.board[10, 6] = "bq"
    game.board[10, 7] = "bi"
    game.board[10, 8] = "bd"
    game.board[10, 9] = "bh"
    game.board[10, 10] = "br"
    game.board[10, 11] = "bv"
    game.board[10, 12] = "bm"
    for i in 1:12
      game.board[9, i] = "bp"
    end
    game.board[8, 9] = "bo"
    game.board[8, 4] = "bo"
    return game
end

function startTen()
  game = makeGame("tenjikushogi", 16, 16)
    game.board[1,16] = "wl."
    game.board[1,15] = "wn."
    game.board[1,14] = "wfl"
    game.board[1,13] = "wi."
    game.board[1,12] = "wc."
    game.board[1,11] = "ws."
    game.board[1,10] = "wg."
    game.board[1,9] = "wde"
    game.board[1,8] = "wk."
    game.board[1,7] = "wg."
    game.board[1,6] = "ws."
    game.board[1,5] = "wc."
    game.board[1,4] = "wi."
    game.board[1,3] = "wfl"
    game.board[1,2] = "wn."
    game.board[1,1] = "wl."
    game.board[2,16] = "wrc"
    game.board[2,14] = "wcs"
    game.board[2,13] = "wcs"
    game.board[2,11] = "wbt"
    game.board[2,10] = "wph"
    game.board[2,9] = "wq."
    game.board[2,8] = "wln"
    game.board[2,7] = "wkr"
    game.board[2,6] = "wbt"
    game.board[2,4] = "wcs"
    game.board[2,3] = "wcs"
    game.board[2,1] = "wrc"
    game.board[3,16] = "wss"
    game.board[3,15] = "wvs"
    game.board[3,14] = "wb."
    game.board[3,13] = "wdh"
    game.board[3,12] = "wdk"
    game.board[3,11] = "wwb"
    game.board[3,10] = "wfd"
    game.board[3,9] = "wfe"
    game.board[3,8] = "wlh"
    game.board[3,7] = "wfd"
    game.board[3,6] = "wwb"
    game.board[3,5] = "wdk"
    game.board[3,4] = "wdh"
    game.board[3,3] = "wb."
    game.board[3,2] = "wvs"
    game.board[3,1] = "wss"
    game.board[4,16] = "wsm"
    game.board[4,15] = "wvm"
    game.board[4,14] = "wr."
    game.board[4,13] = "whf"
    game.board[4,12] = "wse"
    game.board[4,11] = "wbg"
    game.board[4,10] = "wrg"
    game.board[4,9] = "wvg"
    game.board[4,8] = "wgg"
    game.board[4,7] = "wrg"
    game.board[4,6] = "wbg"
    game.board[4,5] = "wse"
    game.board[4,4] = "whf"
    game.board[4,3] = "wr."
    game.board[4,2] = "wvm"
    game.board[4,1] = "wsm"
    for i in 1:16
      game.board[5, i] = "wp."
    end
    game.board[6,12] = "wd."
    game.board[6,5] = "wd."

    game.board[16,16] = "bl."
    game.board[16,15] = "bn."
    game.board[16,14] = "bfl"
    game.board[16,13] = "bi."
    game.board[16,12] = "bc."
    game.board[16,11] = "bs."
    game.board[16,10] = "bg."
    game.board[16,9] = "bk."
    game.board[16,8] = "bde"
    game.board[16,7] = "bg."
    game.board[16,6] = "bs."
    game.board[16,5] = "bc."
    game.board[16,4] = "bi."
    game.board[16,3] = "bfl"
    game.board[16,2] = "bn."
    game.board[16,1] = "bl."
    game.board[15,16] = "brc"
    game.board[15,14] = "bcs"
    game.board[15,13] = "bcs"
    game.board[15,11] = "bbt"
    game.board[15,10] = "bkr"
    game.board[15,9] = "bln"
    game.board[15,8] = "bq."
    game.board[15,7] = "bph"
    game.board[15,6] = "bbt"
    game.board[15,4] = "bcs"
    game.board[15,3] = "bcs"
    game.board[15,1] = "brc"
    game.board[14,16] = "bss"
    game.board[14,15] = "bvs"
    game.board[14,14] = "bb."
    game.board[14,13] = "bdh"
    game.board[14,12] = "bdk"
    game.board[14,11] = "bwb"
    game.board[14,10] = "bfd"
    game.board[14,9] = "blh"
    game.board[14,8] = "bfe"
    game.board[14,7] = "bfd"
    game.board[14,6] = "bwb"
    game.board[14,5] = "bdk"
    game.board[14,4] = "bdh"
    game.board[14,3] = "bb."
    game.board[14,2] = "bvs"
    game.board[14,1] = "bss"
    game.board[13,16] = "bsm"
    game.board[13,15] = "bvm"
    game.board[13,14] = "br."
    game.board[13,13] = "bhf"
    game.board[13,12] = "bse"
    game.board[13,11] = "bbg"
    game.board[13,10] = "brg"
    game.board[13,9] = "bgg"
    game.board[13,8] = "bvg"
    game.board[13,7] = "brg"
    game.board[13,6] = "bbg"
    game.board[13,5] = "bse"
    game.board[13,4] = "bhf"
    game.board[13,3] = "br."
    game.board[13,2] = "bvm"
    game.board[13,1] = "bsm"
    for i in 1:16
      game.board[12,i] = "bp."
    end
    game.board[11, 12] = "bd."
    game.board[11, 5] = "bd."
  return game
end



function move_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, promote::Bool, player::String)
  return move_move(game, sourcex, sourcey, targetx, targety, promote, player, 0, 0, 0, 0)
end

function move_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, promote::Bool, player::String, targetx2::Int, targety2::Int)
  return move_move(game, sourcex, sourcey, targetx, targety, promote, player, targetx2, targety2, 0, 0)
end

function move_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, promote::Bool, player::String, targetx2::Int, targety2::Int, targetx3::Int, targety3::Int)

  #print(valid_move(game, sourcex, sourcey, targetx, targety, player) ? "" : "Invalid move detected, $sourcex $sourcey to $targetx $targety by $(player == "w" ? "white" : "black").\n")
  #print(sourcex, sourcey, targetx, targety, promote)
  s_piece = game.board[sourcey, sourcex]
  #println(s_piece)
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
    if targetx2 != 0
      t_piece = game.board[targety2, targetx2]
      if t_piece != "."
        a = lowercase(t_piece[2:2])

        if t_piece[1] == 'b'
          push!(game.cap_white, a)
        else
          push!(game.cap_black, a)
        end
      end
    end
    if promote
      s_piece = string(s_piece[1], uppercase(s_piece[2]))
		end
    if targetx2 == 0
      game.board[targety, targetx] = s_piece
      game.board[sourcey, sourcex] = "."
    else
      game.board[sourcey, sourcex] = "."
      game.board[targety, targetx] = "."
      game.board[targety2, targetx2] = s_piece
    end
    return true
  else
    #println("no piece at source $sourcex, $sourcey\n")
		return false
  end
end


function move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, promote::Bool, player::String, targetx2::Int, targety2::Int)
  #does not add captured pieces
  #print(valid_move(game, sourcex, sourcey, targetx, targety, player) ? "" : "Invalid move detected, $sourcex $sourcey to $targetx $targety by $(player == "w" ? "white" : "black").\n")
  #print(sourcex, sourcey, targetx, targety, promote)
  s_piece = game.board[sourcey, sourcex]
  #println(s_piece)
  #check if theres a piece at the source
  if s_piece != "."
    t_piece = game.board[targety, targetx]
    #if theres a piece at the target, capture it

    if promote
      s_piece = string(s_piece[1], uppercase(s_piece[2]))
		end

    if targetx2 == 0
      game.board[targety, targetx] = s_piece
      game.board[sourcey, sourcex] = "."
    else
      game.board[sourcey, sourcex] = "."
      game.board[targety, targetx] = "."
      game.board[targety2, targetx2] = s_piece
    end
    return true
  else
    #println("no piece at source $sourcex, $sourcey\n")
		return false
  end
end

function updateboard(game::shogi, moves::DataFrames.DataFrame)
  #moves is the DataFrame returned by query("SELECT * FROM moves")
  num = length(moves[:move_number])
  printBoard(game)
  team = "w"
  for move in 1:num
    team = move % 2 == 0 ? "w" : "b"
    println("--------------------")
    println("Move: $move")
    if moves[:move_type][move].value == "move"
    	promote = !isnull(moves[:option][move]) && moves[:option][move].value == "!"
      targetx2 = !isnull(moves[:targetx2][move])
      #println(targetx2)
      if targetx2 == false
    	 move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                0,
                0
                )
      elseif targetx2 == true
        move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                moves[:targetx2][move].value,
                moves[:targety2][move].value
                )
      end
      println(team == "w" ? "White" : "Black", " moves a piece.")
    elseif moves[:move_type][move].value == "drop"
      move_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          moves[:option][move].value,
          team
          )
          println(team == "w" ? "White" : "Black", " drops a piece.")
    elseif moves[:move_type][move].value == "resign"
      println(team == "w" ? "White" : "Black", " has resigned.")
      break;
    end
    print("\n")
    printBoard(game)
    println(is_check(game, team == "w" ? "b" : "w") ? "Check!" : "")
    println(is_checkmate(game, team == "w" ? "b" : "w") ? "Checkmate!" : "")

  end
  println("--------------------")
  println(team == "b" ? "White" : "Black", "s turn")

end

function update(game::shogi, moves::DataFrames.DataFrame)
  #same as updateboard() but does not print anything.
  #moves is the DataFrame returned by query("SELECT * FROM moves")
  num = length(moves[:move_number])
  #printBoard(game)
  team = "w"
  for move in 1:num
    team = move % 2 == 0 ? "w" : "b"
    #println("--------------------")
    if moves[:move_type][move].value == "move"
    	promote = !isnull(moves[:option][move])
    	targetx2 = !isnull(moves[:targetx2][move])
      #println(targetx2)
      if targetx2 == false
       move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                0,
                0
                )
      elseif targetx2 == true
        move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                moves[:targetx2][move].value,
                moves[:targety2][move].value
                )
      end
      #println(team == "w" ? "White" : "Black", " moves a piece.")
    elseif moves[:move_type][move].value == "drop"
      move_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          moves[:option][move].value,
          team
          )
          #println(team == "w" ? "White" : "Black", " drops a piece.")
    elseif moves[:move_type][move].value == "resign"
      #println(team == "w" ? "White" : "Black", " has resigned.")
      break;
    end
    #print("\n")
    #printBoard(game)
    #println(is_check(game, team == "w" ? "b" : "w") ? "Check!" : "")

  end


  #println("--------------------")
  #println(team == "b" ? "White" : "Black", "s turn")

end

function gamearray(game::shogi, moves::DataFrames.DataFrame)
  #same as update() but returns an array with a game for each move made
  #moves is the DataFrame returned by query("SELECT *   FROM moves")
  a = Array{shogi}(0)
  num = length(moves[:move_number])
  #printBoard(game)
  team = "w"
  for move in 1:num
    team = move % 2 == 0 ? "w" : "b"
    #println("--------------------")
    if moves[:move_type][move].value == "move"
    	promote = !isnull(moves[:option][move])
    	targetx2 = !isnull(moves[:targetx2][move])
      #println(targetx2)
      if targetx2 == false
       move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                0,
                0
                )
      elseif targetx2 == true
        move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                moves[:targetx2][move].value,
                moves[:targety2][move].value
                )
      end
      #println(team == "w" ? "White" : "Black", " moves a piece.")
    elseif moves[:move_type][move].value == "drop"
      move_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          moves[:option][move].value,
          team
          )
          #println(team == "w" ? "White" : "Black", " drops a piece.")
    elseif moves[:move_type][move].value == "resign"
      #println(team == "w" ? "White" : "Black", " has resigned.")
      clone = copygame(game)
      push!(a, clone)
      break;
    end
    clone = copygame(game)
    push!(a, clone)
    #print("\n")
    #printBoard(game)
    #println(is_check(game, team == "w" ? "b" : "w") ? "Check!" : "")

  end
  return a
end
function findwinner(game::shogi, moves::DataFrames.DataFrame)
  #same as update() but start with a blank board and find the winner
  #return a string as defined for win.jl in the pdf
  #moves is the DataFrame returned by query("SELECT * FROM moves")
  num = length(moves[:move_number])
  #printBoard(game)
  team = "w"
  for move in 1:num
    team = move % 2 == 0 ? "w" : "b"
    other = move % 2 == 1 ? "w" : "b"
    #println("--------------------")
    if moves[:move_type][move].value == "move"
    	promote = !isnull(moves[:option][move])
    	targetx2 = !isnull(moves[:targetx2][move])
      #println(targetx2)
      if targetx2 == false
       move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                0,
                0
                )
      elseif targetx2 == true
        move_move(game,
                moves[:sourcex][move].value,
                moves[:sourcey][move].value,
                moves[:targetx][move].value,
                moves[:targety][move].value,
                promote,
                team,
                moves[:targetx2][move].value,
                moves[:targety2][move].value
                )
      end

      #println(team == "w" ? "White" : "Black", " moves a piece.")
    elseif moves[:move_type][move].value == "drop"
      move_drop(game,
          moves[:targetx][move].value,
          moves[:targety][move].value,
          moves[:option][move].value,
          team
          )
          #println(team == "w" ? "White" : "Black", " drops a piece.")
    elseif moves[:move_type][move].value == "resign"
      return team == "b" ? "R" : "r"
      break;
    end
    #print("\n")
    #printBoard(game)
    #println(is_check(game, team == "w" ? "b" : "w") ? "Check!" : "")
    for a in game.cap_white
      if a == "k"
        if !prince_exists(game, "b")
          print("W")
          exit(1)
        end
      end
    end
    for a in game.cap_black
      if a == "k"
        if !prince_exists(game, "w")
          print("B")
          exit(1)
        end
      end
    end

  end
  #println("--------------------")
  #println(team == "b" ? "White" : "Black", "s turn")
  return "?"

end

function prince_exists(game, player)
  #returns whether the specified player controls a prince
  for a in 1:game.boardrows
    for b in 1:game.boardcols
      if game.board[a,b] == "$(player)E"
        return true
      end
    end
  end
  return false
end




function move_drop(game::shogi, targetx::Int, targety::Int, piece::String, team::String)
  #println("testing valid_drop")
  #println(valid_drop(game, targetx, targety, team, piece))
  if game.board[targety, targetx] == "."
    pieceexists = false
    droppable = team == "b" ? game.cap_black : game.cap_white
      for cpiece in eachindex(droppable)
        if droppable[cpiece] == piece
          deleteat!(droppable, cpiece)
          pieceexists = true
          break
        end
      end
    if pieceexists
      game.board[targety, targetx] = "$team$piece"
    else
      println("$piece not available to drop")

    end
  else
    #println("piece exists at target")
  end
end
function drop(game::shogi, targetx::Int, targety::Int, piece::String, team::String)
  #println("testing valid_drop")
  #println(valid_drop(game, targetx, targety, team, piece))
  if game.board[targety, targetx] == "."
    pieceexists = false
    droppable = team == "b" ? game.cap_black : game.cap_white
      for cpiece in eachindex(droppable)
        if droppable[cpiece] == piece
          pieceexists = true
          break
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

function mini_promote(game::shogi, targetx::Int, targety::Int, player::String)
  if game.board[targety, targetx] == "$(player)k" || game.board[targety, targetx] == "$(player)g"
    return false
  end
  if player == "w"
    if targety != game.boardrows #white is in the bottom 3 rows of the board
      return false
    end
  else
    if targetx != 1 #black is in the top 3 rows of the board
      return false
    end
  end
  return true

end

function valid_promote(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, player::String)
  if game.gametype == "minishogi"
    return mini_promote(game, targetx,targety, player)
  elseif game.gametype == "standard"
    if game.board[sourcey, sourcex] == "$(player)k" || game.board[sourcey, sourcex] == "$(player)g"
      return false
    end
    if player == "w"
      if targety < (game.boardrows - 2) #white is in the bottom 3 rows of the board
        return false
      end
    else
      if targety > 3 #black is in the top 3 rows of the board
        return false
      end
    end

  elseif game.gametype == "chushogi"
    if game.board[sourcey, sourcex] == "$(player)k" || game.board[sourcey, sourcex] == "$(player)i" || game.board[sourcey, sourcex] == "$(player)q"
      return false
    end
    if player == "w"
      if targety < (game.boardrows - 3) #white is in the bottom 3 rows of the board
        return false
      else
        if sourcey >= (game.boardrows - 3)
          if game.board[targety, targetx][1:1] == "b"
            return true
          else
            if game.board[targety, targetx][1:1] == "."
              if game.board[sourcey, sourcex][2:2] == "p"
                if targety == game.boardrows
                  return true
                end
              end
            end
          end
        end
        return false
      end

    else
      if targety > 4 #black is in the top 3 rows of the board
        return false
      else
        if sourcey <= 4
          if game.board[targety, targetx][1:1] == "w"
            return true
          else
            #println("testing")
            if game.board[targety, targetx][1:1] == "."
              if game.board[sourcey, sourcex][2:2] == "p"
                #println("Testing2")
                if targety == game.boardrows
                  return true
                end
              end
            end
          end
        end
        #println("returning false")
        return false
      end
    end
  end
  return true
end

function valid_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, player::String)
  return valid_move(game, sourcex, sourcey, targetx, targety, player, 0, 0, 0, 0)
end

function valid_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, player::String, targetx2::Int, targety2::Int)
  return valid_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2, 0, 0)
end

function valid_move(game::shogi, sourcex::Int, sourcey::Int, targetx::Int, targety::Int, player::String, targetx2::Int, targety2::Int, targetx3::Int, targety3::Int)

  #print("$player $sourcex $sourcey $targetx $targety")
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
  if targetx2 != 0 && targety2 != 0
    if (targetx2 > game.boardcols ||
      targetx2 < 1 ||
      targety2 > game.boardrows ||
      targety2 < 1)
      return false
    end
  end
  if (targetx3 != 0 && targety3 != 0)
    if (targetx3 > game.boardcols ||
      targetx3 < 1 ||
      targety3 > game.boardrows ||
      targety3 < 1)
      return false
    end
  end

  #check that the source and target are not the same
  if sourcex == targetx && sourcey == targety
    #println("Valid_Move Error: sourcex == targetx && sourcey == targety")
    return false
  end

  #check if theres a piece at source
  s_piece = game.board[sourcey, sourcex]
  if s_piece == "."
    #println("valid_move error: Tried to move an empty tile")
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
    #println("valid_move error: Trying to attack a teammate")
    return false
  end

  if targetx2 != 0
    t_piece2 = game.board[targety2, targetx2]
    if t_piece2[1:1] == player && (sourcex != targetx2 && sourcey != targety2)
      #println("valid_move error: Trying to attack a teammate with second move")
      return false
    end
    if (targetx2 == targetx && targety2 == targety)
      #println("valid_move error: targetx2 == targetx && targety2 == targety")
      return false
    end
  end

  if targetx3 != 0
    t_piece3 = game.board[targety3, targetx3]
    if t_piece3[1:1] == player && (sourcex != targetx3 && sourcey != targety3)
      #println("valid_move error: Trying to attack a teammate with second move")
      return false
    end
    if (targetx3 == targetx2 && targety3 == targety2)
      #println("valid_move error: targetx3 == targetx2 && targety3 == targety2")
      return false
    end
  end


  #check if the piece can actually move there.
  p = s_piece[2:2]
  #print(p)
  validity = true
  if game.gametype == "standard" || game.gametype == "minishogi"
    if targetx2 != 0
      return false
    end
    if p == "p"
      validity = pawn_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "k"
      validity = king_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "r"
      validity = rookmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "b"
      validity = bishopmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "g"
      validity = goldgeneral_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "s"
      validity = silvergeneral_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "n"
      validity = knight_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "l"
      validity = lancemove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "R"
      validity = rookp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "B"
      validity = bishopp_move(game, sourcex, sourcey, targetx, targety, player)
    else
      validity = goldgeneral_move(sourcex, sourcey, targetx, targety, player)
    end
  elseif game.gametype == "chushogi"
    if targetx3 != 0
      return false
    end
    if p == "a"
      validity = reverse_chariot_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "A"
      validity = whale_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "b"
      validity = bishopmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "B"
      validity = bishopp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "c"
      validity = copper_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "C"
      validity = side_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "d"
      validity = rookp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "D"
      validity = soaring_eagle_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "e"
      validity = drunk_elephant_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "E"
      validity = king_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "f"
      validity = ferocious_leopard_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "F"
      validity = bishopmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "g"
      validity = goldgeneral_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "G"
      validity = rookmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "h"
      validity = bishopp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "H"
      validity = horned_falcon_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "i"
      validity = lion_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "k"
      validity = king_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "l"
      validity = lancemove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "L"
      validity = white_horse_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "m"
      validity = side_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "M"
      validity = free_boar_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "n"
      validity = kirin_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "N"
      validity = lion_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "o"
      validity = go_between_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "O"
      validity = drunk_elephant_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "p"
      validity = pawn_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "P"
      validity = goldgeneral_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "r"
      validity = rookmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "R"
      validity = rookp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "s"
      validity = silvergeneral_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "S"
      validity = vertical_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "t"
      validity = blind_tiger_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "T"
      validity = flying_stag_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "q"
      validity = queen_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "v"
      validity = vertical_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "V"
      validity = flying_ox_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "x"
      validity = phoenix_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "X"
      validity = queen_move(game, sourcex, sourcey, targetx, targety, player)
    end
  elseif game.gametype == "tenjikushogi"
    p = s_piece[2:3]
    if p == "b."
      validity = bishopmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "B."
      validity = bishopp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "bg"
      validity = bishop_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "BG"
      validity = vice_general_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2, targetx3, targety3)
    elseif p == "bt"
      validity = blind_tiger_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "BT"
      validity = flying_stag_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "c."
      validity = copper_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "C."
      validity = side_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "cs"
      validity = chariot_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "CS"
      validity = heavenly_tetrarch_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "d."
      validity = dog_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "D."
      validity = multi_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "de"
      validity = drunk_elephant_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "DE"
      validity = king_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "dh"
      validity = bishopp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "DH"
      validity = horned_falcon_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "dk"
      validity = rookp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "DK"
      validity = soaring_eagle_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "fd"
      validity = fire_demon_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2, targetx3, targety3)
    elseif p == "fe"
      validity = free_eagle_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "fl"
      validity = ferocious_leopard_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "FL"
      validity = bishopmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "g."
      validity = goldgeneral_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "G."
      validity = rookmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "gg"
      validity = great_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "hf"
      validity = horned_falcon_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "HF"
      validity = bishop_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "i."
      validity = iron_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "I."
      validity = vertical_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "k."
      validity = king_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "kr"
      validity = kirin_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "KR"
      validity = ten_lion_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "l."
      validity = lancemove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "L."
      validity = white_horse_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "lh"
      validity = lion_hawk_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "ln"
      validity = ten_lion_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "LN"
      validity = lion_hawk_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "n."
      validity = knight_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "N."
      validity = side_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "p."
      validity = pawn_move(sourcex, sourcey, targetx, targety, player)
    elseif p == "P."
      validity = goldgeneral_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "ph"
      validity = phoenix_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "PH"
      validity = queen_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "q."
      validity = queen_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "Q."
      validity = free_eagle_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "r."
      validity = rookmove(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "R."
      validity = rookp_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "rc"
      validity = reverse_chariot_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "RC"
      validity = whale_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "rg"
      validity = rook_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "RG"
      validity = great_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "s."
      validity = silvergeneral_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "S."
      validity = vertical_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "se"
      validity = soaring_eagle_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2)
    elseif p == "SE"
      validity = rook_general_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "sm"
      validity = side_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "SM"
      validity = free_boar_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "ss"
      validity = side_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "SS"
      validity = water_buffalo_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "vg"
      validity = vice_general_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2, targetx3, targety3)
    elseif p == "vm"
      validity = vertical_mover_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "VM"
      validity = flying_ox_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "vs"
      validity = vertical_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "VS"
      validity = chariot_soldier_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "wb"
      validity = water_buffalo_move(game, sourcex, sourcey, targetx, targety, player)
    elseif p == "WB"
      validity = fire_demon_move(game, sourcex, sourcey, targetx, targety, player, targetx2, targety2, targetx3, targety3)
    end
  end

  if validity == false
    return false
  end

  #check to see if taking this move would leave your king in check.
  return true
end

function valid_drop(game::shogi, Tx::Int, Ty::Int, player::String, piece::String)
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
      if (Ty == 1) #cant drop pawns on the end of the board.
        return false
      end

      for i in 1:game.boardrows #one pawn per team per column
        if game.board[i, Tx] == "bp"
          return false
        end
      end

      if game.board[Ty-1, Tx] == "wk" #can't drop pawn directly in front of king
        game.board[Ty, Tx] = "bp"
        valid = is_checkmate(game, "w")
        if valid == true
          game.board[Ty, Tx] = "."
          return false

        else
          game.board[Ty, Tx] = "."
        end
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
      if (Ty == game.boardrows) #cant drop pawns on the end of the board.
        return false
      end

      for i in 1:game.boardrows #one pawn per team per column
        if game.board[i, Tx] == "wp"
          return false
        end
      end

      if game.board[Ty+1, Tx] == "bk" #can't drop pawn directly in front of king
        game.board[Ty, Tx] = "bp"
        valid = is_checkmate(game, "w")
        if valid == true
          game.board[Ty, Tx] = "."
          return false
        else
          game.board[Ty, Tx] = "."
        end
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

  function is_check(game::shogi, player::String)
  #returns true if player's king is checked
  #step 1: find the king
  kingx = 0
  kingy = 0
  for row in 1:game.boardrows
    for col in 1:game.boardcols
      if game.board[row, col] == "$(player)k"
        kingx = col
        kingy = row
        break
      end
    end
  end
  #println("king at $kingx , $kingy")
  #step 2: check if theres a valid move for the opponent to move into the kings square
  #we can stop if we find just one
  opponent = player == "b" ? "w" : "b"
  for row in 1:game.boardrows
    for col in 1:game.boardcols
      #=
      if valid_move(game, col, row, kingx, kingy, opponent)
        #println("A $(game.board[row, col]) at $col, $row can move into $kingx, $(kingy)!")
        return true
      end
      =#

      if in_danger(game, kingx, kingy, player)
        #println("A $(game.board[row, col]) at $col, $row can move into $kingx, $(kingy)!")
        return true
      end
    end
  end
  return false
end



function is_checkmate(game::shogi, player::String)
  #returns true if player's king is checkmated -> ggwp
  #step 1: are we under check?
  if !is_check(game, player)
    return false #ha nice try lmao
  end

  opponent = player == "w" ? "b" : "w"
  #step 2: try every possible move to get out of check
  #awesome O(N^6) efficiency bruteforce it

  for col in 1:game.boardcols
    for row in 1:game.boardrows
      for i in 1:game.boardcols
        for j in 1:game.boardrows
          #if the move is valid
          if valid_move(game, col, row, i, j, player)
            #if we can make the move, try it in a clone
            clone = copygame(game)
            move_move(clone, col, row, i, j, false, player)
            #is it still check?
            if !is_check(clone, player)
              return false
            end
          end
        end
      end
    end
  end

  #step 3: try to drop somewhere O(n^2)
  #try dropping each available piece everywhere

  droppable = player == "w" ? game.cap_white : game.cap_black
  for col in game.boardcols
    for row in game.boardrows
      for piece in droppable
        if valid_drop(game, row, col, player, piece)
          #drop it in a cloned game
          clone = copygame(game)
          move_drop(clone, row, col, piece, player)
          #are we still in check?
          if !is_check(clone, player)
            #println("A $piece can be dropped at $col, $row")
            return false
          end
        end
      end
    end
  end

  #there are no safe spots
  return true
end
