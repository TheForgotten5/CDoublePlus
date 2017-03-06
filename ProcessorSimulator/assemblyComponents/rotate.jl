function RL(state, register)
  #pull out our value
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #change to binary string
  value = bin(value)

  #append 0s
  while length(value) < 8
    value = "0$value"
  end

  #set the Carry Flag!
  state.carry_flag = parse(Int, value[1], 2)

  value = string(value[2:8], state.carry_flag)

  #parse to integer
  value = parse(UInt8, value, 2)
  #if value is zero set zero_flag
  if value == 0
    state.zero_flag = 0
  end
  #save to register
  if state.regbank == 0
    state.register_a[register] = value
  else
    state.register_b[register] = value
  end
end

function RR(state, register)
  #pull out our value
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #change to binary string
  value = bin(value)

  #append 0s
  while length(value) < 8
    value = "0$value"
  end

  #set the Carry Flag!
  state.carry_flag = parse(Int, value[8], 2)

  value = string(state.carry_flag,value[1:7])

  #parse to integer
  value = parse(UInt8, value, 2)
  #if value is zero set zero_flag
  if value == 0
    state.zero_flag = 0
  end
  #save to register
  if state.regbank == 0
    state.register_a[register] = value
  else
    state.register_b[register] = value
  end
end
