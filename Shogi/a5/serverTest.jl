#Connect to server
lel = connect(1337)
write(lel, "top kek")
#Read the string and break it into components.
components = split(payload, ":")
wincode = components[1]

#NOTE:<wincode>:<gametype>:<legality>:<timelimit>:<limitadd>
if wincode == 0 #Start new game
	legality = components[2]
	timeLimit = components[3]
	limitAdd = components[4]
	
	timeLimit = tryparse(Int64, components[3])
	limitAdd = tryparse(Int64, components[4])
	
	#Return as untimed game.
	if isnull(timeLimit) || isnull(limitAdd)
	
	#If the user puts in a time but no time addition, return error msg
	elseif !isnull(timeLimit) && isnull(limitAdd)
	
	#Return as a timed game
	else
	
	end
	
	return
	
elseif length(components)
	#If game started, continue with rest of parameters.
	authString = components[2]
	moveNumber = components[3]
	moveType = components[4]
	sourceX = components[5]
	sourceY = components[6]
	targetX = components[7]
	targetY = components[8]
	option = components[9]
	cheating = components[10]
elseif length(components) > 10 #Check if secondary targets exist
	targetX2 = components[11]
	targetY2 = components[12]
end

#Try to parse all values that are supposed to be integers. If the value is null, set it to 0


#Operations from client
#Error code format is wincode:err message
if wincode == 1 #Quit a game
elseif wincode == 2 #Play a game
elseif wincode == 3 #Accuse player of cheating
elseif wincode == 10 #Bad payload, return error msg
end
