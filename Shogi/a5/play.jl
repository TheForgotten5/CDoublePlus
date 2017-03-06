include("shogi.jl")
include("moverandomizer.jl")
println("Welcome to Shogi!")
srand()
game = 0

#Check for chushogi
noDrops = false
timed = false
time = 0
addTime = 0
gametype = ""

while true
  println("Would you like to play standard, mini, chushogi, or tenjiku?")
  answer = chomp(readline())
  if lowercase(answer) == "standard"
    game = startStandard()
    break
  elseif lowercase(answer) == "mini"
    game = startMini()
    break
  elseif lowercase(answer) == "chushogi"
    game = startChu()
    gametype = "chu"
		noDrops = true
    break
  elseif lowercase(answer) == "tenjiku"
    game = startTen()
    gametype = "ten"
		noDrops = true
    break
  else
    println("Sorry I don't know what $answer is.")
  end
end

while true
	println("Would you like to have a time limit? ('y' or 'n')")
	answer = chomp(readline())
	if lowercase(answer) == "y"
		println("Please type: <totalSeconds> <timeAddition>")
		timeValues = chomp(readline())
		timeValues = split(timeValues)

		#Checks for enough arguments
		if length(timeValues) != 2
			println("Please provide a time and timeAddition!")
			continue
		else
			time = tryparse(Int, timeValues[1])
			addTime = tryparse(Int, timeValues[2])

			#Check if input are integers
			if isnull(time) || isnull(addTime)
				println("Invalid values for time and time addition. Please enter an integer!")
				continue
			end

			#Enables time limit.
			time = parse(Int, timeValues[1])
			addTime = parse(Int, timeValues[2])
			timed = true
			break
		end
	elseif lowercase(answer) == "n"
		break
	else
	  println("Sorry I don't know what $answer is.")
	end
end


println("Here's the game board! You are playing as Black")
printBoard(game)
while true
	if timed
		println(round(time), " seconds left.")
	end

  println("It's your turn!")

	tick = tic()
  answer = chomp(readline())
  tick = toq()
	time -= tick

	#Checks if the player took too long to make a move.
	if (time < 0) && (timed == true)
		println("You have timed out!")
		println("You have lost!")
		break
	end

  array = split(answer)

  if length(array) == 0
    println("I don't know what that command is. You can try 'move', 'drop', 'show' or 'resign'")
    continue
  end

  if array[1] == "move"
    #move code goes here
    #needs sourcex, sourcey, targetx, targety, promotion
    if length(array) < 6
      println("Usage: move <sourcex> <sourcey> <targetx> <targety> [promote] <targetx2> <targety2> <targetx3> <targety3>\n type 'no' if you don't want to promote, 'yes' if you do.")
      println("NOTE: <targetx2> <targety2> <targetx3> <targety3> are optional.")
      continue
    end
    sx = tryparse(Int, array[2])
    sy = tryparse(Int, array[3])
    tx = tryparse(Int, array[4])
    ty = tryparse(Int, array[5])
    tx2 = 0
    ty2 = 0
		#Promo status is array[6]
		if length(array) > 6
    	tx2 = tryparse(Int, array[7])
    	ty2 = tryparse(Int, array[8])
		end

    if isnull(sx) || isnull(sy) || isnull(tx) || isnull(ty)
      println("Usage: move <sourcex> <sourcey> <targetx> <targety> [promote] <targetx2> <targety2> <targetx3> <targety3>\n type 'no' if you don't want to promote, 'yes' if you do.")
      println("NOTE: <targetx2> <targety2> <targetx3> <targety3> are optional.")
      continue
    end

		#Check if secondary targets need to be parsed.
		if length(array) > 6 && !isnull(tx2) && !isnull(ty2)
			tx2 = parse(Int, array[7])
    	ty2 = parse(Int, array[8])
		end

    sx = parse(Int, array[2])
    sy = parse(Int, array[3])
    tx = parse(Int, array[4])
    ty = parse(Int, array[5])

		#Checks for promotion
    if array[6] == "no"
      promote = false
    else
      promote = true
    end

    if length(array) == 6
		  if valid_move(game, sx, sy, tx, ty, "b", tx2, ty2) && !(promote && !valid_promote(game, tx, ty, "b"))
		  	if timed == true
		  		time += addTime
		  	end
		    move_move(game, sx, sy, tx, ty, promote, "b", tx2, ty2)
		  else
		    println("That's not a valid move!")
		    continue
		  end
		elseif length(array) > 6
			if valid_move(game, sx, sy, tx, ty, "b", tx2, ty2) && !(promote && !valid_promote(game, tx, ty, "b"))
		  	if timed == true
		  		time += addTime
		  	end
		    move_move(game, sx, sy, tx, ty, promote, "b", tx2, ty2)
		  else
		    println("That's not a valid move!")
		    continue
		  end
		end
    #now opponent moves



  elseif array[1] == "drop"
    #drop code goes here
    #needs targetx, targety, piece, team
		#Checks if the game is set on chushogi
		if noDrops == true && gametype == "chu"
			println("Drop is not allowed in chu-shogi.")
			continue
		elseif noDrops == true && gametype == "ten"
			println("Drop is not allowed in tenjiku shogi.")
			continue
		end

    if length(array) != 4
      println("Usage: drop <targetx> <targety> <piece>\n Use the single character represented on the droppable pieces to define the piece you want to drop")
      continue
    end
    tx = tryparse(Int, array[2])
    ty = tryparse(Int, array[3])
		Piece = array[4]

      if isnull(tx) || isnull(ty)
      println("Usage: drop <targetx> <targety> <piece>")
      continue
    end
    tx = parse(Int, array[2])
    ty = parse(Int, array[3])

    if valid_drop(game, tx, ty, "b", Piece)
      move_drop(game, tx, ty, Piece, "b")
    else
      println("That's not a valid drop!")
      continue
    end
    #now opponent moves
  elseif array[1] == "resign"
    #resign code goes here
		print_with_color(:red, "YOU LOST!\n")
		exit(1)
  elseif array[1] == "show"
    printBoard(game)
    continue
  else
    println("I don't know what that command $(array[1]) is. You can try 'move', 'drop', 'show', or 'resign'")
    continue
  end

  #make the ai do a move
  if random_move(game, "w") == 0
    #the ai resigned!
    printBoard(game)
    print_with_color(:red, "Y")
    print_with_color(:yellow, "o")
    print_with_color(:green, "u ")
    print_with_color(:cyan, "w")
    print_with_color(:blue, "i")
    print_with_color(:magenta, "n")
    print_with_color(:red, "!\n")
    exit(0)
  end

  for P in game.cap_black
    if P == "k"
      printBoard(game)
      #you win
      print_with_color(:red, "Y")
      print_with_color(:yellow, "o")
      print_with_color(:green, "u ")
      print_with_color(:cyan, "w")
      print_with_color(:blue, "i")
      print_with_color(:magenta, "n")
      print_with_color(:red, "!\n")


      exit(0)
    end
  end
  for P in game.cap_white
    if P == "k"
      printBoard(game)
      print_with_color(:red,"You have lost!\n")

      exit(1)
    end
  end
  printBoard(game)
end
