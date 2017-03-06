
#returns true if the piece can move from s to t
#does not take into account board boundardaries or other pieces
#also does not specifically check if source == target
function pawn_move(sx, sy, tx, ty, player)
  if player == "b"
    return tx == sx && ty == sy - 1
  else
    return tx == sx && ty == sy + 1
  end
end

function king_move(sx, sy, tx, ty, player)
  #king moves the same for both players
  return (tx == sx || tx == sx + 1 || tx == sx -1) && (ty == sy || ty == sy + 1 || ty == sy -1)
end

function bishop_move(sx, sy, tx, ty, player)
  #bishop moves the same for both players
  return abs(tx - sx) == abs(ty - sy)
end

function goldgeneral_move(sx, sy, tx, ty, player)
  #check if it moves backwards diagonally, otherwise same as king
  #backwards is different for each player
  if player == "w"
    if ty == sy - 1 && (tx == sx - 1 || tx == sx + 1)
      return false
    end
  else
    if ty == sy + 1 && (tx == sx - 1 || tx == sx + 1)
      return false
    end
  end
  return king_move(sx, sy, tx, ty, player)
end

function silvergeneral_move(sx, sy, tx, ty, player)
  #check if it's to the side or backwards, otherwise same as king
  #backwards is different for each player
  if player == "w"
    if tx == sx && ty == sy - 1
      return false
    end
  else
    if tx == sx && ty == sy + 1
      return false
    end
  end
  #check to the sides
  if ty == sy
    return false
  end
  #check like a king
  return king_move(sx, sy, tx, ty, player)
end

function knight_move(sx, sy, tx, ty, player)
  #theres only two spaces
  if player == "b"
    return ty == sy - 2 && (tx == sx + 1 || tx == sx - 1)
  else
    return ty == sy + 2 && (tx == sx + 1 || tx == sx - 1)
  end
end

function lance_move(sx, sy, tx, ty, player)
  if player == "w"
    return tx == sx && ty > sy
  else
    return tx == sx && ty <  sy
  end
end

function rookp_move(game, sx, sy, tx, ty, player)
  #moves like a rook or king
  return rookmove(game, sx, sy, tx, ty, player) || king_move(sx, sy, tx, ty, player)
end

function bishopp_move(game, sx, sy, tx, ty, player)
  #moves like a bishop or king
  return bishopmove(game, sx, sy, tx, ty, player) || king_move(sx, sy, tx, ty, player)
end

function silverp_move(sx, sy, tx, ty, player)
  #same as goldgeneral
  return goldgeneral_move(sx, sy, tx, ty, player)
end

function knightp_move(sx, sy, tx, ty, player)
  #same as goldgeneral
  return goldgeneral_move(sx, sy, tx, ty, player)
end

function pawnp_move(sx, sy, tx, ty, player)
  #same as goldgeneral
  return goldgeneral_move(sx, sy, tx, ty, player)
end

function lancep_move(sx, sy, tx, ty, player)
  #same as goldgeneral
  return goldgeneral_move(sx, sy, tx, ty, player)
end

function bishopmove(game, sx, sy, tx, ty, player)
  if (abs(sx-tx) != abs(sy-ty)) #piece did not move in a diagonal line
      return false
    end

  if abs(sx - tx) == 1 #only needs to be run if move is greater than 1 space
    return true
  end
  #make sure that no pieces are between starting point and end point
  #will require 4 cases, up-right, up-left, down-right, down-left
  for i in 1:(abs(sx - tx) -1)
    #up-right
    if (sx < tx && sy > ty)
      if game.board[sy-i, sx+i] != "." #there was a piece between move start and move end
        return false
      end

    #up-left
    elseif (sx > tx && sy > ty)
      if game.board[sy - i, sx - i] != "."
        return false
      end

    #down-left
    elseif (sx > tx && sy < ty)
      if game.board[sy + i, sx - i] != "."
        return false
      end

    #down-right
    elseif (sx < tx && sy < ty)
      if game.board[sy + i, sx + i] != "."
        return false
      end
    end
  end
  return true
end

function rookmove(game, sx, sy, tx, ty, player)
  #vertical or horizontal movement
  if (abs(sx-tx) != 0 && abs(sy-ty) == 0) || (abs(sx-tx) == 0 && abs(sy-ty) != 0)
  else
    return false
  end

  if (abs(sx - tx) == 1  || abs(sy - ty) == 1) #only need for loop if moving > 1 tiles
    return true
  end
  #4cases, up, down, left, right

  if (sx != tx)
    for i in 1:(abs(sx-tx) -1)
      if (sx > tx) #moving left
        if game.board[sy, sx - i] != "."
        return false
        end
      elseif (sx < tx)
        if game.board[sy, sx + i] != "."
          return false
        end
      end
    end
  elseif (sy != ty)
    for i in 1:(abs(sy - ty) -1)
      if (sy < ty)
        if game.board[sy + i, sx] != "."
          return false
        end
      elseif (sy > ty)
        if game.board[sy - i, sx] != "."
          return false
        end
      end
    end
  end
  return true
end

function lancemove(game, sx, sy, tx, ty, player)
  if player == "b"
    if (sx != tx) || (ty >= sy) #lance must move straight up
      return false
    end

    if (sy - ty) == 1
      return true
    else
      for i in 1:(abs(sy - ty) - 1)
        if game.board[sy - i, sx] != "."
          return false
        end
      end
    end
  else
    if (sx != tx) || (ty <= sy) #lance must move straight down
      return false
    end

    if (ty - sy) == 1
      return true
    else
      for i in 1:(abs(sy - ty) - 1)
        if game.board[sy + i, sx] != "."
          return false
        end
      end
    end
  end
  return true
end

#----------------------------------- Chu Shogi Pieces ---------------------------------

