#
#RIGHT SHIFT
#
#Description: Shifts right, adds 0 at beginning.
function SR0(state, register)
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
  state.carry_flag = parse(Int, value[8], 2)

  #perform the shift
  value = string("0", value[1:7])

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

#Description: Shifts right, adds 1 at beginning.
function SR1(state, register)
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
  state.carry_flag = parse(Int, value[8], 2)

  #perform the shift
  value = string("1", value[1:7])

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

#Description: Replicates state of most sig. byte to the beginning.
function SRX(state, register)
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
  state.carry_flag = parse(Int, value[8], 2)

  #perform the shift
  value = string(value[1], value[1:7])

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
#at the beginning.
function SRA(state, register)
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
  state.carry_flag = parse(Int, value[8], 2)

  #perform the shift
  value = string("$tempVar", value[1:7])

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
