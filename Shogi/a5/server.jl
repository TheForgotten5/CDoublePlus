#server.jl file
#NOTE: wincode:authString:movenum:movetype:srcx:srcy:targetx:targety:option:cheating:targetx2:targety2:targetx3:targety3

#TODO
#When a move is played, send it to a game file
#Send payload to opposing player, once a move is completed.
##############
##############
#MAIN
##############
##############

#returns a hex string of length 8
function authCode()
  name = ""
  for i in 1:8
    r = hex(rand(0:8))
    name = "$name$r"
  end
  return name
end

if length(ARGS) < 1
	port = 1337
else
	port = parse(Int, ARGS[1])
end

#Prepares the authCodes before the game is set.
player1 = authCode()
player2 = authCode()

#TESTING PRINT STATEMENTS
println("player 1's authCode is $player1")
println("player 2's authCode is $player2")

#Start running the server
println("The port is set to: $port")
println("IMPORTANT: Once you send a payload to the server, please type readline() with your client variable to read the response from the server.")
server = listen(port)

@async begin
#New game, given that the wincode was 0
function newGame(gametype, legality, time, timeAdd)
	#If both time and timeAdd is 0, it means it's an untimed game.
	###
	###Call the functions to set up the game here.
	###
	return
end

#Randomly assigns players. Returns an integer value.
function assignPlayers()
	return rand(1:2)
end

#Process the move, given the wincode was 2
function processMove(turn, srcx, srcy, targetx, targety, option, cheating, targetx2, targety2, targetx3, targety3)
	#turn is either 1 or 2, representing if it is player 1 or player 2. I guess black and white can use this variable.
	#The cheating variable is either true or false. It has been set when the game was initialized.
	#IF TARGET IS NOT LISTED, IT IS REPRESENTED AS -1
	###
	###Call the move and validate functions here
	###
end

#Process the drop, if the player has specified it.
function processDrop(turn, targetx, targety, piece)
	#turn is either 1 or 2, representing if it is player 1 or player 2. I guess black and white can use this variable.
	###
	###Call the drop and validate functions here
	###
end