function reverse_chariot_move(game, sx, sy, tx, ty, player)
  #A reverse chariot can move any number of free squares directly forward or backward

  if sx != tx #Reverse Chariots cannot move sideways
    return false
  end

  if (sy < ty) #moving down the board
    for i in 1:(abs(sy - ty) - 1)
      if game.board[sy + i, sx] != "."
        return false
      end
    end
  else #moving up the board
    for i in 1:(abs(sy - ty) - 1)
      if game.board[sy - i, sx] != "."
        return false
      end
    end
  end

  return true
end

function copper_general_move(game, sx, sy, tx, ty, player)
  #The copper general can take one step to any of the three squares ahead of it, or else directly backward

  if player == "b"
    return (abs(sx - tx) == 1 && ty == sy-1) || (sx == tx && (abs(sy - ty) == 1))
  else
    return (abs(sx - tx) == 1 && ty == sy+1) || (sx == tx && (abs(sy - ty) == 1))
  end
end

function dragon_king_move(game, sx, sy, tx, ty, player)
  #dragon king is a promoted rook
  return rookp_move(game, sx, sy, tx, ty, player)
end

function drunk_elephant_move(game, sx, sy, tx, ty, player)
  #The drunk elephant can take one step in any direction except directly backward

  if player == "b"
    return (abs(tx - sx) == 1 && abs(ty - sy) <= 1) || (tx == sx) && (ty == sy - 1)
  else
    return (abs(tx - sx) == 1 && abs(ty - sy) <= 1) || (tx == sx) && (ty == sy + 1)
  end
end

function ferocious_leopard_move(game, sx, sy, tx, ty, player)
  #The ferocious leopard can take one step to any of the three squares ahead or three squares behind it, but not directly to either side

  return (abs(ty - sy) == 1 && abs(tx - sx) <= 1)
end

function dragon_horse_move(game, sx, sy, tx, ty, player)
  #dragon horse is a promoted bishop

  return bishopp_move(game, sx, sy, tx, ty, player)
end

function side_mover_move(game, sx, sy, tx, ty, player)
  #The side mover can step one square directly forward or backward, or it can move any number of free squares orthogonally sideways

  if (sx == tx)
    return (abs(ty - sy) == 1)

  elseif (abs(ty-sy) == 1)
    return true

  elseif abs(tx-sx) > 1 && sy == ty
    for i in 1:(abs(sx-tx) -1)
      if (sx > tx) #moving left
        if game.board[sy, sx - i] != "."
          return false
        end
      elseif (sx < tx) #moving right
        if game.board[sy, sx + i] != "."
          return false
        end
      end
    end
    return true
  end
  return false
end

function kirin_move(game, sx, sy, tx, ty, player)
  #the kirin can take one step diagonally, or it can jump to the second square in one of the four orthogonal directions.

  return (abs(tx - sx) == 1 && abs(ty - sy) == 1) || (abs(ty - sy) == 2 && sx == tx) || (abs(tx - sx) == 2 && sy == ty)
end

function go_between_move(game, sx, sy, tx, ty, player)
  #The go-between steps one square directly forward or backward.

  return ((sx == tx) && (abs(ty-sy) == 1))
end

function blind_tiger_move(game, sx, sy, tx, ty, player)
  #The blind tiger can take one step in any direction except directly forward.

  if player == "b"
    return (abs(tx - sx) == 1 && abs(ty - sy) <= 1) || (tx == sx) && (ty == sy + 1)
  else
    return (abs(tx - sx) == 1 && abs(ty - sy) <= 1) || (tx == sx) && (ty == sy - 1)
  end
end

function queen_move(game, sx, sy, tx, ty, player)
  #The queen can move any number of free squares along any one of the eight orthogonal or diagonal directions.

  return bishopmove(game, sx, sy, tx, ty, player) || rookmove(game, sx, sy, tx, ty, player)
end

function vertical_mover_move(game, sx, sy, tx, ty, player)
  #the vertical mover can make one step directly sideways or any number of moves forward or backward

  #println("testing mwahahaha \n", sx, sy, tx, ty)
  if (sy == ty)
    return (abs(tx - sx) == 1)

  elseif (abs(ty-sy) == 1)
    return true

  elseif (abs(ty-sy) > 1) && sx == tx
    #println("third case\n sx = ", sx, " sy = ", sy, " tx = ", tx, " ty = ", ty)
    for i in 1:(abs(sy - ty) -1)
      if (sy < ty)
        if game.board[sy + i, sx] != "."
          return false
        end
      elseif (sy > ty)
        if game.board[sy - i, sx] != "."
          return false
        end
      end
    end
    return true
  end
  return false
end

function phoenix_move(game, sx, sy, tx, ty, player)
 #The phoenix can move one square orthogonally or can jump 2 squares diagonally

 return (abs(ty-sy) == 1 && sx == tx) || (abs(tx-sx) == 1 && sy == ty) || (abs(tx-sx) == 2 && abs(ty - sy) == 2)
end

function whale_move(game, sx, sy, tx, ty, player)
  #The whale can move any number of free squares directly forwards, backwards, or along either rear diagonal

  if (sx == tx)
    if (abs(ty - sy) == 1)
       return true
    else
      for i in 1:(abs(sy - ty) -1)
       if (sy < ty)
         if game.board[sy + i, sx] != "."
            return false
         end
       elseif (sy > ty)
        if game.board[sy - i, sx] != "."
          return false
        end
       end
      end
    end
  else
    if player == "b"
      if (sy >= ty) || (abs(sy - ty) != abs(sx - tx))
        return false #trying to move forward diagonally
      elseif (ty - sy) == 1
        return true #only trying to move one square
      else
        for i in 1:((ty-sy)-1)
          if (sx > tx)
           if game.board[sy + i, sx - i] != "."
              return false
            end
          elseif (sx < tx)
            if game.board[sy + i, sx + i] != "."
              return false
            end
          end
        end
      end
    else
      if (sy <= ty) || (abs(sy - ty) != abs(sx - tx))
        return false #trying to move forward diagonally
      elseif (sy - ty) == 1
        return true #only trying to move one square
      else
        for i in 1:((sy-ty)-1)
          if (sx > tx)
           if game.board[sy - i, sx - i] != "."
              return false
            end
          elseif (sx < tx)
            if game.board[sy - i, sx + i] != "."
              return false
            end
          end
        end
      end
    end
  end

  return true
