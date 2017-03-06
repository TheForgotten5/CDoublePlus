#Flags are C(odd number of 1's in bits),Z(all bits are 0)

#Description: Similar to "AND" operation. Sets flags C and Z
#instead of returning a result instead. BINARY REQUIRED.
function testr(state, registerx, registery)
	if state.regbank == 0
		testc(state, registerx, state.register_a[registery])
	else
		testc(state, registerx, state.register_b[registery])
	end
end

function testc(state, registerx, constant)
	if state.regbank == 0
		value = state.register_a[registerx]
	else
		value = state.register_b[registerx]
	end
	numberOfOnes = 0
	value &= constant
	binary = bin(value)
	#println("Scanning binary...")
	#Scans through binary
	for index in 1:length(binary)
		if (binary[index] == "1") && (binary[index] == "1")
			numberOfOnes += 1
		end
	end

	#binary1 = parse(Int, binary1, 2)
	#binary2 = parse(Int, binary2, 2)

	#println("Adjusting flags")
	#Odd parity of 1's

	state.zero_flag = numberOfOnes == 0 ? 1 : 0
	state.carry_flag = numberOfOnes % 2 == 1 ? 1 : 0

end

function testcyr(state, registerx, registery)
	if state.regbank == 0
		testcyc(state, registerx, state.register_a[registery])
	else
		testcyc(state, registerx, state.register_b[registery])
	end
end

function testcyc(state, registerx, constant)
	if state.regbank == 0
		value = state.register_a[registerx]
	else
		value = state.register_b[registerx]
	end
	numberOfOnes = 0
	value &= constant
	binary = bin(value)
	#println("Scanning binary...")
	#Scans through binary
	for index in 1:length(binary)
		if (binary[index] == "1") && (binary[index] == "1")
			numberOfOnes += 1
		end
	end

	#binary1 = parse(Int, binary1, 2)
	#binary2 = parse(Int, binary2, 2)

	#println("Adjusting flags")
	#Odd parity of 1's
	state.zero_flag = numberOfOnes == 0 && state.zero_flag == 1 ? 1 : 0
	state.carry_flag = (numberOfOnes + state.carry_flag) % 2 == 1 ? 1 : 0


end

#Description: Subtracts but does not return a result. It only
#updates the flags C and Z. Binary not required.
function comparer(state, registerx, registery)
	if state.regbank == 0
		comparec(state, registerx, state.register_a[registery])
	else
		comparec(state, registerx, state.register_a[registery])
	end
end
function comparec(state, registerx, constant)
	value = state.regbank == 0 ? state.register_a[registerx] : state.register_b[registerx]
	#Sets C if difference is negative
	state.zero_flag = value == constant ? 1 : 0
	state.carry_flag = value < constant ? 1 : 0
	#Sets X if values are equal
end

function comparecyr(state, registerx, registery)
	if state.regbank == 0
		comparecyc(state, registerx, state.register_a[registery])
	else
		comparecyc(state, registerx, state.register_a[registery])
	end
end
function comparecyc(state, registerx, constant)
	value = state.regbank == 0 ? state.register_a[registerx] : state.register_b[registerx]

	#Sets C if difference is negative
	state.zero_flag = value - constant == 0 && state.zero_flag == 1 ? 1 : 0


	state.carry_flag = value < constant ? 1 : 0
	#Sets X if values are equal
end
