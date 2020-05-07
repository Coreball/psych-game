open Adventure
open Command
open State

let read_char () =
  let io = Unix.tcgetattr Unix.stdin in
  let () =
    Unix.tcsetattr Unix.stdin Unix.TCSADRAIN
      { io with Unix.c_icanon = false } in
  let o = input_char stdin in
  Unix.tcsetattr Unix.stdin Unix.TCSADRAIN io;
  o

let char_to_command c =
  match Char.escaped c with
  | " " -> Input.Select
  | "a" -> Input.Left
  | "d" -> Input.Right
  | "q" -> Input.Quit
  | _ -> Input.Unrecognized

let rec play selected adv st =
  Render.draw selected adv st;
  let c = read_char () |> char_to_command in
  let (selected', st') = Input.receive_command c selected adv st in
  play selected' adv st'

let () =
  let adv = "home.json" |> Yojson.Basic.from_file |> from_json in
  let st = adv |> init_state in
  play 0 adv st