end

function prince_move(game, sx, sy, tx, ty, player)
  #prince moves just like a king

  return king_move(sx, sy, tx, ty, player)
end

function white_horse_move(game, sx, sy, tx, ty, player)
  #The white horse can move any number of free squares directly backwards, forwards, or along either forward diagonal.

  if (sx == tx)
    if (abs(ty - sy) == 1)
       return true
     else
      for i in 1:(abs(sy - ty) -1)
       if (sy < ty)
         if game.board[sy + i, sx] != "."
            return false
         end
       elseif (sy > ty)
           if game.board[sy - i, sx] != "."
           return false
         end
        end
     end
   end
  else
    if player == "b"
      if (sy >= ty) || (abs(sy - ty) != abs(sx - tx))
        return false
      elseif (sy - ty) == 1
        return true
      else
        for i in 1:((sy-ty)-1)
          if (sx > tx)
           if game.board[sy - i, sx - i] != "."
              return false
            end
          elseif (sx < tx)
            if game.board[sy - i, sx + i] != "."
              return false
            end
          end
        end
      end
    else
      if (sy <= ty) || (abs(sy - ty) != abs(sx - tx))
        return false #trying to move backward diagonally
      elseif (ty - sy) == 1
        return true #only trying to move one square
      else
        for i in 1:((ty-sy)-1)
          if (sx > tx)
           if game.board[sy + i, sx - i] != "."
              return false
            end
          elseif (sx < tx)
            if game.board[sy + i, sx + i] != "."
              return false
            end
          end
        end
      end
    end
  end

  return true
end

function free_boar_move(game, sx, sy, tx, ty, player)
  #The free boar can move any number of free squares diagonally or to the side, but not directly forward or backward

  if (sy == ty)
    if abs(tx - sx) == 1
      return true
    else
      for i in 1:(abs(tx-sx)-1)
        if (sx > tx)
          if game.board[sy, sx - i] != "."
            return false
          end
        else
          if game.board[sy, sx + i] != "."
            return false
          end
        end
      end
    end

    return true
  else #it should move like a bishop
    return bishopmove(game, sx, sy, tx, ty, player)
  end
end

function flying_ox_move(game, sx, sy, tx, ty, player)
  #The flying ox can move any number of free squares forwards, backwards, or diagonally, but not directly to the side

  if (sx == tx)
    if (abs(ty - sy) == 1)
      return true
    else
      for i in 1:(abs(ty-sy)-1)
        if (sy > ty)
          if game.board[sy - i, sx] != "."
            return false
          end
        else
          if game.board[sy + i, sx] != "."
            return false
          end
        end
      end
    end

    return true
  else
    return bishopmove(game, sx, sy, tx, ty, player)
  end
end

function flying_stag_move(game, sx, sy, tx, ty, player)
  #The flying stag can move any number of free squares directly forward or backward, or it can take one step in any direction

  if abs(ty - sy) <= 1 && abs(tx - sx) <= 1
    return true
  elseif (sx == tx)
    if (abs(ty - sy) <= 1)
      return true
    else
      for i in 1:(abs(ty-sy)-1)
        if (sy > ty)
          if game.board[sy - i, sx] != "."
            return false
          end
        else
          if game.board[sy + i, sx] != "."
            return false
          end
        end
      end
    end
  else
    return false
  end
end

function horned_falcon_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if (tx2) == 0 #This means there is no second target location
    if player == "b"
      if ((sx == tx) && (ty == (sy -1))) || ((sx == tx) && (ty == (sy -2)))#moving one or two square forward
        return true
      elseif ((sx == tx) && ty > sy) #moving backwards
        if (ty - sy) == 1
          return true
        else
          for i in 1:(ty-sy) - 1
            if game.board[sy + i, sx] != "."
              return false
            end
          end
        end
      elseif (sy == ty) #moving side to side
        if (abs(tx - sx) == 1)
          return true
        else
          for i in 1:(abs(tx - sx)-1)
            if (sx > tx)
              if game.board[sy, sx - i] != "."
                return false
              end
            else
              if game.board[sy, sx + i] != "."
                return false
              end
            end
          end
        end

        return true
      else
        return bishopmove(game, sx, sy, tx, ty, player)
      end
    else
      if ((sx == tx) && (ty == (sy +1))) || ((sx == tx) && (ty == (sy +2)))#moving forward
        return true
      elseif ((sx == tx) && ty < sy) #moving backwards
        if (sy - ty) == 1
          return true
        else
          for i in 1:(sy- ty) - 1
            if game.board[sy - i, sx] != "."
              return false
            end
          end
        end
      elseif (sy == ty) #moving side to side
        if (abs(tx - sx) == 1)
          return true
        else
          for i in 1:(abs(tx - sx)-1)
            if (sx > tx)
              if game.board[sy, sx - i] != "."
                return false
              end
            else
              if game.board[sy, sx + i] != "."
                return false
              end
            end
          end
        end

        return true
      else
        return bishopmove(game, sx, sy, tx, ty, player)
      end
    end
  else #there are two moves
    if player == "b"
      if (sx == tx) && (ty == sy-1) # First step was one square forward
        if (tx == tx2) && ((tx2 == tx-1) || (tx2 == tx + 1))
          return true
        end
      end
      return false
    else
      if (sx == tx) && (ty == sy+1) # First step was one square forward
        if (tx == tx2) && ((tx2 == tx-1) || (tx2 == tx + 1))
          return true
        end
      end
      return false
    end
  end
end

