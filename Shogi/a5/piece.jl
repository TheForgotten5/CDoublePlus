using SQLite
type piece
  name::String #name of the piece in english
  ascii::String #board representation
  kanji::String #Unicode Kanji character
  team::String # "w" or "b" or "."
  value::Int #value of a piece compared to others
end
function fetchpieces(gametype::String)
  #return the dataframe with the pieces we want
  db = SQLite.DB("pieces.db")
  pieces = SQLite.query(db, "SELECT * FROM $gametype")
  return pieces
end

function fetchvalue(data::DataFrames.DataFrame, ascii::String, val::Int)
  #fetches info from the dataframe
  #val 1 for name in english
  #val 2 for ascii representation
  #val 3 for kanji
  #val 4 for value
  #print("$ascii")
  num = 0
  for i in 1:length(data[2])
    if data[2][i].value == ascii
      num = i
      break
    end
  end
  if val == 4
    return parse(Int, data[val][num].value)
  end
  return data[val][num].value
end

function makepiece(string::String, pieces::DataFrames.DataFrame)
  #creates a piece based on the string
  if string == "."
    return piece("Empty", ".", ".", " ", 0)
  end
  team = string[1:1]
  num = 1
  for i in 1:length(pieces[2])
    if pieces[2][i].value == string[2:2]
      num = i
      break
    end
  end

  name = pieces[1][num].value
  kanji = pieces[3][num].value
  value = parse(Int, pieces[4][num].value)
  return piece(name, string[2:2], kanji, team, value)
end
