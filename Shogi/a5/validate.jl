using SQLite
include("shogi.jl")
include("hidden_functions.jl")

if length(ARGS) < 1
	print_with_color(:red, "Insufficient ARGS for Validate.jl. \n")
  	exit(1)
end

filename = ARGS[1]

db = SQLite.DB(filename)

#Boolean value for standard/mini
gamemode = SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1]
#Determines which shogi will be played.
#Automatically set standard as default

#Initialize a specific board with all pieces.
if gamemode == "standard"
	game = startStandard()
elseif gamemode == "minishogi"
	game = startMini()
elseif gamemode == "chushogi"
	game = startChu()
end

#println(game.board)
moves = SQLite.query(db, "SELECT * FROM moves")
hidden_updateboard(game, moves)