function soaring_eagle_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if (tx2) == 0 #there is no second move
    if player == "b"
      if ((abs(tx - sx) == 1) && (sy - ty) == 1) || ((abs(tx - sx) == 2) && (sy - ty) == 2)#moving forward diagonally 1 or 2 squares
        return true
      elseif (sy - ty > 2)
        return false
      elseif (abs(tx - sx) == ty - sy)
        if (abs(tx - sx) == 1)
          return true
        else
          for i in 1:(abs(tx - sx)-1)
            if sx > tx
              if game.board[sy + i, sx - i] != "."
                return false
              end
            else
              if game.board[sy + i, sx + i] != "."
                return false
              end
            end
          end

          return true
        end
      else
        return rookmove(game, sx, sy, tx, ty, player)
      end
    else
      if ((abs(tx - sx) == 1) && (ty - sy) == 1) || ((abs(tx - sx) == 2) && (ty - sy) == 2)#moving forward diagonally 1 or 2 squares
        return true
      elseif (ty - sy > 2)
        return false
      elseif (abs(tx - sx) == sy - ty)
        if (abs(tx - sx) == 1)
          return true
        else
          for i in 1:(abs(tx - sx)-1)
            if sx > tx
              if game.board[sy - i, sx - i] != "."
                return false
              end
            else
              if game.board[sy - i, sx + i] != "."
                return false
              end
            end
          end

          return true
        end
      else
        return rookmove(game, sx, sy, tx, ty, player)
      end
    end
  else #making two moves
    if player == "b"
      if (sx - tx) == 1 && (sy - ty) == 1 #first move up and right
        if ((tx - tx2) == 1 && (ty - ty2) == 1) || ((tx2 - tx) == 1 && (ty2 - ty) == 1)
          return true
        end
      elseif (tx - sx) == 1 && (sy - ty) == 1 #first move up and left
        if ((tx2 - tx) == 1 && (ty - ty2) == 1) || ((tx - tx2) == 1 && (ty2 - ty) == 1)
          return true
        end
      end
      return false
    else
      if (sx - tx) == 1 && (ty - sy) == 1
        if ((tx - tx2) == 1 && (ty2 - ty) == 1) || ((tx2 - tx) == 1 && (ty - ty2) == 1)
          return true
        end
      elseif (tx - sx) == 1 && (ty - sy) == 1
        if ((tx2 - tx) == 1 && (ty2 - ty) == 1) || ((tx - tx2) == 1 && (ty - ty2) == 1)
          return true
        end
      end
      return false
    end
  end
end

function lion_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if (tx2) == 0 # single move
    return (abs(ty - sy) <=2)&& (abs(tx - sx) <=2) #jumping

  else #this is where the fun begins. FeelsBadMan
    if (abs(tx - sx) > 1) || (abs(ty - sy) > 1)#first move is only 1 square away
      return false
    end
    if (abs(tx2 - tx) > 1) || (abs(ty2 - ty) > 1)#second move is only 1 square away
      return false
    end
    if game.board[ty2, tx2] == "."
      return true
    elseif game.board[ty2, tx2][2:2] == "i" #moving to a non-adjacent lion
      if in_danger(game, tx2, ty2, player)
        if game.board[ty, tx]  == "." || game.board[ty, tx][2:2] == "p" || game.board[ty, tx][2:2] == "o"
          return false
        end
      end
    end

    return true
  end
end

#=type location
  row
  column
  row2
  column2
end
=#

function in_danger(game, piecex, piecey, player) #function checks if the opponent can make a move to a target square, returns true if they can, false if they cannot

  enemy = player == "b" ? "w" : "b"
  enemy_double_movers = Array{location}(0)

  for row in 1:game.boardrows
    for col in 1:game.boardcols
      if game.board[col, row][1:1] == enemy
        piece = game.board[col, row][2:2]
        if piece == "i" || piece == "D" || piece == "H" #The piece can make a double move
          piece_location = location(row, col, 0, 0)
          push!(enemy_double_movers, piece_location)
        end
        if valid_move(game, row, col, piecex, piecey, enemy, 0, 0) == true
          return true
        end
      end
    end
  end

  if length(enemy_double_movers) > 0 #Enemy has pieces that move twice
    for i in 1:length(enemy_double_movers)
      x = enemy_double_movers[i].row
      y = enemy_double_movers[i].column
      piece = game.board[y, x][2:2]
      if piece == "i"
        for l in (y)-1:(y)+1
          for m in (x)-1:(x)+1
            if 1 <= l <= game.boardrows  && 1 <= m <= game.boardcols
              if valid_move(game, x, y, m, l, player, piecex, piecey)
                return true
              end
            end
          end
        end
      elseif piece == "D"
        if enemy == "b"
          if valid_move(game, x, y, (x-1), (y-1), player, piecex, piecey) || valid_move(game, x, y, (x+1), (y-1), player, piecex, piecey)
            return true
          end
        else
          if valid_move(game, x, y, (x-1), (y+1), player, piecex, piecey) || valid_move(game, x, y, (x+1), (y+1), player, piecex, piecey)
            return true
          end
        end
      elseif piece == "H"
        if enemy == "b"
          if valid_move(game, x, y, x, (y-1), player, piecex, piecey)
            return true
          end
        else
          if valid_move(game, x, y, x, (y+1), player, piecex, piecey)
            return true
          end
        end
      end
    end
  end
  #if we get this far, there is no valid move for an oponnent to get to the given square
  return false
end

#------------------------------ Tenjiku Shogi Pieces ----------------------------------

function ten_lion_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if (tx2) == 0 # single move
    return (abs(ty - sy) <=2)&& (abs(tx - sx) <=2) #jumping

  else #this is where the fun begins. FeelsBadMan
    if (abs(tx - sx) > 1) || (abs(ty - sy) > 1)#first move is only 1 square away
      return false
    end
    if (abs(tx2 - tx) > 1) || (abs(ty2 - ty) > 1)#second move is only 1 square away
      return false
    end

    return true
  end
