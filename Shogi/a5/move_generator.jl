using SQLite
#included in shogi.jl

type location
  row::Int
  column::Int
  row2::Int
  column2::Int
  row3::Int
  column3::Int
end

function location(row, col)
  return location(row, col, 0, 0)
end

function location(row, col, row2, col2)
  return location(row, col, row2, col2, 0, 0)
end

type move
  sourcex::Int
  sourcey::Int
  location::location
  promote::Bool
end

type drop
  targetx::Int
  targety::Int
  piece::String
end

type sim
  move #of type drop or move
  game::shogi
  points::Int
end

function move(game, player, m::move)
  move_move(game, m.sourcex, m.sourcey, m.location.column, m.location.row, m.promote, player, m.location.column2, m.location.row2, m.location.column3, m.location.row3)

end

function gamepoints(game::shogi)
  #returns a points allocation based on which side has the advantage
  #returns 0 for a balanced game, and a negative number if white has advantage, or a positive number if black has advantage
  #each piece black has is worth triple in the cap area
  data = fetchpieces(game.gametype)
  points = 0
  for p in game.cap_black
    points += fetchvalue(data, p, 4) * 3
  end

  for p in game.cap_white
    points -= fetchvalue(data, p, 4) * 3
  end

  #for each piece on the board, see what pieces are available to take and add the value of that piece if it is being threatened
  #so if a pawn can take a promoted bishop, add the value of the promoted bishop
  #O(n^4)
  #also a piece is worth its value if it is somewhere on the board

  for row in 1:game.boardrows
    for col in 1:game.boardcols
      p = game.board[row, col]
      if p == "." || p == "..."
        continue
      end
      value = fetchvalue(data, p[2:2], 4)
      if in_danger(game, col, row, p[1:1])
        points += p[1:1] == "b" ? value * (-1) : value
      end
      points += p[1:1] == "b" ? value : value * (-1)
    end
  end
  return points
end

function toMoves(sx, sy, locations)
  #println(locations)4
  a = Array{move}(0)
  for l in locations
    #println(l)
    m = move(sx, sy, l, false)
    push!(a, m)
  end
  return a
end

function pick(sims::Array{sim})
  if length(sims) == 0
    return "resign"
  end
  least = sims[1].points
  for s in sims
    if s.points < least
      least = s.points
    end
  end
  #println("least is $least")
  total = 0
  scale = rand(4200:13370)
  #println("scale is $scale")
  for s in sims
    total += (s.points - least + 1) * scale
  end
  #println("total is $total")
  r = rand(0:total)
  i = 0
  for s in sims
    i += (s.points - least + 1)* scale
    #println("compare i $i with r $r")
    if i >= r
      #println("returned something")
      return s
    end
  end
end

function pickbest(sims::Array{sim})
  if length(sims) == 0
    return "resign"
  end
  best = sims[1]
  for s in sims
    if s.points > best.points
      best = s
    end
  end
  return best
end

function ai(game::shogi, player::String)
  moves = Array{move}(0)
  #collect all options
  for row in 1:game.boardrows
    for col in 1:game.boardcols
      n = toMoves(col, row, generator(game, col, row, player))
      for m in n
        if m.location.row <= 0 || m.location.column <= 0 || m.location.row > game.boardrows || m.location.column > game.boardcols
          #println("row $row, col $col, piece $(game.board[row, col])")
          continue
        end
        if valid_promote(game, col, row, m.location.column, m.location.row, player)
          push!(moves, move(m.sourcex, m.sourcey, m.location, true))
        end
        push!(moves, m)
      end
    end
  end
  sims = Array{sim}(0)
  #collect drop options
  if game.gametype != "chushogi"
    droppable = player == "w" ? game.cap_white : game.cap_black
    for col in 1:game.boardcols
      for row in 1:game.boardrows
        for p in droppable
          if valid_drop(game, col, row, player, p)
            #print(piece)
            #drop it
            #println("trying to drop $piece at $col, $row")
            clone = copygame(game)
            move_drop(clone, col, row, p, player)
            if in_danger(game, col, row, player)
              continue
            end
            if is_check(clone, player)
              continue
            end
            points = gamepoints(clone)
            if player == "w"
              points *= -1
            end
            push!(sims, sim(drop(col, row, p), clone, points))
          end
        end
      end
    end
  end
  #now moves has all possible moves
  #generate a sim for each move

  #println(length(moves))
  for m in moves
    clone = copygame(game)
    move_move(clone, m.sourcex, m.sourcey, m.location.column, m.location.row, false, player, m.location.column2, m.location.row2)
    if is_check(clone, player)
      continue
    end
    points = gamepoints(clone)
    if player == "w"
      points *= -1
    end
    push!(sims, sim(m, clone, points))
  end
  #println(length(sims))
  p = pick(sims)
  return p
