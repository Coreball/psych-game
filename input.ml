open Adventure
open State

type t = int

type command =
  | Left
  | Right
  | Select
  | Quit
  | Unrecognized

(** [try_go adv choice st] is [st] after taking [choice] in [adv] if available,
    else just the old [st]. *)
let try_go adv choice st =
  let maybe_st = go choice adv st in
  match maybe_st with
  | Legal new_st -> (0, new_st)
  | Illegal -> (0, st)

let wrap max n =
  let r = n mod max in
  if r >= 0 then r else r + max

let receive_command c t adv st =
  let types = choices adv (current_room_id st) in
  let num_types = types |> List.length in
  match c with
  | Left -> (wrap num_types (t-1), st)
  | Right -> (wrap num_types (t+1), st)
  | Select -> try_go adv (List.nth types t) st
  | Quit -> exit 0
  | Unrecognized -> (t, st)
