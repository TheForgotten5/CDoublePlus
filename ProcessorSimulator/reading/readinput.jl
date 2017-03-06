filename = ARGS[1]
type label
  name
  address
end

program_memory = Array{ASCIIString}(0)


f = open(filename, "r")
labels = Array{label}(0)

function convertLabel(labels, label)
  #labels is array of labels
  #label is the number we want
  for item in labels
    if item.name == label
      r = hex(item.address)
      while length(r) < 3
        r = "0$r"
      end
      return r
    end
  end
  return "LABEL NOT MATCHED"
end
linenum = 0
lines = readlines(f)
#read labels
linenum = 0
for line in lines
  linenum += 1
  if contains(line, ":")
    push!(labels, label(line[1:search(line, ':')-1], linenum))
    lines[linenum] = line[search(line, ':') + 2: length(line)]
  end
  # println(lines[linenum])
end

function tohex(string)
  string = parse(Int, string)
  string = hex(string)
  string = length(string) == 1 ? "0$string" : string
end


for line in lines
  line = chomp(line)
  instruction = line[1:search(line,' ')-1]
  if !contains(line, " ")
    instruction = line
  end
  if contains(line, ",")
    arg1 = line[search(line, ' ')+1:search(line, ',')-1]
    arg2 = line[search(line, ',')+1 + 1:endof(line)]
  else
    arg1 = line[search(line, ' ')+1:endof(line)]
    arg2 = ""
  end
  opcode = ""
  #println("""a="$instruction" b="$arg1" c="$arg2" """)
  #println(instruction)
  if instruction == "LOAD"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("00", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("01", r1, tohex(arg2))
    end
    #println(opcode)
    push!(program_memory, opcode)

  elseif instruction == "STAR"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("16", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("17", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "AND"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("02", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("03", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "OR"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("04", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("05", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "XOR"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("06", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("07", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "ADD"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("10", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("11", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "ADDCY"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("12", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("13", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "SUB"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("18", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("19", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "SUBCY"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("1A", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("1B", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "TEST"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("0C", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("0D", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "TESTCY"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("0E", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("0F", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "COMPARE"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("1C", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("1D", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "COMPARECY"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("1E", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("1F", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "INPUT"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[3]
      opcode = string("08", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("09", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "OUTPUT"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[3]
      opcode = string("2C", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("2D", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "STORE"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[3]
      opcode = string("2E", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("2F", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

  elseif instruction == "FETCH"
    if contains(arg2, "s")
      r1 = arg1[2]
      r2 = arg2[3]
      opcode = string("0A", r1, r2, "0")
    else
      r1 = arg1[2]
      opcode = string("0B", r1, tohex(arg2))
    end
    push!(program_memory, opcode)

#--------

  elseif instruction == "SL0"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "06")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SL1"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "07")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SLX"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "04")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SLA"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "00")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "RL"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "02")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SR0"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "0E")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SR1"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "0F")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SRX"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "0A")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "SRA"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "08")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

  elseif instruction == "RR"
    if contains(arg1, "s")
      r1 = arg1[2]
      opcode = string("14", r1, "0C")
    else
      println("Expecting a register, value inputted instead.")
    end
    push!(program_memory, opcode)

#-------

  elseif instruction == "REGBANK"
    if arg1 == "A"
			opcode = "37000"
    	push!(program_memory, opcode)
    elseif arg1 == "B"
      opcode = "37001"
	    push!(program_memory, opcode)
    else
			println("Invalid register bank, please try again.")
		end

  elseif instruction == "OUTPUTK"
    if !contains(arg2, "s")
      opcode = string("2B", tohex(arg1), arg2)
    	push!(program_memory, opcode)
    else
			println("Expecting values, register inputted instead.")
    end

  elseif instruction == "JUMP"
    if arg1 == "Z"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("32", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("32", address)
      end
    elseif arg1 == "NZ"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("36", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("36", address)
      end
    elseif arg1 == "C"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("3A", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("3A", address)
      end
    elseif arg1 == "NC"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("3E", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("3E", address)
      end
    else
      opcode = string("22", convertLabel(labels, arg1))
    end

    push!(program_memory, opcode)

  elseif instruction == "CALL"
    if arg1 == "Z"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("30", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("30", address)
      end
    elseif arg1 == "NZ"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("34", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("34", address)
      end
    elseif arg1 == "C"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("38", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("38", address)
      end
    elseif arg1 == "NC"
      address = tryparse(Int, arg2)
      if isnull(address)
        opcode = string("3C", convertLabel(labels, arg2))
      else
        address = get(address)
        address = hex(address)
        while length(address < 3)
          address = "0$address"
        end
        opcode = string("3C", address)
      end
    else
      opcode = string("22", convertLabel(labels, arg1))
    end

    push!(program_memory, opcode)

  elseif instruction == "JUMP@"
    if contains(arg1, "s") && contains(arg2, "s")
      r1 = arg1[3]
      r2 = arg2[2]
      opcode = string("26", r1, r2, "0")
		else
			println("Error: Expecting two registers.")
    end
    push!(program_memory, opcode)

  elseif instruction == "CALL@"
    if contains(arg1, "s") && contains(arg2, "s")
      r1 = arg1[3]
      r2 = arg2[2]
      opcode = string("24", r1, r2, "0")
		else
			println("Error: Expecting two registers.")
    end
    push!(program_memory, opcode)

  elseif instruction == "RETURN"
    if arg1 == "Z"
      opcode = string("31000")
    elseif arg1 == "NZ"
      opcode = string("35000")
    elseif arg1 == "C"
      opcode = string("39000")
    elseif arg1 == "NC"
      opcode = string("3D000")
		else
			opcode = string("25000")
    end
    push!(program_memory, opcode)

  elseif instruction == "LOAD&RETURN"
      r1 = arg1[2]
      r2 = arg2[2]
      opcode = string("21", r1, r2)
    push!(program_memory, opcode)

  elseif instruction == "HWBUILD"
      r1 = arg1[2]
      opcode = string("14", r1, "80")
    push!(program_memory, opcode)

  end
  #println(opcode)
  #println(program_memory)
end