end


#thomas's code from here onwards



function generator(game::shogi, piecex::Int, piecey::Int, player::String)
  #function will return an array of Locations, a type with column, the x location, and row, the y location. The array will consist of valid locations a piece could move to. If a piece only has one move, row2 and column2 will be set to 0



  move_array = Array{location}(0)
  if game.board[piecey, piecex] == "." || game.board[piecey,piecex] == "..."
    return move_array
  end

  p = game.board[piecey, piecex][2:2]

  if game.gametype == "standard" || game.gametype == "minishogi"
    if p == "p" #Pawn Move
      return pawn_generator(game, piecex, piecey, player, move_array)

    elseif p == "k" #King Move
      return king_generator(game, piecex, piecey, player, move_array)

    elseif p == "r" #Rook Move
      return rook_generator(game, piecex, piecey, player, move_array)

    elseif p == "b" #Bishop Move
      return bishop_generator(game, piecex, piecey, player, move_array)

    elseif p == "g" #Gold General Move
      return gold_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "s" #Silver General Move
      return silver_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "n" #Knight Move
      return knight_generator(game, piecex, piecey, player, move_array)

    elseif p == "l" #Lance Move
      return lance_generator(game, piecex, piecey, player, move_array)

    elseif p == "R" #Dragon King Move
      return dragon_king_generator(game, piecex, piecey, player, move_array)

    elseif p == "B" #Dragon Horse Move
      return dragon_horse_generator(game, piecex, piecey, player, move_array)

    else #Gold General Move
      return gold_general_generator(game, piecex, piecey, player, move_array)
    end

  elseif game.gametype == "chushogi"
    if p == "a" # Reverse Chariot Move
      return reverse_chariot_generator(game, piecex, piecey, player, move_array)

    elseif p == "A" #Whale Move
      return whale_generator(game, piecex, piecey, player, move_array)

    elseif p == "b" #Bishop Move
      return bishop_generator(game, piecex, piecey, player, move_array)

    elseif p == "B" #Dragon Horse Move
      return dragon_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "c" #Copper General Move
      return copper_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "C" #Side Mover Move
      return side_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "d" #Dragon King Move
      return dragon_king_generator(game, piecex, piecey, player, move_array)

    elseif p == "D" #Soaring Eagle Move
     return soaring_eagle_generator(game, piecex, piecey, player, move_array)

    elseif p == "e" #Drunk Elephant
      return drunk_elephant_generator(game, piecex, piecey, player, move_array)

    elseif p == "E" #Prince
      return king_generator(game, piecex, piecey, player, move_array)

    elseif p == "f" #Ferocious Leopard
      return ferocious_leopard_generator(game, piecex, piecey, player, move_array)

    elseif p == "F" #Bishop
      return bishop_generator(game, piecex, piecey, player, move_array)

    elseif p == "g" #Gold General
      return gold_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "G" #Rook
      return rook_generator(game, piecex, piecey, player, move_array)

    elseif p == "h" #Dragon Horse
      return dragon_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "H" #Horned Falcon
      return horned_falcon_generator(game, piecex, piecey, player, move_array)

    elseif p == "i" #Lion Move why must you torment me so
      return lion_generator(game, piecex, piecey, player, move_array)

    elseif p == "k" #king
      return king_generator(game, piecex, piecey, player, move_array)

    elseif p == "l" #lance move
      return lance_generator(game, piecex, piecey, player, move_array)

    elseif p == "L" #White Horse Move
      return white_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "m" #Side Mover
      return side_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "M" #Free Boar
      return free_boar_generator(game, piecex, piecey, player, move_array)

    elseif p == "n" #Kirin Move
      return kirin_generator(game, piecex, piecey, player, move_array)

    elseif p == "N" #Lion
      return lion_generator(game, piecex, piecey, player, move_array)

    elseif p == "o"
      return go_between_generator(game, piecex, piecey, player, move_array)

    elseif p == "O" #Drunk Elephant
      return drunk_elephant_generator(game, piecex, piecey, player, move_array)

    elseif p == "p"
      return pawn_generator(game, piecex, piecey, player, move_array)

    elseif p == "P" #Drunk Elephant
      return gold_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "r" #Rook
      return rook_generator(game, piecex, piecey, player, move_array)

    elseif p == "R" #Dragon King
      return dragon_king_generator(game, piecex, piecey, player, move_array)

    elseif p == "s" #Silver General
      return silver_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "S" #Vertical Mover
      return vertical_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "t" #Blind Tiger
      return blind_tiger_generator(game, piecex, piecey, player, move_array)

    elseif p == "T" #Flying Stag
      return flying_stag_generator(game, piecex, piecey, player, move_array)

    elseif p == "q" #Queen
      return queen_generator(game, piecex, piecey, player, move_array)

    elseif p == "v" #Vertical mover
      return vertical_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "V" #Flying Ox
      return flying_ox_generator(game, piecex, piecey, player, move_array)

    elseif p == "x" #Phoenix
      return phoenix_generator(game, piecex, piecey, player, move_array)

    elseif p == "X" #Queen
      return queen_generator(game, piecex, piecey, player, move_array)

    end
  elseif game.gametype == "tenjikushogi"
    p = game.board[piecey, piecex][2:3]

    if p == "b."
      return bishop_generator(game, piecex, piecey, player, move_array)

    elseif p == "B."
      return dragon_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "bg"
      return bishop_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "BG"
      return vice_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "bt"
       return blind_tiger_generator(game, piecex, piecey, player, move_array)

    elseif p == "BT"
      return flying_stag_generator(game, piecex, piecey, player, move_array)

    elseif p == "c."
       return copper_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "C."
      return side_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "cs"
      return chariot_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "CS"
      return heavenly_tetrarch_generator(game, piecex, piecey, player, move_array)

    elseif p == "d."
      return dog_generator(game, piecex, piecey, player, move_array)

    elseif p == "D."
      return multi_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "de"
      return drunk_elephant_generator(game, piecex, piecey, player, move_array)

    elseif p == "DE"
      return king_generator(game, piecex, piecey, player, move_array)

    elseif p == "dh"
      return dragon_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "DH"
      return horned_falcon_generator(game, piecex, piecey, player, move_array)

    elseif p == "dk"
      return dragon_king_generator(game, piecex, piecey, player, move_array)

    elseif p == "DK"
      return soaring_eagle_generator(game, piecex, piecey, player, move_array)

    elseif p == "fd"
      return fire_demon_generator(game, piecex, piecey, player, move_array)

    elseif p == "fe"
      return free_eagle_generator(game, piecex, piecey, player, move_array)

    elseif p == "fl"
      return ferocious_leopard_generator(game, piecex, piecey, player, move_array)

    elseif p == "FL"
      return bishop_generator(game, piecex, piecey, player, move_array)

    elseif p == "g."
      return gold_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "G."
      return rook_generator(game, piecex, piecey, player, move_array)

    elseif p == "gg"
      return great_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "hf"
      return horned_falcon_generator(game, piecex, piecey, player, move_array)

    elseif p == "HF"
      return bishop_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "i."
      return iron_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "I."
      return vertical_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "k."
      return king_generator(game, piecex, piecey, player, move_array)

    elseif p == "kr"
      return kirin_generator(game, piecex, piecey, player, move_array)

    elseif p == "KR"
      return lion_generator(game, piecex, piecey, player, move_array)

    elseif p == "l."
      return lance_generator(game, piecex, piecey, player, move_array)

    elseif p == "L."
      return white_horse_generator(game, piecex, piecey, player, move_array)

    elseif p == "lh"
      return lion_hawk_generator(game, piecex, piecey, player, move_array)

    elseif p == "ln"
      return lion_generator(game, piecex, piecey, player, move_array)

    elseif p == "LN"
      return lion_hawk_generator(game, piecex, piecey, player, move_array)

    elseif p == "n."
      return knight_generator(game, piecex, piecey, player, move_array)

    elseif p == "N."
      return side_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "p."
      return pawn_generator(game, piecex, piecey, player, move_array)

    elseif p == "P."
      return gold_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "ph"
      return phoenix_generator(game, piecex, piecey, player, move_array)

    elseif p == "PH"
      return queen_generator(game, piecex, piecey, player, move_array)

    elseif p == "q."
      return queen_generator(game, piecex, piecey, player, move_array)

    elseif p == "Q."
      return free_eagle_generator(game, piecex, piecey, player, move_array)

    elseif p == "r."
      return rook_generator(game, piecex, piecey, player, move_array)

    elseif p == "R."
      return dragon_king_generator(game, piecex, piecey, player, move_array)

    elseif p == "rc"
      return reverse_chariot_generator(game, piecex, piecey, player, move_array)

    elseif p == "RC"
      return whale_generator(game, piecex, piecey, player, move_array)

    elseif p == "rg"
      return rook_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "RG"
      return great_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "s."
      return silver_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "S."
      return vertical_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "se"
      return soaring_eagle_generator(game, piecex, piecey, player, move_array)

    elseif p == "SE"
      return rook_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "sm"
      return side_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "SM"
      return free_boar_generator(game, piecex, piecey, player, move_array)

    elseif p == "ss"
      return side_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "SS"
      return water_buffalo_generator(game, piecex, piecey, player, move_array)

    elseif p == "vg"
      return vice_general_generator(game, piecex, piecey, player, move_array)

    elseif p == "vm"
      return vertical_mover_generator(game, piecex, piecey, player, move_array)

    elseif p == "VM"
      return flying_ox_generator(game, piecex, piecey, player, move_array)

    elseif p == "vs"
      return vertical_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "VS"
      return chariot_soldier_generator(game, piecex, piecey, player, move_array)

    elseif p == "wb"
      return water_buffalo_generator(game, piecex, piecey, player, move_array)

    elseif p == "WB"
      return fire_demon_generator(game, piecex, piecey, player, move_array)
    end
  end
