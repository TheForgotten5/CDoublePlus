#
#LEFT SHIFT
#
#Description: Shifts left, adds 0 at end.
function SL0(state, register)
  #read the register
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #transform into binary string
  value = bin(value)
  #append 0s
  while length(value) < 8
    value = "0$value"
  end
  #set the Carry Flag!
  state.carry_flag = parse(Int, value[1], 2)

  #perform the shift
  value = string(value[2:8], "0")

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

#Description: Shifts left, adds 1 at end.
function SL1(state, register)
  #read the register
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #transform into binary string
  value = bin(value)
  #append 0s
  while length(value) < 8
    value = "0$value"
  end
  #set the Carry Flag!
  state.carry_flag = parse(Int, value[1], 2)

  #perform the shift
  value = string(value[2:8], "1")

  #parse to integer
  value = parse(UInt8, value, 2)

  state.zero_flag = 0

  #save to register
  if state.regbank == 0
    state.register_a[register] = value
  else
    state.register_b[register] = value
  end
end

#Description: Replicates state of least sig. byte to the end.
function SLX(state, register)
  #read the register
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #transform into binary string
  value = bin(value)
  #append 0s
  while length(value) < 8
    value = "0$value"
  end
  #set the Carry Flag!
  state.carry_flag = parse(Int, value[1], 2)

  #perform the shift
  value = string(value[2:8], value[8])

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

#Description: Takes the previous state of C flag and replicates
#at the end.
function SLA(state, register)
  #read the register
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  #transform into binary string
  value = bin(value)
  #append 0s
  while length(value) < 8
    value = "0$value"
  end

	tempVar = state.carry_flag
  #set the Carry Flag!
  state.carry_flag = parse(Int, value[1], 2)

  #perform the shift
  value = string(value[2:8], "$tempVar")

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
