#Description: Loads a value into a register.

#LOAD sX, kk
function loadc(state, register, value)
		
		if state.regbank == 0
			state.register_a[register] = value
		else
			state.register_b[register] = value
		end
end

#LOAD sX, sY
function loadr(state, registerx, registery)
	if state.regbank == 0
		state.register_a[registerx] = state.register_a[registery]
	else
		state.register_b[registerx] = state.register_b[registery]
	end
end

#Description: Loads an active register into inactive register

#STAR sX, kk
function star(state, register, value)
		if state.regbank == 0
			state.register_b[register] = value
		else
			state.register_a[register] = value
		end
end

#STAR sX, sY
function starr(state, registerx, registery)
	if state.regbank == 0
		state.register_b[registerx] = state.register_a[registery]
	else
		state.register_a[registerx] = state.register_b[registery]
	end
end
