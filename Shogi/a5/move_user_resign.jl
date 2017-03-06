using SQLite

#Checks if all arguments are included move_user_drop.jl
if length(ARGS) != 1
  print_with_color(:red, "ERROR: Not enough arguments. Filename is required.\n")
  exit(1)
end

filename = ARGS[1]

db = SQLite.DB(filename)
#find previous move_number
a = SQLite.query(db, "SELECT * FROM moves")
num = length(a[:move_number]) + 1

#Update database with resignation
SQLite.query(db, "INSERT INTO moves(move_number, move_type)
										VALUES ($num, 'resign')")
