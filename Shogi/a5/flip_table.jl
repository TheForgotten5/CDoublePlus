#= DO NOT USE THIS FILE!!!
THIS WILL FLOOD YOUR WORKING DIRECTORY WITH GARBAGE DATABASES
DO NOT USE!
DO NOT USE!
DO NOT USE!
DO NOT USE!
IN CASE OF ACCIDENTAL USAGE USE CTRL + C TO INTERUPT
actually not that dangerous though, make sure you interupt because it it IS
a permanent loop
=#

using SQLite

if length(ARGS) != 1
  print_with_color(:cyan, "Invalid ARGS")
  exit(1)
end

filename = ARGS[1]
db = SQLite.DB(filename)
SQLite.query(db, "DROP TABLE IF EXISTS meta")
SQLite.query(db, "DROP TABLE IF EXISTS moves")

mad = true

function rs(length)
  #returns a hex string of specified length
  name = ""
  for i in 1:length
    r = hex(rand(0:210000000000))
    name = "$name$r"
  end
  return name
end

while mad
  name = rs(rand(6:30))
  name = "$name.db"
  trash = SQLite.DB(name)
  for i in 1:rand(40:120)
    table = rs(rand(4:15))
    SQLite.query(trash, "CREATE TABLE IF NOT EXISTS K$table(yolo, swag, lmao, memes, dank, weed, airhorn)")
    for j in 1:rand(60:2300)
      num = 700
      r1 = rs(num)
      r2 = rs(num)
      r3 = rs(num)
      r4 = rs(num)
      r5 = rs(num)
      r6 = rs(num)
      r7 = rs(num)
      SQLite.query(trash, "INSERT INTO K$table VALUES ('$r1', '$r2', '$r3', '$r4', '$r5', '$r6', '$r7')")
    end
  end
    mad = false
end
