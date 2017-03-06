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

#Boolean value for standard/mini
gamemode = SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1]
#Determines which shogi will be played.

#Initialize a specific board with all pieces.
if gamemode == "standard"
	game = startStandard()
elseif gamemode == "minishogi"
	game = startMini()
elseif gamemode == "chushogi"
  game = startChu()
end

#print(game.board)
moves = SQLite.query(db, "SELECT * FROM moves")
#check timers
timed = SQLite.query(db, "SELECT value FROM meta WHERE key = 'timed'")[1].values[1]
if timed == "yes"
  time_left = SQLite.query(db, "SELECT value FROM meta WHERE key = 'sente_time'")[1].values[1]
  time_left = parse(Int, time_left)
  if time_left <= 0
    println("W")
    exit(1)
  end
  time_left = SQLite.query(db, "SELECT value FROM meta WHERE key = 'gote_time'")[1].values[1]
  time_left = parse(Int, time_left)
  if time_left <= 0
    println("B")
    exit(1)
  end

end
println(findwinner(game, moves))


#FOR TESTING PURPOSE!!!!!
#Prints board