function process(payload, connection, turn, cheats, p1auth, p2auth)
	#turns: 1 is for player1, 2 is for player2.
	#gameSet: either true or false.
	#cheats: its either true of false.
	ret = ""
	array = split(payload, ":")
	wincode = array[1]
	
	#Boolean values to detect secondary and ternary targets.
	secondary = false
	ternary = false
	
	#sourcex, sourcey, targetx, targety, targetx2, targety2, targetx3, and targety3 are INTEGERS
	#wincode
	if wincode == "2" #Play a move
		authString = array[2]
		
		#Check for incorrect auth code. Correct the client what their opcode is.
		if authString != p1auth
			wincode = "10"
			errorMsg = "$wincode:Invalid authentication code. Your authentication code is $p1auth and must be entered as part of your payload."
			return errorMsg
		elseif authString != p2auth
			wincode = "10"
			errorMsg = "$wincode:Invalid authentication code. Your authentication code is $p2auth and must be entered as part of your payload."
			return errorMsg
		end
		
		#Check if the player tries to make a move on their opponents turn.
		if authString == p1auth && turn == 2
			wincode = "8"
			errorMsg = "$wincode:This is not your turn! It's player 2's turn!"
			return errorMsg
		elseif authString == p2auth && turn == 1
			wincode = "8"
			errorMsg = "$wincode:This is not your turn! It's player 1's turn!"
			return errorMsg
		end

		#Process more of the payload.
		movenum = array[3]
		movetype = array[4]
		
		#If the player wants to drop a piece, they require just the target x and y, with the desired piece.
		#wincode:authString:movenum:movetype:targetx:targety:option
		if movetype == "drop"
			#Invalid payload
			if length(array) < 7
				wincode = "10"
				errorMsg = "$wincode:Invalid payload. Must be in format wincode:authString:movetype:targetx:targety:option"
				return errorMsg
			end
			
			targetx = array[5]
			targety = array[6]
			piece = array[7]
			
			targetx = tryparse(Int64, targetx)
			targety = tryparse(Int64, targety)
		
			if isnull(targetx) || isnull(targety)
				wincode = "10"
				errorMsg = "$wincode:Invalid values in parameters targetx, targety for 'drop'."
				return errorMsg
			end
			
			#Execute the move
			processDrop(turn, targetx, targety, piece)
			
			#Alternate the turns.
			#Player 1's turn.
			if turn == 1
				ret = "9:$p2authCode:$movenum:$movetype:$targetx:$targety:$piece"
				turn = 2
			elseif turn == 1
				ret = "9:$p2authCode:$movenum:$movetype:$targetx:$targety:$piece"
				turn = 2
			#Player 2's turn.
			elseif turn == 2
				ret = "9:$p1authCode:$movenum:$movetype:$targetx:$targety:$piece"
				turn = 1
			elseif turn == 2
				ret = "9:$p1authCode:$movenum:$movetype:$targetx:$targety:$piece"
				turn = 1
			end
			
			return ret
			
		#If the player wants to move
		#wincode:authString:movenum:movetype:srcx:srcy:targetx:targety:option:cheating:targetx2:targety2:targetx3:targety3
		elseif movetype == "move"
			#Invalid payload
			if length(array) < 9 || length(array) == 10 || length(array) == 12 || length(array) > 13
				wincode = "10"
				errorMsg = "$wincode:Invalid payload. Must be in format 				   wincode:authString:movenum:movetype:srcx:srcy:targetx:targety:option:targetx2:targety2:targetx3:targety3. Targetxy2 and targetxy3 are optional."
				return errorMsg
			end
			srcx = array[5]
			srcy = array[6]
			targetx = array[7]
			targety = array[8]
			option = array[9]
		
			#Are the integer parameters valid?
			movenum = tryparse(Int64, movenum)
			srcx = tryparse(Int64, srcx)
			srcy = tryparse(Int64, srcy)
			targetx = tryparse(Int64, targetx)
			targety = tryparse(Int64, targety)
		
			if isnull(movenum) || isnull(srcx) || isnull(srcy) || isnull(targetx) || isnull(targety)
				wincode = "10"
				errorMsg = "$wincode:Invalid values in parameters targetx2, targety2, targetx3, targety3."
				return errorMsg
			end
		
			movenum = parse(Int64, array[3])
			srcx = parse(Int64, array[5])
			srcy = parse(Int64, array[6])
			targetx = parse(Int64, array[7])
			targety = parse(Int64, array[8])	
	
			#Secondary targets
			if length(array) == 11
				secondary = true
				targetx2 = array[10]
				targety2 = array[11]
			
				#Validity check
				targetx2 = tryparse(Int64, targetx2)
				targety2 = tryparse(Int64, targety2)
			
				if isnull(targetx2) || isnull(targety2)
					wincode = "10"
					errorMsg = "$wincode:Invalid values in parameters targetx2, targety2, targetx3, targety3."
					return errorMsg
				end
			
				targetx2 = parse(Int64, array[10])
				targety2 = parse(Int64, array[11])
				processMove(turn, srcx, srcy, targetx, targety, option, cheats, targetx2, targety2, -1, -1)
			end
	
			#Ternary targets
			if length(array) == 13
				secondary = true
				ternary = true
				
				targetx2 = array[10]
				targety2 = array[11]
				targetx3 = array[12]
				targety3 = array[13]
			
				#Validity check
				targetx2 = tryparse(Int64, targetx2)
				targety2 = tryparse(Int64, targety2)
				targetx3 = tryparse(Int64, targetx3)
				targety3 = tryparse(Int64, targety3)
			
				if isnull(targetx2) || isnull(targety2) || isnull(targetx3) || isnull(targety3)
					wincode = "10"
					errorMsg = "$wincode:Invalid values in parameters targetx2, targety2, targetx3, targety3."
					return errorMsg
				end
			
				targetx2 = parse(Int64, array[10])
				targety2 = parse(Int64, array[11])
				targetx3 = parse(Int64, array[12])
				targety3 = parse(Int64, array[13])
				processMove(turn, srcx, srcy, targetx, targety, option, cheats, targetx2, targety2, targetx3, targety3)
			end
		end		
		#Return the payload. Send to opponent.
		#Forward the other player the movenum:movetype:srcx:srcy:targetx:targety:option:cheating:targetx2:targety2:targetx3:targety3
		
		#Player 1's turn.
		if secondary == false && ternary == false && turn == 2
			ret = "9:$p1authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option"
			turn = 1
		elseif secondary == true && ternary == false && turn == 2
			ret = "9:$p1authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option:$targetx2:$targety2"
			turn = 1
		elseif secondary == true && ternary == true && turn == 2
			ret = "9:$p1authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option:$targetx2:$targety2:$targetx3:$targety3"
			turn = 1
		#Player 2's turn.
		elseif secondary == false && ternary == false && turn == 1
			ret = "9:$p2authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option"
			turn = 2
		elseif secondary == true && ternary == false && turn == 1
			ret = "9:$p2authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option$targetx2:$targety2"
			turn = 2
		elseif secondary == true && ternary == true && turn == 1
			ret = "9:$p2authCode:$movenum:$movetype:$srcx:$srcy:$targetx:$targety:$option:$targetx2:$targety2:$targetx3:$targety3"
			turn = 2
		end
		
		return ret
		
	elseif wincode == "3" && cheats == false #Accuse player of cheating. Move on anyways.
		ret = "10:VAC has detected a cheater on this server."
		return ret
		
	elseif wincode == "10" #Bad payload, just like the player.
		wincode = "10"
		errorMsg = "$wincode:Bad payload."
		return errorMsg
	end

	return
