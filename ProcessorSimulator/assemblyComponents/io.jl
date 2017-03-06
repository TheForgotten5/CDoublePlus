function inputr(state, registerx, registery)
  #where we take a register for the port number
  #but actually don't give a shit
  input(state, registerx, 0)
end


function input(state,register, port)
  #read from stdin
  value = parse(UInt8, chomp(readline()))

  #write to register
  if state.regbank == 0
    state.register_a[register] = value
  else
    state.register_b[register] = value
  end
end

function outputr(state, registerx, registery)
  if state.regbank == 0
    output(state, registerx, state.register_a[registery])
  else
    output(state, registerx, state.register_b[registery])
  end
end


function output(state, register, port)
  if state.regbank == 0
    value = state.register_a[register]
  else
    value = state.register_b[register]
  end
  port = hex(port)
  port = length(port) == 1 ? "0$port" : port
  value = hex(value)
  value = length(value) == 1 ? "0$value" : value
  println(string(port, " ", value))
end

function outputk(state, value, port)
  value = hex(value)
  value = length(value) == 1 ? "0$value" : value
  println(string("0", hex(port), " ", value))
end

function hwbuild(state, register)
  loadc(state, register, 0)
  state.zero_flag = 1
  state.carry_flag = 1
end