end

function pawn_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player =="b"
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey-1, piecex, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  else
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  end
end

function king_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for x in piecex-1:piecex+1
    for y in piecey-1:piecey+1
      if valid_move(game, piecex, piecey, x, y, player)
        spot = location(y, x, 0, 0)
        push!(move_array,spot)
      end
    end
  end
  return move_array
end

function rook_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function bishop_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function gold_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for x in piecex-1:piecex+1
      for y in piecey-1:piecey
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey+1, player)
      spot = location(piecey+1, piecex, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  else
    for x in piecex - 1:piecex + 1
      for y in piecey:piecey + 1
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey-1, player)
      spot = location(piecey-1, piecex, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  end
end

function silver_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for x in piecex-1:piecex+1
      if valid_move(game, piecex, piecey, x, piecey -1, player)
        spot = location(piecey -1, x, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex -1, piecey +1, player)
      spot = location(piecey +1, piecex -1, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex +1, piecey +1, player)
      spot = location(piecey +1, piecex +1, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  else
    for x in piecex-1:piecex+1
      if valid_move(game, piecex, piecey, x, piecey + 1, player)
        spot = location(piecey + 1, x, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex -1, piecey -1, player)
      spot = location(piecey - 1, piecex - 1, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex +1, piecey -1, player)
      spot = location(piecey -1, piecex +1, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  end
end

function knight_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 2, player)
      spot = location(piecey - 2, piecex + 1, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 2, player)
      spot = location(piecey - 2, piecex - 1, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  else
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 2, player)
      spot = location(piecey + 2, piecex + 1, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 2, player)
      spot = location(piecey + 2, piecex - 1, 0, 0)
      push!(move_array,spot)
    end
    return move_array
  end
end

function lance_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      else
        break
      end
    end
    return move_array
  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      else
        break
      end
    end
    return move_array
  end
end

function dragon_king_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player)
    spot = location(piecey + 1, piecex + 1, 0, 0)
    push!(move_array,spot)
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player)
    spot = location(piecey + 1, piecex - 1, 0, 0)
    push!(move_array,spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player)
    spot = location(piecey + 1, piecex - 1, 0, 0)
    push!(move_array,spot)
  end
  if valid_move(game, piecex, piecey, piecex -1, piecey - 1, player)
    spot = location(piecey - 1, piecex - 1, 0, 0)
    push!(move_array,spot)
  end
  return move_array