end

	connection = accept(server) #Player 1
	connection2 = accept(server) #Player 2	
	
	#Accepts the settings of the first player with wincode 0
	gameSet = false
	cheats = false

	#Whos turn?
	playerTurn = 1

	#Set up game first before anything else.
	while gameSet == false
	#<wincode>: <gametype>: <legality>: <timelimit>: <limitadd>
		payload = readline(connection) #Read what is sent from the client
		payload2 = readline(connection2) #Read what is sent from the client2
		payload = chomp(payload)
		payload2 = chomp(payload2)
		wincode = payload[1]
		wincode2 = payload[2]
		println("the payload is '$payload'")
		
		#Check if both players entered 0
		if payload == "0" && payload2 == "0" #Just wincode 0, set as standard shogi with no cheats, timed.
			newGame("S", "1", 60, 10)
			ret = "0:S:1:60:10"
			
			write(connection, ret)
			write(connection2, ret)
			gameSet = true
			break
				
		elseif wincode == "0" && length(payload) == 5 #New game
			gametype = payload[2]
			legality = payload[3]
			timeLimit = payload[4]
			limitAdd = payload[5]
		
			#Are the parameters valid?
			timeLimit = tryparse(Int64, timeLimit)
			limitAdd = tryparse(Int64, limitAdd)
			
			#UNTIMED GAME
			if isnull(timeLimit) && isnull(limitAdd)
				newGame(gametype, legality, 0, 0)
				gameSet = true
				break
			elseif isnull(timeLimit) || isnull(limitAdd)
				#Sends error msg
				wincode = "e"
				errorMsg = "$wincode:Invalid values in parameters timeLimit, limitAdd. For untimed game, leave timeLimit and limitAdd blank."
				write(connection, errorMsg)
				continue
			end
		
			#Parse values otherwise
			timeLimit = parse(Int64, payload[4])
			limitAdd = parse(Int64, payload[5])
		
			newGame(gametype, legality, timeLimit, limitAdd)
			gameSet = true
			break
			
		elseif wincode == "0" && length(payload2) == 5 #New game from connection 2
			gametype = payload2[2]
			legality = payload2[3]
			timeLimit = payload2[4]
			limitAdd = payload2[5]
		
			#Are the parameters valid?
			timeLimit = tryparse(Int64, timeLimit)
			limitAdd = tryparse(Int64, limitAdd)
		
			if isnull(timeLimit) || isnull(limitAdd)
				#Sends error msg
				wincode = "e"
				errorMsg = "$wincode:Invalid values in parameters timeLimit, limitAdd."
				write(connection2, errorMsg)
				continue
			end
		
			#Parse values otherwise
			timeLimit = parse(Int64, payload[4])
			limitAdd = parse(Int64, payload[5])
		
			newGame(gametype, legality, timeLimit, limitAdd)
			gameSet = true
			break
		elseif wincode == "1" #Quit game
			write(connection, "2:Terminating server...")
			write(connection2, "2:Terminating server...")
			close(server)
			break
		elseif length(payload) != 5 || length(payload) != 1 #Invalid payload
			wincode = "e"
			errorMsg = "$wincode:Bad payload. Must be either '0' or '0:<gametype>:<legality>:<timelimit>:<limitadd>'"
			write(connection, errorMsg)
			continue
		elseif length(payload2) != 5 || length(payload2) != 1
			wincode = "e"
			errorMsg = "$wincode:Bad payload. Must be either '0' or '0:<gametype>:<legality>:<timelimit>:<limitadd>'"
			write(connection2, errorMsg)	
			continue	
		end
	end
	
	#Assign the players here. Send auth codes.
	write(connection, player1)
	write(connection2, player2)
	
	#Once connected and the game is set, let the payloads begin.
	while true
		if playerTurn == 1
			#Differentiate players here.
			payload = readline(connection) #Read what is sent from the client
			payload = chomp(payload)
			println("the payload is '$payload'")
			wincode = payload[1]
	
			if isalpha(wincode)
				write(connection, "10:Invalid wincode. Must be either 1 to quit game, 2 to make a move, 3 to accuse other player of cheating.")
				continue
			end
			
			if wincode == "1" #Quit game
				write(connection, "2:Terminating server...")
				write(connection2, "2:Terminating server...")
				close(server)
				break
			end

			#Payload for the moves
			if wincode == "2"
				retMsg = process(payload, connection, playerTurn, cheats, gameSet, player1, player2)
				write(connection2, retMsg)
			elseif wincode == "3" #Accuse player of cheating
				retMsg = process(payload, connection2, playerTurn, cheats, gameSet, player1, player2)
				write(connection, retMsg)
				write(connection2, retMsg)
			else #Invalid wincode
				write(connection, "10:Invalid wincode. Must be either 1 to quit game, 2 to make a move, 3 to accuse other player of cheating.")
			end
		end
		
		#PLAYER 2
		if playerTurn == 2
			#Differentiate players here.
			payload = readline(connection2) #Read what is sent from the client
			payload = chomp(payload)
			println("the payload is '$payload'")
			wincode = payload[1]
	
			if isalpha(wincode)
				write(connection2, "10:Invalid wincode. Must be either 1 to quit game, 2 to make a move, 3 to accuse other player of cheating.")
				continue
			end
			
			if wincode == "1" #Quit game
				write(connection, "2:Terminating server...")
				write(connection2, "2:Terminating server...")
				close(server)
				break
			end

			#Payload for the moves
			if wincode == "2"
				retMsg = process(payload, connection2, playerTurn, cheats, gameSet, player1, player2)
				write(connection, retMsg)
			elseif wincode == "3" #Accuse player of cheating
				retMsg = process(payload, connection2, playerTurn, cheats, gameSet, player1, player2)
				write(connection, retMsg)
				write(connection2, retMsg)
			else #Invalid wincode
				write(connection2, "10:Invalid wincode. Must be either 1 to quit game, 2 to make a move, 3 to accuse other player of cheating.")
			end
		end
	end

end

