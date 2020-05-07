type t = int

(** Represents input command types that modify input state.
    Input commands are mapped to one or more keys on keyboard.*)
type command =
  | Left
  | Right
  | Select
  | Quit
  | Unrecognized

(**[receive_command c t adv st] is [(t',st')] where [t'] and [st'] are
   [t] and [st] after receiving [c].*)
val receive_command : command -> t -> Adventure.t -> State.t -> (t * State.t)
