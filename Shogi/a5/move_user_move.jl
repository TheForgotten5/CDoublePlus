using SQLite
if length(ARGS) == 5
  push!(ARGS, "F")
end

#Checks if all arguments up to promoStatus are included.
#Secondary targets and ternary targets are for certain pieces.
if length(ARGS) != 6 || length(ARGS) < 10
  print_with_color(:red, "ERROR: Not enough arguments. Please include: filename, X-source, Y-source, X-target, Y-target, 
  												PromotionStatus, X-target2, Y-target2, X-target3, Y-target3\n")
  print_with_color(:yellow, "NOTE: X-target2, Y-target2, X-target3 and Y-target3 are optional.\n")
  exit(1)
end

filename = ARGS[1]
sourceX = ARGS[2]
sourceY = ARGS[3]
targetX = ARGS[4]
targetY = ARGS[5]
promoStatus =  ARGS[6]

#Converts string to int
sourceX = tryparse(Int64, sourceX)
sourceY = tryparse(Int64, sourceY)
targetX = tryparse(Int64, targetX)
targetY = tryparse(Int64, targetY)
#sanity check
if isnull(sourceX) || isnull(sourceY) || isnull(targetX) || isnull(targetY)
  print_with_color(:red, "Error parsing source/targets")
  exit(1)
end
sourceX = sourceX.value
sourceY = sourceY.value
targetX = targetX.value
targetY = targetY.value

#If secondary targets have been indicated.
if length(ARGS) == 8
	targetX2 = ARGS[7]
	targetY2 = ARGS[8]
	targetX2 = tryparse(Int64, targetX2)
	targetY2 = tryparse(Int64, targetY2)
  #quick sanity check
  if isnull(targetX2) || isnull(targetY2)
    print_with_color(:red, "Error parsing source/targets")
    exit(1)
  end
  targetX2 = targetX2.value
  targetY2 = targetY2.value
end

#If ternary targets have been indicated.
if length(ARGS) == 10
	targetX3 = ARGS[9]
	targetY3 = ARGS[10]
	targetX3 = tryparse(Int64, targetX3)
	targetY3 = tryparse(Int64, targetY3)
  #quick sanity check
  if isnull(targetX3) || isnull(targetY3)
    print_with_color(:red, "Error parsing source/targets")
    exit(1)
  end
  targetX3 = targetX3.value
  targetY3 = targetY3.value
end


db = SQLite.DB(filename)
#find previous move_number
a = SQLite.query(db, "SELECT * FROM moves")
num = length(a[:move_number]) + 1
#Checks if the piece is promoted or not
if promoStatus == "T"
	#Check if secondary target locations are given.
	if length(ARGS) == 8
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2)
									  	VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, '!', $targetX2, $targetY2)")
	elseif length(ARGS) == 10 #Ternary target
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2)
									  	VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, '!', $targetX2, $targetY2, $targetX3, $targetY3)")
	else
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option)
									  	VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, '!')")
	end
else
	if length(ARGS) == 8 #Secondary target
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2)
									  	VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, NULL, $targetX2, $targetY2)")
	elseif length(ARGS) == 10 #Ternary target
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option, targetx2, targety2)
									  	VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, NULL, $targetX2, $targetY2, $targetX3, $targetY3)")
	else #Only one target
		SQLite.query(db, "INSERT INTO moves(move_number, move_type, sourcex, sourcey, targetx, targety, option)
											VALUES ($num, 'move', $sourceX, $sourceY, $targetX, $targetY, NULL)")
	end
end
