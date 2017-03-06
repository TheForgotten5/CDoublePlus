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
end

#print(game.board)
moves = SQLite.query(db, "SELECT * FROM moves")
states = gamearray(game, moves)
current = 1

while true
  println("Move #$current")
  team = current % 2 == 1 ? "b" : "w"

  print("$(team == "b" ? "Black" : "White") ")

  movetype = moves[:move_type][current].value
  if movetype == "move"
    if (isnull(moves[:targetx2][current]))
      println("moves the piece at $(moves[:sourcex][current].value), $(moves[:sourcey][current].value) to $(moves[:targetx][current].value), $(moves[:targety][current].value)")
    else
      println("moves the piece at $(moves[:sourcex][current].value), $(moves[:sourcey][current].value) to $(moves[:targetx][current].value), $(moves[:targety][current].value) and then to $(moves[:targetx2][current].value), $(moves[:targety2][current].value)")
    end
  elseif movetype == "drop"
    println("drops a $(moves[:option][current].value) at $(moves[:targetx][current].value), $(moves[:targety][current].value).")
  elseif movetype == "resign"
    println("resigns")
  end
  printBoard(states[current])
  answer = lowercase(strip(chomp(readline())))
  if answer == "next" || answer == ""
    current += 1
  elseif answer == "back"
    current -= 1
  elseif answer == "exit"
    break
  elseif answer == "goto"
    println("Enter move to skip to.")
    num = tryparse(Int, strip(chomp(readline())))
    if isnull(num)
      println("Unable to read value.")
    else
      current = num.value
    end
  else
    println("Unknown command $answer, use 'next', 'back', 'goto', or 'exit'.\n entering a blank line will also count as next.")
  end
  if current < 1
    current = 1
  end

  if current > length(states)
    println("end of database")
    current = length(states)
  end
end