end

function bishop_general_move(game, sx, sy, tx, ty, player)
  if abs(tx - sx) != abs(ty - sy)
    return false #piece did not move in a diagonal line
  end

  if abs(sx - tx) == 1
    return true
  end

  for i in 1:(abs(sx - tx) -1)
    #up-left
    if (sx < tx && sy > ty) && game.board[sy - i, sx+i] != "..."
      if game.board[sy-i, sx+i][2:3] == "k." || game.board[sy-i, sx+i][2:3] == "DE"|| game.board[sy-i, sx+i][2:3] == "bg" || game.board[sy-i, sx+i][2:3] == "BG" || game.board[sy-i, sx+i][2:3] == "gg" || game.board[sy-i, sx+i][2:3] == "HF" || game.board[sy-i, sx+i][2:3] == "rg" || game.board[sy-i, sx+i][2:3] == "RG" || game.board[sy-i, sx+i][2:3] == "SE" || game.board[sy-i, sx+i][2:3] == "vg"
        return false
      end

      if game.board[sy-i, sx+i] != "..." && game.board[ty, tx] != "..."
        if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
          return false
        end
      end


    #up-right
  elseif (sx > tx && sy > ty) && game.board[sy - i, sx-i] != "..."
      if game.board[sy-i, sx-i][2:3] == "k." || game.board[sy-i, sx-i][2:3] == "DE" || game.board[sy-i, sx-i][2:3] == "bg" || game.board[sy-i, sx-i][2:3] == "BG" || game.board[sy-i, sx-i][2:3] == "gg" || game.board[sy-i, sx-i][2:3] == "HF" || game.board[sy-i, sx-i][2:3] == "rg" || game.board[sy-i, sx-i][2:3] == "RG" || game.board[sy-i, sx-i][2:3] == "SE" || game.board[sy-i, sx-i][2:3] == "vg"
        return false
      end

      if game.board[sy-i, sx-i] != "..." && game.board[ty, tx] != "..."
        if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
          return false
        end
      end

    #down-right
  elseif (sx > tx && sy < ty) && game.board[sy + i, sx-i] != "..."
      if game.board[sy+i, sx-i][2:3] == "k." || game.board[sy+i, sx-i][2:3] == "DE" || game.board[sy+i, sx-i][2:3] == "bg" || game.board[sy+i, sx-i][2:3] == "BG" || game.board[sy+i, sx-i][2:3] == "gg" || game.board[sy+i, sx-i][2:3] == "HF" || game.board[sy+i, sx-i][2:3] == "rg" || game.board[sy+i, sx-i][2:3] == "RG" ||  game.board[sy+i, sx-i][2:3] == "SE" || game.board[sy+i, sx-i][2:3] == "vg"
        return false
      end

      if game.board[sy+i, sx-i] != "..." && game.board[ty, tx] != "..."
        if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
          return false
        end
      end

    #down-left
  elseif (sx < tx && sy < ty) && game.board[sy + i, sx+i] != "..."
      if game.board[sy+i, sx+i][2:3] == "k." || game.board[sy+i, sx+i][2:3] == "DE" || game.board[sy+i, sx+i][2:3] == "bg" || game.board[sy+i, sx+i][2:3] == "BG" || game.board[sy+i, sx+i][2:3] == "gg" || game.board[sy+i, sx+i][2:3] == "HF" || game.board[sy+i, sx+i][2:3] == "rg" || game.board[sy+i, sx+i][2:3] == "RG" || game.board[sy+i, sx+i][2:3] == "SE" || game.board[sy+i, sx+i][2:3] == "vg"
        return false
      end

      if game.board[sy+i, sx+i] != "..." && game.board[ty, tx] != "..."
        if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
          return false
        end
      end
    end
  end

  return true
end

function chariot_soldier_move(game, sx, sy, tx, ty, player)
  if abs(tx - sx) == abs(ty - sy)
    return bishopmove(game, sx, sy, tx, ty, player)
  end

  if sx == tx
    if abs(ty - sy) == 1
      return true
    else
      for i in 1:abs(ty-sy)-1
        if (sy > ty)
          if game.board[sy-i, sx] != "..."
            return false
          end
        else
          if game.board[sy+i, sx] != "..."
            return false
          end
        end
      end
    end
  end

  if sy == ty
    if abs(tx - sx) <=2
      return true
    else
      return false
    end
  end

  return true
end

function dog_move(game, sx, sy, tx, ty, player)
  if player == "b"
    if (sx == tx) && (sy - ty) == 1
      return true
    elseif (abs(tx - sx) == 1) && ((ty - sy) == 1)
      return true
    else
      return false
    end
  else
    if (sx == tx) && (ty - sy) == 1
      return true
    elseif (abs(tx - sx) == 1) && ((sy - ty) == 1)
      return true
    else
      return false
    end
  end
end

function fire_demon_move(game, sx, sy, tx, ty, player, tx2, ty2, tx3, ty3)
  if tx3 == 0 #only two or one moves
    if tx2 == 0 #only one move
      if sy == ty
        if abs(tx - sx) == 1
          return true
        else
          for i in 1:abs(tx - sx) -1
            if (sx > tx)
              if game.board[sy, sx-i] != "..."
                return false
              end
            else
              if game.board[sy, sx+i] != "..."
                return false
              end
            end
          end
        end
        return true
      else
        return bishopmove(game, sx, sy, tx, ty, player)
      end
    else
      if abs(ty-sy) > 1 || abs(tx - sx) > 1
        return false #if moving multiple times, must only move one square at a time
      end
      if abs(ty2 - ty) > 1 || abs(tx2 - tx) > 1
        return false
      end
      if game.board[ty, tx] != "..."
        return false #can't keep moving after capturing a piece
      end
      return true
    end
  else
    if abs(ty-sy) > 1 || abs(tx - sx) > 1
      return false #if moving multiple times, must only move one square at a time
    end
    if abs(ty2 - ty) > 1 || abs(tx2 - tx) > 1
      return false
    end
    if abs(ty3 - ty2) > 1 || abs(tx3 - tx2) > 1
      return false
    end
    if game.board[ty, tx] != "..."
      return false #can't keep moving after capturing a piece
    end
    if game.board[ty2, tx2] != "..."
      return false #can't keep moving after capturing a piece
    end
    return true
  end
