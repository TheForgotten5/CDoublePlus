#include SQLite
using SQLite

#assert arguments
num = length(ARGS)
if num < 3
  print_with_color(:red, "Insufficient ARGS. \n")
  exit(1)
end
#simplify arguments
filename = ARGS[1]
gametype = ARGS[2]
cheating = ARGS[3]

if num < 4
  limit = 0
else
  limit = tryparse(Int, ARGS[4])
  if isnull(limit)
    print_with_color(:red, "Non-Integer entered for limit.\n")
    exit(1)
  end
  limit = limit.value
end

if num < 5
  limit_add = 0
else
  limit_add = tryparse(Int, ARGS[5])
  if isnull(limit_add)
    print_with_color(:red, "Non-Integer entered for limit-add\n")
    exit(1)
  end
  limit_add = limit_add.value
end

#parse ints

#create the database
db = SQLite.DB(filename)

#drop the tables if they exists already
SQLite.query(db, "DROP TABLE IF EXISTS meta")
SQLite.query(db, "DROP TABLE IF EXISTS moves")

#make the meta table
SQLite.query(db, "CREATE TABLE meta(key, value)")

#insert key values
if gametype == "S"
  SQLite.query(db, "INSERT INTO meta VALUES ('type', 'standard')")
elseif gametype == "M"
  SQLite.query(db, "INSERT INTO meta VALUES ('type', 'minishogi')")
elseif gametype == "C"
  SQLite.query(db, "INSERT INTO meta VALUES ('type', 'chushogi')")
elseif gametype == "T" #New addition: Tenjiku Shogi
  SQLite.query(db, "INSERT INTO meta VALUES ('type', 'ten')")
else
  print_with_color(:red, "Invalid gametype '$gametype'.\n")
  exit(1)
end

if cheating == "T"
  SQLite.query(db, "INSERT INTO meta VALUES ('legality', 'cheating')")
else
  SQLite.query(db, "INSERT INTO meta VALUES ('legality', 'legal')")
end

#Check if timer will be used or not.
if limit != 0 #Timer
  	SQLite.query(db, "INSERT INTO meta VALUES ('timed', 'yes')")
  	SQLite.query(db, "INSERT INTO meta VALUES ('time_add', '$limit_add')")
  	SQLite.query(db, "INSERT INTO meta VALUES ('gote_time', '$limit')")
  	SQLite.query(db, "INSERT INTO meta VALUES ('sente_time', '$limit')")
else #No timer
  SQLite.query(db, "INSERT INTO meta VALUES ('timed', 'no')")
end

SQLite.query(db, "INSERT INTO meta VALUES ('seed', strftime('%s','now'))")

#make the moves tables
#NEW THINGS: timer, time_add, sente_timer, gote_timer
SQLite.query(db, "CREATE TABLE moves(move_number, move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating, targetx2, targety2, targetx3, targety3)")
