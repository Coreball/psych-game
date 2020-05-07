type object_phrase = string list

type command =
  | Go of object_phrase
  | Take of object_phrase
  | Drop of object_phrase
  | Inv
  | Score
  | Quit

exception Empty

exception Malformed

let parse str =
  let ws = str |> String.split_on_char ' ' |> List.filter (fun w -> w <> "") in
  match ws with
  | [] -> raise Empty
  | "go"::[] -> raise Malformed
  | "go"::t -> Go t
  | "take"::[] -> raise Malformed
  | "take"::t -> Take t
  | "drop"::[] -> raise Malformed
  | "drop"::t -> Drop t
  | "inventory"::[] -> Inv
  | "inventory"::_ -> raise Malformed
  | "score"::[] -> Score
  | "score"::_ -> raise Malformed
  | "quit"::[] -> Quit
  | "quit"::_ -> raise Malformed
  | _ -> raise Malformed