end

function free_eagle_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if tx2 == 0
    if abs(tx - sx) == 2 && sy == ty || abs(tx - sx) == 2 && abs(ty - sy) == 2 || sx == tx && abs(ty - sy) == 2
      return true
    else
      return queen_move(game, sx, sy, tx, ty, player)
    end
  else
    if abs(tx - sx) != 1 || abs(ty - sy) != 1
      return false #Piece must move one diagonal tile if moving twice
    end
    if abs(tx2 - tx) != 1 || abs(ty2 - ty) != 1
      return false
    end
    return true
  end
end

function great_general_move(game, sx, sy, tx, ty, player)
  if abs(tx - sx) == abs(ty - sy) #moving diagonally
    if abs(sx - tx) == 1
      return true
    end

    for i in 1:(abs(sx - tx) -1)
      #up-left
      if (sx < tx && sy > ty)
        if game.board[sy-i, sx+i][2:3] == "k." || game.board[sy-i, sx+i][2:3] == "DE" || game.board[sy-i, sx+i][2:3] == "gg" || game.board[sy-i, sx+i][2:3] == "RG"
          return false
        end

        if game.board[sy-i, sx+i] != "..."
          if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
            return false
          end
        end


      #up-right
      elseif (sx > tx && sy > ty)
        if game.board[sy-i, sx-i][2:3] == "k." || game.board[sy-i, sx-i][2:3] == "DE" || game.board[sy-i, sx-i][2:3] == "gg" || game.board[sy-i, sx-i][2:3] == "RG"
          return false
        end

        if game.board[sy-i, sx-i] != "..."
          if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
            return false
          end
        end

      #down-right
      elseif (sx > tx && sy < ty)
        if game.board[sy+i, sx-i][2:3] == "k." || game.board[sy+i, sx-i][2:3] == "DE" || game.board[sy+i, sx-i][2:3] == "gg" || game.board[sy+i, sx-i][2:3] == "RG"
          return false
        end

        if game.board[sy+i, sx-i] != "..."
          if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
            return false
          end
        end

      #down-left
      elseif (sx < tx && sy < ty)
        if game.board[sy+i, sx+i][2:3] == "k." || game.board[sy+i, sx+i][2:3] == "DE" || game.board[sy+i, sx+i][2:3] == "gg" || game.board[sy+i, sx+i][2:3] == "RG"
          return false
        end

        if game.board[sy+i, sx+i] != "..."
          if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
            return false
          end
        end
      end
    end
    return true
  elseif (sx == tx) && (sy != ty) || (sy == ty) && (sx != tx) #moving orthogonally
    if (sx == tx)
      if abs(ty - sy) == 1
        return true
      end

      for i in 1:abs(ty-sy)-1
        if (sy > ty)
          if game.board[sy-i, sx][2:3] == "k." || game.board[sy-i, sx][2:3] == "DE"|| game.board[sy-i, sx][2:3] == "gg" || game.board[sy-i, sx][2:3] == "RG"
            return false
          end

          if game.board[sy-i, sx] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        else
          if game.board[sy+i, sx][2:3] == "k." || game.board[sy+i, sx][2:3] == "DE"|| game.board[sy+i, sx][2:3] == "gg" || game.board[sy+i, sx][2:3] == "RG"
            return false
          end

          if game.board[sy+i, sx] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        end
      end
      return true
    else
      if abs(tx - sx) == 1
        return true
      end

      for i in 1:abs(tx - sx)-1
        if (sx > tx)
          if game.board[sy, sx-i][2:3] == "k." || game.board[sy, sx-i][2:3] == "DE"|| game.board[sy, sx-i][2:3] == "gg" || game.board[sy, sx-i][2:3] == "RG"
            return false
          end

          if game.board[sy, sx-i] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        else
          if game.board[sy, sx+i][2:3] == "k." || game.board[sy, sx+i][2:3] == "DE"|| game.board[sy, sx+i][2:3] == "gg" || game.board[sy, sx+i][2:3] == "RG"
            return false
          end

          if game.board[sy, sx+i] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        end
      end
      return true
    end
  else
    return false
  end
end

function iron_general_move(game, sx, sy, tx, ty, player)
  if player == "b"
    if (sy - ty) == 1 && abs(tx - sx) <= 1
      return true
    else
      return false
    end
  else
    if (ty - sy) == 1 && abs(tx - sx) <= 1
      return true
    else
      return false
    end
  end
end

function lion_hawk_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if tx2 == 0
    if abs(tx - sx) <=2 && abs(ty - sy) <=2
      return true
    elseif (abs(tx - sx) == abs(ty - sy))
      return bishopmove(game, sx, sy, tx, ty, player)
    else
      return false
    end
  else
    if (abs(tx - sx) > 1) || (abs(ty - sy) > 1)#first move is only 1 square away
      return false
    end
    if (abs(tx2 - tx) > 1) || (abs(ty2 - ty) > 1)#second move is only 1 square away
      return false
    end

    return true
  end
end

