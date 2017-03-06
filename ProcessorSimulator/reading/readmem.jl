function read_instruction(state)
	instruction = state.program_memory[state.program_counter][1:2] #takes the first 2 digits of the opcode, decides which function to call.

	if instruction == "00"
		# Convert the 2 operands into decimal form
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		loadr(state, op1, op2)

	elseif instruction == "01"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		loadc(state, op1, op2)

	elseif instruction == "16"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		starr(state, op1, op2)

	elseif instruction == "17"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		star(state, op1, op2)

	#Logical

	elseif instruction == "02"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		ANDr(state, op1, op2)

	elseif instruction == "03"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		ANDc(state, op1, op2)

	elseif instruction == "04"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		ORr(state, op1, op2)

	elseif instruction == "05"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		ORc(state, op1, op2)

	elseif instruction == "06"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		XORr(state, op1, op2)

	elseif instruction == "07"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		XORc(state, op1, op2)


	#Arithmetic

	elseif instruction == "10"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		addr(state, op1, op2)

	elseif instruction == "11"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		addc(state, op1, op2)

	elseif instruction == "12"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		addcyr(state, op1, op2)

	elseif instruction == "13"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		addcyc(state, op1, op2)

	elseif instruction == "18"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		subr(state, op1, op2)

	elseif instruction == "19"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		subc(state, op1, op2)

	elseif instruction == "1A"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		subcyr(state, op1, op2)

	elseif instruction == "1B"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		subcyc(state, op1, op2)


	#Test and Compare

	elseif instruction == "0C"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		testr(state, op1, op2)

	elseif instruction == "0D"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		testc(state, op1, op2)

	elseif instruction == "0E"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		testcyr(state, op1, op2)

	elseif instruction == "0F"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		testcyc(state, op1, op2)

	elseif instruction == "1C"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		comparer(state, op1, op2)

	elseif instruction == "1D"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		comparec(state, op1, op2)

	elseif instruction == "1E"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		comparecyr(state, op1, op2)

	elseif instruction == "1F"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		comparecyc(state, op1, op2)


	#Shift and Rotate

	elseif instruction == "14"

		shift_ins = state.program_memory[state.program_counter][4:5] #shift and rotate is handled by last 2 digits
		if shift_ins == "06"
			op1 = register_operand(state, 3)
			SL0(state, op1)

		elseif shift_ins == "07"
			op1 = register_operand(state, 3)
			SL1(state, op1)

		elseif shift_ins == "04"
			op1 = register_operand(state, 3)
			SLX(state, op1)

		elseif shift_ins == "00"
			op1 = register_operand(state, 3)
			SLA(state, op1)

		elseif shift_ins == "02"
			op1 = register_operand(state, 3)
			RL(state, op1)

		elseif shift_ins == "0E"
			op1 = register_operand(state, 3)
			SR0(state, op1)

		elseif shift_ins == "0F"
			op1 = register_operand(state, 3)
			SR1(state, op1)

		elseif shift_ins == "0A"
			op1 = register_operand(state, 3)
			SRX(state, op1)

		elseif shift_ins == "08"
			op1 = register_operand(state, 3)
			SRA(state, op1)

		elseif shift_ins == "0C"
			op1 = register_operand(state, 3)
			RR(state, op1)
		elseif shift_ins == "80"
			op1 = register_operand(state, 3)
			hwbuild(state, op1)
		end

	#Register Bank Selection

	elseif instruction == "37"
		shift_ins = state.program_memory[state.program_counter][4:5]
		if shift_ins == "00"
			regBankA(state)

		elseif shift_ins == "01"
			regBankB(state)
		end

	#Input and Output

	elseif instruction == "08"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		inputr(state, op1, op2)

	elseif instruction == "09"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		input(state, op1, op2)

	elseif instruction == "2C"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		outputr(state, op1, op2)

	elseif instruction == "2D"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		output(state, op1, op2)

	elseif instruction == "2B"
		op1 = constant_operand(state, 3,4)
		op2 = register_operand(state, 5)
		outputk(state, op1, op2-1)

	#Scratch Pad Memory

	elseif instruction == "2E"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		store(state, op1, op2)

	elseif instruction == "2F"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		storess(state, op1, op2)

	elseif instruction == "0A"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		fetch(state, op1, op2)

	elseif instruction == "0B"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		fetchss(state, op1, op2)

	#Jump

	elseif instruction == "22"
		op1 = constant_operand(state, 3,5)
		jump(state, op1)

	elseif instruction == "32"
		op1 = constant_operand(state, 3,5)
		jumpZ(state, op1)

	elseif instruction == "36"
		op1 = constant_operand(state, 3,5)
		jumpNZ(state, op1)

	elseif instruction == "3A"
		op1 = constant_operand(state, 3,5)
		jumpC(state, op1)

	elseif instruction == "3E"
		op1 = constant_operand(state, 3,5)
		jumpNC(state, op1)

	elseif instruction == "26"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		jumpat(state, op1, op2)

	#Subroutines

	elseif instruction == "20"
		op1 = constant_operand(state, 3,5)
		call(state, op1)

	elseif instruction == "30"
		op1 = constant_operand(state, 3,5)
		callZ(state, op1)

	elseif instruction == "34"
		op1 = constant_operand(state, 3,5)
		callNZ(state, op1)

	elseif instruction == "38"
		op1 = constant_operand(state, 3,5)
		callC(state, op1)

	elseif instruction == "3C"
		op1 = constant_operand(state, 3,5)
		callNC(state, op1)

	elseif instruction == "24"
		op1 = register_operand(state, 3)
		op2 = register_operand(state, 4)
		callat(state, op1, op2)

	elseif instruction == "25"
		Return(state)

	elseif instruction == "31"
		ReturnZ(state)

	elseif instruction == "35"
		ReturnNZ(state)

	elseif instruction == "39"
		ReturnC(state)

	elseif instruction == "3D"
		ReturnNC(state)

	elseif instruction == "21"
		op1 = register_operand(state, 3)
		op2 = constant_operand(state, 4,5)
		Load_and_Return(state, op1, op2)
	else
		println("Instruction not valid")
	end
end

function constant_operand(state, open, close)
	#function takes the constant value from an opcode and returns it as a decimal
	string = state.program_memory[state.program_counter][open:close]

	return parse(Int, string, 16)
end

function register_operand(state, position)
	#function takes the register number from an opcode and returns it as a decimal
	operand = state.program_memory[state.program_counter][position]
	operand = parse(Int, operand, 16)
	return operand + 1
end