end

function dragon_horse_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
    spot = location(piecey -1, piecex, 0, 0)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
    spot = location(piecey +1, piecex, 0, 0)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey, player)
    spot = location(piecey, piecex - 1, 0, 0)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey, player)
    spot = location(piecey, piecex + 1, 0, 0)
    push!(move_array, spot)
  end
  return move_array
end

function reverse_chariot_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function whale_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    return move_array
  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    return move_array
  end
end

function copper_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for x in piecex-1:piecex+1
      if valid_move(game, piecex, piecey, x, piecey - 1, player)
        spot = location(piecey - 1, x, 0, 0)
        push!(move_array, spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey +1, piecex, 0, 0)
      push!(move_array, spot)
    end
    return move_array
  else
    for x in piecex-1:piecex+1
      if valid_move(game, piecex, piecey, x, piecey + 1, player)
        spot = location(piecey + 1, x, 0, 0)
        push!(move_array, spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex, 0, 0)
      push!(move_array, spot)
    end
    return move_array
  end
end

function side_mover_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
    spot = location(piecey +1, piecex, 0, 0)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
    spot = location(piecey -1, piecex, 0, 0)
    push!(move_array, spot)
  end
  return move_array
end

function soaring_eagle_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex + 2, piecey - 2, player)
      spot = location(piecey - 2, piecex + 2, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - 2, piecey - 2, player)
      spot = location(piecey - 2, piecex - 2, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player, piecex + 2, piecey - 2)
      spot = location(piecey - 1, piecex + 1, piecey - 2, piecex + 2)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player, piecex, piecey)
      spot = location(piecey - 1, piecex + 1, piecey, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player, piecex - 2, piecey - 2)
      spot = location(piecey - 1, piecex - 1, piecey - 2, piecex - 2)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player, piecex, piecey)
      spot = location(piecey - 1, piecex - 1, piecey, piecex)
      push!(move_array, spot)
    end
    return move_array

  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex + 2, piecey + 2, player)
      spot = location(piecey + 2, piecex + 2, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - 2, piecey + 2, player)
      spot = location(piecey + 2, piecex - 2, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player, piecex + 2, piecey + 2)
      spot = location(piecey + 1, piecex + 1, piecey + 2, piecex + 2)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player, piecex, piecey)
      spot = location(piecey + 1, piecex + 1, piecey, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player, piecex - 2, piecey + 2)
      spot = location(piecey + 1, piecex - 1, piecey + 2, piecex - 2)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player, piecex, piecey)
      spot = location(piecey + 1, piecex - 1, piecey, piecex)
      push!(move_array, spot)
    end
    return move_array
  end