function multi_general_move(game, sx, sy, tx, ty, player)
  if player == "b"
    if sx == tx
      if abs(ty - sy) == 1
        return true
      else
        for i in 1:abs(ty - sy)-1
          if game.board[sy - i, sx] != "..."
            return false
          end
        end
      return true
      end

    elseif abs(tx - sx) == abs(ty - sy)
      if abs(ty - sy) == 1
        return true
      else
        for i in 1:abs(ty - sy)-1
          if (sx > tx)
            if game.board[sy + i, sx - i] != "..."
              return false
            end
          else
            if game.board[sy + i, sx + i] != "..."
              return false
            end
          end
        end
      return true
      end
    else
      return false
    end

  else
    if sx == tx
      if abs(ty - sy) == 1
        return true
      else
        for i in 1:abs(ty - sy)-1
          if game.board[sy + i, sx] != "..."
            return false
          end
        end
      return true
      end

    elseif abs(tx - sx) == abs(ty - sy)
      if abs(ty - sy) == 1
        return true
      else
        for i in 1:abs(ty - sy)-1
          if (sx > tx)
            if game.board[sy - i, sx - i] != "..."
              return false
            end
          else
            if game.board[sy - i, sx + i] != "..."
              return false
            end
          end
        end
      return true
      end
    else
      return false
    end
  end
end

function rook_general_move(game, sx, sy, tx, ty, player)
  if sx != tx && sy != ty
    return false
  end

  if (sx == tx)
    if abs(ty - sy) == 1
      return true
    else
      for i in 1:abs(ty - sy)-1
        if (sy > ty) && game.board[sy - i, sx] != "..."
          if game.board[sy-i, sx][2:3] == "k." || game.board[sy-i, sx][2:3] == "DE"|| game.board[sy-i, sx][2:3] == "bg" || game.board[sy-i, sx][2:3] == "BG" || game.board[sy-i, sx][2:3] == "gg" || game.board[sy-i, sx][2:3] == "HF" || game.board[sy-i, sx][2:3] == "rg" || game.board[sy-i, sx][2:3] == "RG" || game.board[sy-i, sx][2:3] == "SE" || game.board[sy-i, sx][2:3] == "vg"
            return false
          end

          if game.board[sy-i, sx] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end

        else
          if game.board[sy+i, sx][2:3] == "k." || game.board[sy+i, sx][2:3] == "DE"|| game.board[sy+i, sx][2:3] == "bg" || game.board[sy+i, sx][2:3] == "BG" || game.board[sy+i, sx][2:3] == "gg" || game.board[sy+i, sx][2:3] == "HF" || game.board[sy+i, sx][2:3] == "rg" || game.board[sy+i, sx][2:3] == "RG" || game.board[sy+i, sx][2:3] == "SE" || game.board[sy+i, sx][2:3] == "vg"
            return false
          end

          if game.board[sy+i, sx] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        end
      end

      return true
    end

  else
    if abs(tx - sx) == 1
      return true
    else
      for i in 1:abs(tx - sx)-1
        if (sx > tx)
          if game.board[sy, sx-i][2:3] == "k." || game.board[sy, sx-i][2:3] == "DE"|| game.board[sy, sx-i][2:3] == "bg" || game.board[sy, sx-i][2:3] == "BG" || game.board[sy, sx-i][2:3] == "gg" || game.board[sy, sx-i][2:3] == "HF" || game.board[sy, sx-i][2:3] == "rg" || game.board[sy, sx-i][2:3] == "RG" || game.board[sy, sx-i][2:3] == "SE" || game.board[sy, sx-i][2:3] == "vg"
            return false
          end

          if game.board[sy, sx-i] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end

        else
          if game.board[sy, sx+i][2:3] == "k." || game.board[sy, sx+i][2:3] == "DE"|| game.board[sy, sx+i][2:3] == "bg" || game.board[sy, sx+i][2:3] == "BG" || game.board[sy, sx+i][2:3] == "gg" || game.board[sy, sx+i][2:3] == "HF" || game.board[sy, sx+i][2:3] == "rg" || game.board[sy, sx+i][2:3] == "RG" || game.board[sy, sx+i][2:3] == "SE" || game.board[sy, sx+i][2:3] == "vg"
            return false
          end

          if game.board[sy, sx+i] != "..."
            if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
              return false
            end
          end
        end
      end

      return true
    end
  end
end

function side_soldier_move(game, sx, sy, tx, ty, player)
  if sx != tx && sy != ty
    return false
  end

  if player == "b"
    if sy == ty
      if abs(tx - sx) == 1
        return true
      else
        for i in 1:(abs(sx-tx) -1)
          if (sx > tx)
            if game.board[sy, sx - i] != "..."
              return false
            end
          elseif (sx < tx)
            if game.board[sy, sx + i] != "..."
              return false
            end
          end
        end
        return true
      end
    else
      if abs(ty - sy) == 1 || (sy - ty) == 2
        return true
      else
        return false
      end
    end

  else
    if sy == ty
      if abs(tx - sx) == 1
        return true
      else
        for i in 1:(abs(sx-tx) -1)
          if (sx > tx)
            if game.board[sy, sx - i] != "..."
              return false
            end
          elseif (sx < tx)
            if game.board[sy, sx + i] != "..."
              return false
            end
          end
        end
        return true
      end
    else
      if abs(ty - sy) == 1 || (ty - sy) == 2
        return true
      else
        return false
      end
    end
  end
end

function vertical_soldier_move(game, sx, sy, tx, ty, player)
  if sx != tx && sy != ty
    return false
  end

  if player == "b"
    if sy == ty
      if abs(tx - sx) <=2
        return true
      end
    else
      if abs(sy - ty) == 1
        return true
      else
        if (ty > sy)
          return false
        else
          for i in 1:abs(ty - sy) -1
            if game.board[sy - i, sx] != "..."
              return false
            end
          end
          return true
        end
      end
    end

  else
    if sy == ty
      if abs(tx - sx) <=2
        return true
      end
    else
      if abs(sy - ty) == 1
        return true
      else
        if (sy > ty)
          return false
        else
          for i in 1:abs(ty - sy) -1
            if game.board[sy + i, sx] != "..."
              return false
            end
          end
          return true
        end
      end
    end
  end
end

