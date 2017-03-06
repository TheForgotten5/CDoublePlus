using SQLite

#Checks if all arguments are included move_user_drop.jl
if length(ARGS) != 4
  print_with_color(:red, "ERROR: Not enough arguments. Please include: filename, piece, X-target, Y-target.\n")
  exit(1)
end

filename = ARGS[1]
piece = ARGS[2]
targetX = ARGS[3]
targetY = ARGS[4]

db = SQLite.DB(filename)

#Detect if the gamemode is on 'chushogi' or 'tenjiku shogi'
if SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1] == "chushogi"
	println("ERROR: Chu-shogi does not allow 'drop' moves. This move cannot be used.")
	exit(1)
elseif SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1] == "ten"
	println("ERROR: Tenjiku shogi does not allow 'drop' moves. This move cannot be used.")
	exit(1)
end

#Converts string to int
targetX = parse(Int64, targetX)
targetY = parse(Int64, targetY)

#find previous move_number
a = SQLite.query(db, "SELECT * FROM moves")
num = length(a[:move_number]) + 1

#Update database with dropped piece
SQLite.query(db, "INSERT INTO moves(move_number, move_type, targetx, targety, option)
										VALUES ($num, 'drop', $targetX, $targetY, '$piece')")
