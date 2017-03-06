using Gtk.ShortNames

using SQLite
#set up the game
include("shogi.jl")

#Checks if filename is included
if length(ARGS) != 1
  print_with_color(:red, "ERROR: Filename required to initialize board. \n")
  exit(1)
end

filename = ARGS[1]
#Opens the database
db = SQLite.DB(filename)

gamemode = SQLite.query(db, "SELECT value FROM meta WHERE key = 'type'")[1].values[1]
#Determines which shogi will be played.

#Initialize a specific board with all pieces.
if gamemode == "standard"
	game = startStandard()
elseif gamemode == "minishogi"
	game = startMini()
elseif gamemode == "chushogi"
	game = startChu()
end

timed = SQLite.query(db, "SELECT value FROM meta WHERE key = 'timed'")[1].values[1]
if timed == "yes"
  time_left = SQLite.query(db, "SELECT value FROM meta WHERE key = 'sente_time'")[1].values[1]
  time_left2 = SQLite.query(db, "SELECT value FROM meta WHERE key = 'gote_time'")[1].values[1]

else
  time_left = 0
  time_left2 = 0
end

#print(game.board)
moves = SQLite.query(db, "SELECT * FROM moves")
update(game, moves)

pieces = fetchpieces(game.gametype)
#set up the window
win = @Window("Shogi") #|> (f = @Frame(""))
setproperty!(win, :resizable, false)

g = @Grid() #main grid
#hbox = @Image()
#push!(g,hbox)
#vbox = @Box(:v)
#push!(f,vbox)
align_display = 1
align_label = 2
infogrid = @Box(:v)
game_status = @Label("Game Status")
b_timer = @Label("Black Timer: $time_left")
w_timer = @Label("White Timer: $time_left2")
Grid
b_cap = @Frame("Black")
bbox = @Box(:h)
push!(b_cap, bbox)
for i in game.cap_black

    a= @Button(makepiece("b$i", pieces).kanji)
    push!(bbox, a)
end
w_cap = @Frame("White")
wbox = @Box(:h)
push!(w_cap, wbox)
for i in game.cap_white

    a= @Button(makepiece("w$i", pieces).kanji)
    push!(wbox, a)
end
board_display = @Frame("Board")
board = @Grid()
for i in 1: game.boardcols
  for j in game.boardrows:-1:1

    a= @ToggleButton(makepiece(game.board[j, i], pieces).kanji)
    board[game.boardcols - i, j] = a
  end
end

push!(board_display, board)

push!(infogrid, b_timer)
push!(infogrid, game_status)
push!(infogrid, w_timer)
g[align_label, 5] = infogrid
g[align_display,8] = b_cap
g[align_display,2:7] = board_display
g[align_display,1] = w_cap


setproperty!(g, :row_homogeneous, true)
#setproperty!(g,:column_homogeneous,true)
#setproperty!(g, :row_spacing, 30)
push!(win,g)
#push!(vbox,b_timer,game_status,w_timer)
showall(win)

#keeps julia running
if !isinteractive()
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