function vice_general_move(game, sx, sy, tx, ty, player, tx2, ty2, tx3, ty3)
  if tx3 == 0 #two or one moves
    if tx2 == 0 #only one move
      if abs(tx - sx) <= 1 && abs(ty - sy) <= 1
        return true
      end

     if abs(tx - sx) == abs(ty - sy) #moving diagonally
        if abs(sx - tx) == 1
          return true
        end

        for i in 1:(abs(sx - tx) -1)
          #up-left
          if (sx < tx && sy > ty)
            if game.board[sy-i, sx+i][2:3] == "k." || game.board[sy-i, sx+i][2:3]  == "DE" || game.board[sy-i, sx+i][2:3] == "gg" || game.board[sy-i, sx+i][2:3] == "RG" || game.board[sy-i, sx+i][2:3] == "BG" || game.board[sy-i, sx+i][2:3] == "vg"
              return false
            end

            if game.board[sy-i, sx+i] != "..."
              if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
                return false
              end
            end


          #up-right
          elseif (sx > tx && sy > ty)
            if game.board[sy-i, sx-i][2:3] == "k." || game.board[sy-i, sx-i][2:3] == "DE" || game.board[sy-i, sx-i][2:3] == "gg" || game.board[sy-i, sx-i][2:3] == "RG" || game.board[sy-i, sx-i][2:3] ==  "BG" || game.board[sy-i, sx-i][2:3] == "vg"
              return false
            end

            if game.board[sy-i, sx-i] != "..."
              if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
                return false
              end
            end

          #down-right
          elseif (sx > tx && sy < ty)
            if game.board[sy+i, sx-i][2:3] == "k." || game.board[sy+i, sx-i][2:3] == "DE" || game.board[sy+i, sx-i][2:3] == "gg" || game.board[sy+i, sx-i][2:3] == "RG" || game.board[sy+i, sx-i][2:3] == "BG" || game.board[sy+i, sx-i][2:3] == "vg"
              return false
            end

            if game.board[sy+i, sx-i] != "..."
              if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
                return false
              end
            end

          #down-left
          elseif (sx < tx && sy < ty)
            if game.board[sy+i, sx+i][2:3] == "k." || game.board[sy+i, sx+i][2:3] == "DE" || game.board[sy+i, sx+i][2:3] == "gg" || game.board[sy+i, sx+i][2:3] == "RG" || game.board[sy+i, sx+i][2:3] == "BG" || game.board[sy+i, sx+i][2:3] == "vg"
              return false
            end

            if game.board[sy+i, sx+i] != "..."
              if game.board[ty, tx][2:3] == "k." || game.board[ty, tx][2:3] == "DE"
                return false
              end
            end
          end
        end
      return true
      end
    else
      if abs(tx - sx) > 1 || abs(ty - sy) > 1
        return false
      end
      if abs(tx2 - tx) > 1 || abs(ty2 - ty) > 1
        return false
      end
      if game.board[ty, tx] != "..."
        return false
      end
    return true
    end
  else
    if abs(tx - sx) > 1 || abs(ty - sy) > 1
      return false
    end
    if abs(tx2 - tx) > 1 || abs(ty2 - ty) > 1
      return false
    end
    if abs(tx3 - tx2) > 1 || abs(ty3 - ty2) > 1
      return false
    end
    if game.board[ty, tx] != "..."
      return false
    end
    if game.board[ty2, tx2] != "..."
      return false
    end
    return true
  end
end

function water_buffalo_move(game, sx, sy, tx, ty, player)
  if abs(ty - sy) == abs(tx - sx)
    return bishopmove(game, sx, sy, tx, ty, player)
  elseif sy == ty
    if abs(tx - sx) == 1
      return true
    else
      for i in 1:(abs(sx-tx) -1)
        if (sx > tx)
          if game.board[sy, sx - i] != "..."
            return false
          end
        elseif (sx < tx)
          if game.board[sy, sx + i] != "..."
            return false
          end
        end
      end
      return true
    end
  elseif sx == tx
    if abs(ty - sy) <= 2
      return true
    end
  else
    return false
  end
end

function heavenly_tetrarch_move(game, sx, sy, tx, ty, player, tx2, ty2)
  if tx2 == 0
    if abs(tx - sx) <=1 && abs(ty - sy) <=1
      return false
    end
    if abs(tx - sx) == abs(ty - sy)
      if abs(tx - sx) == 2
        return true
      else
        for i in 2:abs(tx-sx)-1
          if (sx < tx && sy > ty)
            if game.board[sy-i, sx+i] != "..."
              return false
            end

          elseif (sx > tx && sy > ty)
            if game.board[sy - i, sx - i] != "..."
              return false
            end

          elseif (sx > tx && sy < ty)
            if game.board[sy + i, sx - i] != "..."
              return false
            end

          elseif (sx < tx && sy < ty)
            if game.board[sy + i, sx + i] != "..."
              return false
            end
          end
        end
        return true
      end
    elseif (sx == tx && ty != sy)
      if abs(ty - sy) == 2
        return true
      else
        for i in 2:abs(ty - sy) -1
          if (sy > ty)
            if game.board[sy - i, sx] != "..."
              return false
            end
          elseif (sy < ty)
            if game.board[sy + i, sx] != "..."
              return false
            end
          end
        end
        return true
      end

    elseif (sy == ty && sx != tx)
      if abs(tx - sx) == 2
        return true
      elseif abs(tx - sx) == 3
        if (sx > tx)
          if game.board[sy, sx - 2] != "..."
            return false
          end
        else
          if game.board[sy, sx + 2] != "...""..."
            return false
          end
        end
        return true
      else
        return false
      end

    else #not a move in the moveset of a tetrarch
      return false
    end
  else
    if tx2 != sx || ty2 != sy
      return false
    end
    if abs(tx - sx) > 1 || abs(ty - sy) >1
      return false
    end
    return true
  end
end
