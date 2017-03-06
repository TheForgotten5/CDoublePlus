#initalize variables
type cpu
  carry_flag
  zero_flag
  program_counter
  program_memory
  stack_pointer
  stack_memory
  scratchpad
  regbank
  register_a
  register_b
end
  state = cpu(
  0,                    #carry_flag
  0,                    #zero_flag
  0,                    #program_counter
  Array{ASCIIString}(0),  #program_memory -> 5 digit hex
  0,                    #stack_pointer
  zeros(UInt8,0),       #stack_memory
  zeros(UInt8,256),      #scratchpad
  0,                    #regbank
  zeros(UInt8,16),       #register_a
  zeros(UInt8,16)        #register_b
  )
  #println(state) #should be all zeros
  #=
  state.carry_flag = 0
  state.zero_flag = 0
  state.program_counter = 0
  state.program_memory = zeros(Int8,2048,3)
  state.stack_pointer = 0
  state.stack_memory = zeros(Int8,30)
  state.scratchpad = zeros(Int8, 256)
  state.regbank = 0 #0 for register_a, 1 for register_b
  state.register_a = zeros(Int8, 16)
  state.register_b = zeros(Int8, 16)
=#
  include("assemblyComponents/assembly.jl")

  #EXIT CONDITON -- If we have the same program_counter for the last 10 iterations of the loop exit
  include("reading/readmem.jl")
  include("reading/readinput.jl")
  #println("this is the program memory\n", program_memory)



  lastpc = 0
  iteration = 0
  state.program_memory = program_memory
#TO DO: Implement instructon read routine.
  #read instructions from the input file also figure out constants and labels
  #include("readmem.jl")
  #function to figure out what the instruction is and execute it

#main loop

while true

    #Increment the program counter
    state.program_counter += 1
    #so we don't read outside of the program_memory
    if state.program_counter > length(state.program_memory)
      break
    end
    #Read the instruction at the line we are working with
    #println(state.program_memory[state.program_counter])
    #println(state.program_counter)
    read_instruction(state)
    #exit condition
    if lastpc == state.program_counter
      iteration += 1
      if iteration == 10
        break;
      end
    else
      lastpc = state.program_counter
      iteration = 0
    end
    if state.program_counter > length(state.program_memory)
      break
    end
  end

#test area?
num = parse(Int, "11111111", 2)
#=
loadc(state, 4, num)
loadr(state, 5, 4)
outputk(state, 128, 15)
println(state.carry_flag)
println(state.zero_flag)
println(state.register_a[4])
SR0(state, 4)
println(state.register_a[4])
SR1(state, 4)
println(state.register_a[4])
SRX(state, 4)
println(state.register_a[4])
SRA(state, 4)
println(state.register_a[4])
testr(state, 4, 5)
println(state.carry_flag)
println(state.zero_flag)
comparer(state, 4, 5)
println(state.carry_flag)
println(state.zero_flag)
outputk(state, 4, 12)
println(state.register_a[5])
=#
