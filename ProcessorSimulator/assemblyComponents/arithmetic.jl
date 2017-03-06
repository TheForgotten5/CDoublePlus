#Description: Addition of 8-bit integers
#add sX kk
function addc(state, register, value)
		sum = (state.regbank == 0 ? state.register_a[register] : state.register_b[register]) + value
		if sum > 255
			state.carry_flag = 1
			sum -= 256
		else
			state.carry_flag = 0
		end
		state.zero_flag = sum == 0 ? 1 : 0
		if state.regbank == 0
			state.register_a[register] = sum
		else
			state.register_b[register] = sum
		end
end

#add sX sY
function addr(state, registerx, registery)
		addc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end

#ADDCY sX kk
function addcyc(state, register, value)
	sum = (state.regbank == 0 ? state.register_a[register] : state.register_b[register]) + value
	sum += state.carry_flag
	if sum > 255
		state.carry_flag = 1
		sum -= 256
	else
		state.carry_flag = 0
	end
	state.zero_flag = sum == 0 && state.zero_flag == 1 ? 1 : 0
	if state.regbank == 0
		state.register_a[register] = sum
	else
		state.register_b[register] = sum
	end
end

#ADDCY sX sY
function addcyr(state, registerx, registery)
	addcyc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end

#Subtraction
function subc(state, register, value)
	dif = (state.regbank == 0 ? state.register_a[register] : state.register_b[register]) - value
	if dif < 0
		state.carry_flag = 1
		dif += 256
	else
		state.carry_flag = 0
	end
	state.zero_flag = dif == 0? 1 : 0
	if state.regbank == 0
		state.register_a[register] = dif
	else
		state.register_b[register] = dif
	end
end

#sub sX sY
function subr(state, registerx, registery)
	subc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end

#subCY sX kk
function subcyc(state, register, value)
	dif = (state.regbank == 0 ? state.register_a[register] : state.register_b[register]) - value
	dif -= state.carry_flag
	if dif < 0
		state.carry_flag = 1
		dif += 256
	else
		state.carry_flag = 0
	end
	state.zero_flag = dif == 0 && state.zero_flag == 1 ? 1 : 0
	if state.regbank == 0
		state.register_a[register] = dif
	else
		state.register_b[register] = dif
	end
end

#subCY sX sY
function subcyr(state, registerx, registery)
	subcyc(state, registerx, state.regbank == 0 ? state.register_a[registery] : state.register_b[registery])
end