end

function drunk_elephant_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for x in piecex-1:piecex+1
      for y in piecey-1:piecey
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player)
      spot = location(piecey + 1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player)
      spot = location(piecey + 1, piecex - 1)
      push!(move_array, spot)
    end
    return move_array

  else
    for x in piecex-1:piecex+1
      for y in piecey:piecey+1
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player)
      spot = location(piecey -1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player)
      spot = location(piecey -1, piecex - 1)
      push!(move_array, spot)
    end
    return move_array
  end
end

function ferocious_leopard_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for x in piecex-1:piecex+1
    if valid_move(game, piecex, piecey, x, piecey - 1, player)
      spot = location(piecey - 1, x, 0, 0)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, x, piecey + 1, player)
      spot = location(piecey + 1, x, 0, 0)
      push!(move_array, spot)
    end
  end
  return move_array
end

function horned_falcon_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 2, player)
      spot = location(piecey - 2, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey -1, player, piecex, piecey -2)
      spot = location(piecey - 1, piecex, piecey -2, piecex)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey -1, player, piecex, piecey)
      spot = location(piecey - 1, piecex, piecey, piecex)
      push!(move_array,spot)
    end
    return move_array

  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 2, player)
      spot = location(piecey + 2, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player, piecex, piecey +2)
      spot = location(piecey + 1, piecex, piecey + 2, piecex)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey +1, player, piecex, piecey)
      spot = location(piecey + 1, piecex, piecey, piecex)
      push!(move_array,spot)
    end
    return move_array
  end
