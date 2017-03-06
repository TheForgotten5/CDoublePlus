include("gui_functions.jl")
w = Toplevel("Shogi")
global active = w
f = Frame(w, padding = [3, 3, 2, 2], relief = "groove")

pack(f, expand = true, fill = "both")
tcl("ttk::style", "configure", "TButton", foreground="blue", background = "plum2",font="helvetica 15")
buttonNew = Button(f, "New Game")
buttonContinue = Button(f, "Continue")
buttonReplay = Button(f, "Replay")
lShogi = Label(f, "welcome")
#positioning
grid(lShogi, 1, 1)
grid(buttonNew, 2, 1)
grid(buttonContinue, 3, 1)
grid(buttonReplay, 4, 1)

#bindings
bind(buttonNew, "command", NewGame)
bind(buttonContinue, "command", Continue)
bind(buttonReplay, "command", Replay)
