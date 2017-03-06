include("board.jl")


function addButton(frame::Tk.Tk_Frame, label::String, row::Int, col::Int, event)
  b = Button(frame, label)
  grid(b, row, col)
  bind(b, "command", event)
  return b
end

function NewGame(path)
  #bound to New Game button
  destroy(active)
  NewGameWindow()
end

function Continue(path)
  #bound to Continue button
  destroy(active)
  ContinueWindow()
end

function Replay(path)
  destroy(active)
  ReplayWindow()
end


#Window Constructors
function NewGameWindow()
  w = Toplevel("New Game")
  active = w
  f = Frame(w, padding = [3, 3, 2, 2], relief = "groove")
  pack(f, expand = true, fill = "both")

  #events
  AI(path) = SettingsWindow(1, w)
  Human(path) = SettingsWindow(2, w)
  Host(path) = SettingsWindow(3, w)
  AIHost(path) = SettingsWindow(4, w)
  Join(path) = JoinWindow()
  Email(path) = EmailWindow()

  #buttons
  buttonAI = addButton(f, "AI", 1, 1, AI)
  buttonHuman = addButton(f, "Local Vs", 2, 1, Human)
  buttonHost = addButton(f, "Host Game", 3, 1, Host)
  buttonAIHost = addButton(f, "AI Host", 4, 1, AIHost)
  buttonJoin = addButton(f, "Join Game", 5, 1, Join)
  buttonEmail = addButton(f, "Email", 6, 1, Email)
end

function JoinWindow()
  w = Toplevel("Join Game")
  f = Frame(w, padding = [3, 3, 2, 2], relief = "groove")
  pack(f, expand = true, fill = "both")

  port = 0
  eport = Entry(f)
  buttonJoin = Button(f, "Join")
  formlayout(e, "Port: ")
  formlayout(buttonJoin, nothing)
  function join(path)
    a = tryparse(Int, get_value(eport))
  end
end

function SettingsWindow(n, w)
  destroy(w)
  SettingsWindow(n)
end
function SettingsWindow(n)
  w = Toplevel("Settings")
  f = Frame(w, padding = [3, 3, 2, 2], relief = "groove")
  pack(f, expand = true, fill = "both")
  variants = ["standard", "minishogi", "chu", "ten"]
  difficulties = ["Normal", "Hard", "Suicidal", "Protracted Death", "Random"]
  variant = 1
  difficulty = 1
  timelimit = false
  timeadd = 10
  roulette = false
  gofirst = true
  cheating = false

  function tvariant(path)
    variant += 1
    if variant > 4
      variant = 1
    end
    set_value(buttonVariant, "Variant: $(variants[variant])")
  end

  function ttimelimit(path)
    timelimit = !timelimit
    set_value(buttonTimeLimit, "Time Limit: $(timelimit ? "Yes" : "No")")
    set_enabled(entryTimeAdd, timelimit)
    set_enabled(entryTimeLimit, timelimit)
  end

  function ttimeadd(path)

  end

  function troulette(path)
    roulette = !roulette
    set_value(buttonRoulette, "Roulette: $(roulette? "Yes" : "No")")
  end

  function tgofirst(path)
    gofirst = !gofirst
    set_value(buttonGoFirst, "Go First: $(gofirst ? "Yes" : "No")")
  end

  function tcheating(path)
    cheating = !cheating
    set_value(buttonCheating, "Cheating: $(cheating ? "Yes" : "No")")
  end

  function tdifficulty(path)
    difficulty += 1
    if difficulty > 4
      difficulty = 1
    end
    set_value(buttonDifficulty, "Difficulty: $(difficulties[difficulty])")
  end
  function startButton(path)
    if timelimit
      l = get_value(entryTimeLimit)
      a = get_value(entryTimeAdd)
      l = tryparse(Int, l)
      a = tryparse(Int, a)

      if isnull(l) || isnull(a)
        Messagebox(w, title = "Error", message = "Bad input for timing")
        return nothing
      end
    end
    println("ok")
    game = startGame(variants[variant])
    gameloop(game)
  end
  lGeneral = Label(f, "General")
  lTime = Label(f, "Timing")
  ltimeadd = Label(f, "Time Increment: ")
  ltimelimit = Label(f, "Time Limit: ")
  lAI = Label(f, "AI")
  buttonVariant = addButton(f, "Variant: Standard", 2, 1, tvariant)
  buttonTimeLimit = addButton(f, "Time Limit: No", 5, 1, ttimelimit)
  buttonRoulette = addButton(f, "Roulette: No", 2, 2, troulette)
  buttonGoFirst = addButton(f, "Go First: Yes", 3, 1, tgofirst)
  buttonCheating = addButton(f, "Cheating: No", 3, 2, tcheating)
  buttonDifficulty = addButton(f, "Difficulty: Normal", 9, 1, tdifficulty)
  buttonStart = addButton(f, "Start!", 11, 2, startButton)
  entryTimeLimit = Entry(f)
  entryTimeAdd = Entry(f)
  grid(lGeneral, 1, 1)
  grid(lTime, 4, 1)
  grid(ltimelimit, 6, 1)
  grid(entryTimeLimit, 6, 2)
  grid(ltimeadd, 7, 1)
  grid(entryTimeAdd, 7, 2)
  grid(lAI, 8, 1)
  set_enabled(entryTimeAdd, false)
  set_enabled(entryTimeLimit, false)

end

function gameloop(game)

  display_board(game)

end