end

function lion_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in -2:2
    for j in -2:2
      if valid_move(game, piecex, piecey, piecex + i, piecey + j, player)
        spot = location(piecey + j, piecex + i, 0, 0)
        push!(move_array, spot)
      end

      if abs(i) <= 1 && abs(j) <= 1
        for k in -1:1
          for m in -1:1
            if valid_move(game, piecex, piecey, piecex + i, piecey + j, player, piecex + i + k, piecey + j + m)
              spot = location(piecey + j, piecex + i, piecey + j + m, piecex + i + k)
              push!(move_array, spot)
            end
          end
        end
      end
    end
  end
  return move_array
end

function white_horse_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    return move_array
  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end
    return move_array
  end
end

function free_boar_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function kirin_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player)
    spot = location(piecey + 1, piecex + 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player)
    spot = location(piecey - 1, piecex + 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player)
    spot = location(piecey + 1, piecex - 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player)
    spot = location(piecey - 1, piecex - 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 2, piecey, player)
    spot = location(piecey, piecex + 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 2, piecey, player)
    spot = location(piecey, piecex - 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey + 2, player)
    spot = location(piecey + 2, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 2, player)
    spot = location(piecey - 2, piecex)
    push!(move_array, spot)
  end
  return move_array
end

function go_between_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
    spot = location(piecey + 1, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
    spot = location(piecey - 1, piecex)
    push!(move_array, spot)
  end
  return move_array
end

function vertical_mover_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey, player)
    spot = location(piecey, piecex + 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey, player)
    spot = location(piecey, piecex - 1)
    push!(move_array, spot)
  end
  return move_array
end

function blind_tiger_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for x in piecex-1:piecex+1
      for y in piecey:piecey+1
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player)
      spot = location(piecey -1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player)
      spot = location(piecey -1, piecex - 1)
      push!(move_array, spot)
    end
    return move_array

  else
    for x in piecex-1:piecex+1
      for y in piecey-1:piecey
        if valid_move(game, piecex, piecey, x, y, player)
          spot = location(y, x, 0, 0)
          push!(move_array,spot)
        end
      end
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player)
      spot = location(piecey + 1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player)
      spot = location(piecey + 1, piecex - 1)
      push!(move_array, spot)
    end
    return move_array
  end
end

function flying_stag_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardcols
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end

  for x in -1:2:1
    for y in -1:1
      if valid_move(game, piecex, piecey, piecex + x, piecey + y, player)
        spot = location(piecey + y, piecex + x)
        push!(move_array, spot)
      end
    end
  end
  return move_array
end

function queen_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function flying_ox_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function phoenix_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
    spot = location(piecey + 1, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
    spot = location(piecey - 1, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey, player)
    spot = location(piecey, piecex + 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey, player)
    spot = location(piecey, piecex - 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 2, piecey + 2, player)
    spot = location(piecey + 2, piecex + 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 2, piecey - 2, player)
    spot = location(piecey - 2, piecex + 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 2, piecey + 2, player)
    spot = location(piecey + 2, piecex - 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 2, piecey - 2, player)
    spot = location(piecey - 2, piecex - 2)
    push!(move_array, spot)
  end
  return move_array
end

function bishop_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function chariot_soldier_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end

  if valid_move(game, piecex, piecey, piecex + 1, piecey, player)
    spot = location(piecey, piecex + 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 2, piecey, player)
    spot = location(piecey, piecex + 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey, player)
    spot = location(piecey, piecex - 1)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 2, piecey, player)
    spot = location(piecey, piecex - 2)
    push!(move_array, spot)
  end
  return move_array
