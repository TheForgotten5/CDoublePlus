#The games can have a time limit.
#For games played via move.jl, each move.jl
#should keep the time updated for themselves. (If a
#move.jl plays a move for sente, deduct time from
#the sente player.) A er every move the game file
#will be checked for a timeout by win.jl.
#For server games, the server keeps the time.

totalTime = 5 #The time limit
timeAdd = 5 #Addition to the time

println(round(totalTime, 1), " seconds left.")
while true
	tick = tic()
	sleep(1) #1 sec delay
	tick = toq()
	totalTime -= tick
	
	if totalTime < 0
		println("TIME UP")
		break
	end
	
	println(round(totalTime), " seconds left.")
	
	#Might need to add in operations here to keep track of the moves from each player.
end
