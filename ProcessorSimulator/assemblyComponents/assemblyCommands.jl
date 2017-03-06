#This will read out all of the lines of code given as input up to 2047 lines.
#The lines of code are of the format
#label: instruction operand1, operand2 ;comments

#So, all this will be saved to the program memory, which will be a 2048 x 3 multidimensional Int16 array
#As well there will be an array for labels. Potentially, every line could have a label, so it will be
#  a 2048 size array with the index being the line it refers to and the label.
#keep track of what line you are reading. For each i'th line of code
#  ->check if there is a label, if yes, add it to the label array in the i'th index.
#  ->add the instruction as it's opcode on page 54, and its operands as numbers.
#  ->ignore the comments
#You can read the "all_kcpsm6_syntax.psm" to find what all the syntax looks like and what to look for.
#keep in mind that values might be in hex, binary or decimal.

#Array of all commands for searching purposes.
allCommands = ["load", "star", "and", "or", "xor", "add", "addcy", "sub", "subcy",
							 "test", "testcy", "compare", "comparecy", "sl0", "sl1", "slx", "sla",
							 "rl", "sr0", "sr1", "srx", "sra", "rr", "regbank", "input", "output",
							"store", "fetch", "jump", "jump@", "call", "call@", "return", "load&return", "hwbuild"]

#Opcodes
opCode = []

#2048x3 array for operation code, op1 and op2
programMemory = Int16[2048,3]
#Tracks the lines
lineCounter = 0
#If the line has a label, store in another array. It will contain line number and label.
labelArray = Int16[2048,2]
#Registers and their statuses of inactive/active
registers = Int16[16, 2]
#registers: "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "sa", "sb", "sc", "sd", "se", "sf"

#Carry flag
C = 0
#Zero flag
Z = 0

#Desription: Reads the input and saves into array.
function saveToArray(input)
	#Checks for labels by determining if command DNE
	#If label exists, save in labelArray
	for index in 1:length(allCommands)
		if lower(input) == allCommands[index]
			flag = true
		end
	end

	#Label exists
	#if (false)

	#elseif true
	
	#Reads operation, then accepts op1 and op2
	#end
end

#Description: Linearly searches for an existing command. Returns true if found, false if not.
#Time efficiency: O(N)
function search(target)
	for index in 1:length(allCommands)
		if lower(target) == allCommands[index]
			#Target found
			return true
		end
	end
	#Target not found
	return false
end