end

function dog_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey + 1, player)
      spot = location(piecey + 1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey + 1, player)
      spot = location(piecey + 1, piecex - 1)
      push!(move_array, spot)
    end
  else
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex + 1, piecey - 1, player)
      spot = location(piecey - 1, piecex + 1)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex - 1, piecey - 1, player)
      spot = location(piecey - 1, piecex - 1)
      push!(move_array, spot)
    end
  end
  return move_array
end


#Complexity of Triple Moves would be taxing to generate, but I can do it if necessary
function fire_demon_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end

  if valid_move(game, piecex, piecey, piecex, piecey - 1, player, piecex, piecey - 2, piecex, piecey - 3)
    spot = location(piecey-1, piecex, piecey-2, piecex, piecey-3, piecex)
    push!(move_array, spot)
  end

  if valid_move(game, piecex, piecey, piecex, piecey + 1, player, piecex, piecey + 2, piecex, piecey - 3)
    spot = location(piecey+1, piecex, piecey+2, piecex, piecey+3, piecex)
    push!(move_array, spot)
  end
  return move_array
end

function free_eagle_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end

  for a in -1:2:1
    for b in -1:2:1
      if valid_move(game, piecex, piecey, piecex+1, piecey+1, player, piecex+1+a, piecey+1+b)
        spot = location(piecey+1, piecex+1, piecey+1+b, piecex+1+a)
        push!(move_array, spot)
      end
      if valid_move(game, piecex, piecey, piecex+1, piecey-1, player, piecex+1+a, piecey-1+b)
        spot = location(piecey-1, piecex+1, piecey-1+b, piecex+1+a)
        push!(move_array, spot)
      end
      if valid_move(game, piecex, piecey, piecex-1, piecey-1, player, piecex-1+a, piecey-1+b)
        spot = location(piecey-1, piecex-1, piecey-1+b, piecex-1+a)
        push!(move_array, spot)
      end
      if valid_move(game, piecex, piecey, piecex-1, piecey+1, player, piecex-1+a, piecey+1+b)
        spot = location(piecey+1, piecex-1, piecey+1+b, piecex-1+a)
        push!(move_array, spot)
      end
    end
  end
  return move_array
end

function great_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function iron_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in -1:1
      if valid_move(game, piecex, piecey, piecex + i, piecey - 1, player)
        spot = location(piecey - 1, piecex + i)
        push!(move_array, spot)
      end
    end
  else
    for i in -1:1
      if valid_move(game, piecex, piecey, piecex + i, piecey + 1, player)
        spot = location(piecey + 1, piecex + i)
        push!(move_array, spot)
      end
    end
  end
  return move_array
end

