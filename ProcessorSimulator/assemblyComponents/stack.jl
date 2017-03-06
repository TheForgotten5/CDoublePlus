#this file contains jump, call, return, store and fetch functions

#jump functions

function jump(state, address)
  state.program_counter = address - 1
end

function jumpZ(state, address)
  if state.zero_flag == 1
    state.program_counter = address - 1
  end
end

function jumpNZ(state, address)
  if state.zero_flag == 0
    state.program_counter = address - 1
  end
end

function jumpC(state, address)
  if state.carry_flag == 1
    state.program_counter = address - 1
  end
end

function jumpNC(state, address)
  if state.carry_flag == 0
    state.program_counter = address - 1
  end
end

function jumpat(state, x, y)
  #x uses lower 4 bits
  #y uses all bits
  #needs fix because 12 bit addresses so you need to read 2 registers and concatenate them
  upper = state.regbank == 0 ? state.register_a[x] : state.register_b[x]
  lower = state.regbank == 0 ? state.register_a[y] : state.register_b[y]
  upper = hex(upper)
  upper = length(upper) == 1 ? upper : upper[2]
  address = string(upper, hex(lower))
  address = parse(Int, address, 16)
  jump(state, address)
end


#call functions

function call(state, address)
  push!(state.stack_memory, state.program_counter)
  state.program_counter = address - 1
end

function callZ(state, address)
  if state.zero_flag == 1
    push!(state.stack_memory, state.program_counter)
    state.program_counter = address - 1
  end
end

function callNZ(state, address)
  if state.zero_flag == 0
    push!(state.stack_memory, state.program_counter)
    state.program_counter = address - 1
  end
end

function callC(state, address)
  if state.carry_flag == 1
    push!(state.stack_memory, state.program_counter)
    state.program_counter = address - 1
  end
end

function callNC(state, address)
  if state.carry_flag == 0
    push!(state.stack_memory, state.program_counter)
    state.program_counter = address - 1
  end
end

function callat(state, x, y)
#needs fix because 12 bit addresses so you need to read 2 registers and concatenate them
  upper = state.regbank == 0 ? state.register_a[x] : state.register_b[x]
  lower = state.regbank == 0 ? state.register_a[y] : state.register_b[y]
  upper = hex(upper)
  upper = length(upper) == 1 ? upper : upper[2]
  address = string(upper, hex(lower))
  address = parse(Int, address, 16)
  call(state, address)

end

#return functions

function Return(state)
    state.program_counter = pop!(state.stack_memory)
end

function ReturnZ(state)
  if state.zero_flag == 1
    state.program_counter = pop!(state.stack_memory)
  end
end

function ReturnNZ(state)
  if state.zero_flag == 0
    state.program_counter = pop!(state.stack_memory)
  end
end

function ReturnC(state)
  if state.carry_flag == 1
    state.program_counter = pop!(state.stack_memory)
  end
end

function ReturnNC(state)
  if state.carry_flag == 0
    state.program_counter = pop!(state.stack_memory)
  end
end

function Load_and_Return(state, value, register)
  if state.regbank == 0
    state.register_a[register] = value
  else
    state.register_b[register] = value
  end
  Return(state)
end

#scratchpad functions

function store(state, value, location)
  local ss #scratchpad location
  if state.regbank == 0
    ss = state.register_a[location]
  else
    ss = state.register_b[location]
  end
  state.scratchpad[ss+1] = value
end

function storess(state, value, ss)
  state.scratchpad[ss+1] = value
end

function fetch(state, register, location)
  if state.regbank == 0
    state.register_a[register] = state.scratchpad[state.register_a[location]+1]
  else
    state.register_b[register] = state.scratchpad[state.register_b[location]+1]
  end
end

function fetchss(state, register, ss)
  if state.regbank == 0
    state.register_a[register] = state.scratchpad[ss+1]
  else
    state.register_b[register] = state.scratchpad[ss+1]
  end
end
