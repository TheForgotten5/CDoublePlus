#Description: Determines if both digits contains a 1. Print 1 for true,
#0 for false.

#AND sX, kk
function ANDc(state, register, constant)
	#Confirms they are 8-bit binaries
	#=if (length(op1) != 4) || (length(op2) != 8)
		println("ERROR: Operand1 and operand2 not the same length for AND operation.")
		return false
	end
	=#
	if state.regbank == 0
		value = state.register_a[register] & constant
		state.register_a[register] = value
	else
		value = state.register_b[register] & constant
		state.register_b[register] = value
	end

	state.zero_flag = value == 0 ? 1 : 0
	state.carry_flag = 0

end

#AND sX, sY
function ANDr(state, registerx, registery)
	ANDc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end
#Description: Determines if one or both of the digits contains a 1. Print 1 for true,
#0 for false.

#OR sX, kk
function ORc(state, register, constant)
	#Confirms they are 8-bit binaries
	#=if (length(op1) != 4) || (length(op2) != 8)
		println("ERROR: Operand1 and operand2 not the same length for AND operation.")
		return false
	end
	=#
	if state.regbank == 0
		value = state.register_a[register] | constant
		state.register_a[register] = value
	else
		value = state.register_b[register] | constant
		state.register_b[register] = value
	end

	state.zero_flag = value == 0 ? 1 : 0
	state.carry_flag = 0
end

#OR sX, sY
function ORr(state, registerx, registery)
	ORc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end

#Description: Determines if STRICTLY one of the digits contains a 1. Print 1 for true,
#0 for false.

#XOR sX, kk
function XORc(state, register, constant)
	#Confirms they are 8-bit binaries
	#=if (length(op1) != 4) || (length(op2) != 8)
		println("ERROR: Operand1 and operand2 not the same length for AND operation.")
		return false
	end
	=#
	if state.regbank == 0
		value = state.register_a[register] $ constant
		state.register_a[register] = value
	else
		value = state.register_b[register] $ constant
		state.register_b[register] = value
	end

	state.zero_flag = value == 0 ? 1 : 0
	state.carry_flag = 0
end

#XOR sX, sY
function XORr(state, registerx, registery)
	XORc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end