function lion_hawk_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in -2:2
    for j in -2:2
      if valid_move(game, piecex, piecey, piecex + i, piecey + j, player)
        spot = location(piecey + j, piecex + i, 0, 0)
        push!(move_array, spot)
      end

      if abs(i) <= 1 && abs(j) <= 1
        for k in -1:1
          for m in -1:1
            if valid_move(game, piecex, piecey, piecex + i, piecey + j, player, piecex + i + k, piecey + j + m)
              spot = location(piecey + j, piecex + i, piecey + j + m, piecex + i + k)
              push!(move_array, spot)
            end
          end
        end
      end
    end
  end

  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function multi_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
        spot = location(piecey + i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
        spot = location(piecey + i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
    end
  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
        spot = location(piecey - i, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
        spot = location(piecey - i, piecex - i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
    end
  end
  return move_array
end

function rook_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  return move_array
end

function side_soldier_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end

    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 2, player)
      spot = location(piecey - 2, piecex)
      push!(move_array, spot)
    end
  else
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i, 0, 0)
        push!(move_array,spot)
      end
      if valid_move(game, piecex, piecey, piecex - i, piecey, player)
        spot = location(piecey, piecex - i, 0, 0)
        push!(move_array,spot)
      end
    end

    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex)
      push!(move_array, spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 2, player)
      spot = location(piecey + 2, piecex)
      push!(move_array, spot)
    end
  end

  return move_array
end

function vertical_soldier_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  if player == "b"
    for i in -2:2
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i)
        push!(move_array, spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey + 1, player)
      spot = location(piecey + 1, piecex)
      push!(move_array, spot)
    end
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey - i, player)
        spot = location(piecey - i, piecex, 0, 0)
        push!(move_array,spot)
      end
    end
  else
    for i in -2:2
      if valid_move(game, piecex, piecey, piecex + i, piecey, player)
        spot = location(piecey, piecex + i)
        push!(move_array, spot)
      end
    end
    if valid_move(game, piecex, piecey, piecex, piecey - 1, player)
      spot = location(piecey - 1, piecex)
      push!(move_array, spot)
    end
    for i in 1:game.boardrows
      if valid_move(game, piecex, piecey, piecex, piecey + i, player)
        spot = location(piecey + i, piecex, 0, 0)
        push!(move_array,spot)
      end
    end
  end
  return move_array
end

#Complexity of triple moves will be time consuming, must decide how to handle
function vice_general_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex, piecey - 1, player, piecex, piecey - 2, piecex, piecey - 3)
    spot = location(piecey - 1, piecex, piecey - 2, piecex, piecey - 3, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex, piecey + 1, player, piecex, piecey + 2, piecex, piecey + 3)
    spot = location(piecey + 1, piecex, piecey + 2, piecex, piecey + 3, piecex)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 1, piecey, player, piecex - 2, piecey, piecex - 3, piecey)
    spot = location(piecey, piecex - 1, piecey, piecex - 2, piecey, piecex - 3)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 1, piecey, player, piecex + 2, piecey, piecex + 3, piecey)
    spot = location(piecey, piecex + 1, piecey, piecex + 2, piecey, piecex + 3)
    push!(move_array, spot)
  end

  return move_array
end

function heavenly_tetrarch_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 2:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex, piecey - i, player)
      spot = location(piecey - i, piecex, 0, 0)
      push!(move_array,spot)
    end
  end
  if valid_move(game, piecex, piecey, piecex + 2, piecey, player)
    spot = location(piecey, piecex + 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex + 3, piecey, player)
    spot = location(piecey, piecex + 3)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 2, piecey, player)
    spot = location(piecey, piecex - 2)
    push!(move_array, spot)
  end
  if valid_move(game, piecex, piecey, piecex - 3, piecey, player)
    spot = location(piecey, piecex - 3)
    push!(move_array, spot)
  end

  for x in -1:1
    for y in -1:1
      if valid_move(game, piecex, piecey, piecex + x, piecey + y, player, piecex, piecey)
        spot = location(piecey + y, piecex + x, piecey, piecex)
        push!(move_array, spot)
      end
    end
  end

  return move_array
end

function water_buffalo_generator(game::shogi, piecex::Int, piecey::Int, player::String, move_array::Array{location})
  for i in 1:game.boardrows
    if valid_move(game, piecex, piecey, piecex + i, piecey + i, player)
      spot = location(piecey + i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey + i, player)
      spot = location(piecey + i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey - i, player)
      spot = location(piecey - i, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey - i, player)
      spot = location(piecey - i, piecex - i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex + i, piecey, player)
      spot = location(piecey, piecex + i, 0, 0)
      push!(move_array,spot)
    end
    if valid_move(game, piecex, piecey, piecex - i, piecey, player)
      spot = location(piecey, piecex - i, 0, 0)
      push!(move_array,spot)
    end
  end
  for i in -2:2
    if valid_move(game, piecex, piecey, piecex, piecey + i, player)
      spot = location(piecey + i, piecex)
      push!(move_array, spot)
    end
  end

  return move_array
end
