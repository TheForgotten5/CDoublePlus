#using registerLoading #Load, star

	include("logical.jl") #And, or, Xor
	include("arithmetic.jl") #Add, sub
	include("registerLoading.jl") #load, star
	include("testCompare.jl") #test, compare
	include("shiftRotateLeft.jl") #sl0, sl1, slx, sla
	include("shiftRotateRight.jl") #sr0, sr1, srx, sra
	include("regBank.jl")
	include("stack.jl")
  include("rotate.jl")
  include("io.jl")
	#include("assemblyCommands.jl") #Database of all assembly commands, excluding interruption handling #deprecated
#=
#kk means fixed value, sY is a value in a register

#Description: Reads a label. Sets it as an address
function readLabel(label)
	address = label;
end

#Description: Reads an operation. If it exists, retrieve an operation
#to execute
function readOperation(operation)
	if search(operation) == true
		#operand1 =
		#operand2 =
		#readOperands(operand1, operand2)
		return true
	else
		println("ERROR: Command does not exist.")
		return false
	end
end

#Description: Reads both operand 1 and 2 for operations.
function readOperands(operand)

end

#Description: Initiates execution of given assembly code.
function operation(op1, op2, operation, label)

end
=#
