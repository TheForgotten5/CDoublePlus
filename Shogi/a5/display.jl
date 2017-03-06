#Include sql
using SQLite

include("shogi.jl")

#Checks if filename is included
if length(ARGS) != 1
  print_with_color(:red, "ERROR: Filename required to initialize board. \n")
  exit(1)
end

filename = ARGS[1]
#Opens the database
db = SQLite.DB(filename)

gamemode = SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1]
#Determines which shogi will be played.

#Initialize a specific board with all pieces.
if gamemode == "standard"
	game = startStandard()
elseif gamemode == "minishogi"
	game = startMini()
elseif gamemode == "chushogi"
	game = startChu()
elseif gamemode == "ten"
	game = startTen()
end

#print(game.board)
moves = SQLite.query(db, "SELECT * FROM moves")
updateboard(game, moves)

#FOR TESTING PURPOSE!!!!!
#Prints board
#printBoard(game)

#println("Testing type of null entry in database")
#print(typeof(moves[:option][1]) == Nullable{Any})

#println("don't worry love")
#println(valid_move(game, 6, 8, 5, 6, "b"))
#println(generator(game, 1, 9, "b"))
#println(generator(game, 1, 4, "w"))
#println(generator(game, 6, 11, "b"))
