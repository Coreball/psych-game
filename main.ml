open Adventure
open Command
open State

(** [try_go adv choice st] is [st] after taking [choice] in [adv] if available,
    else just the old [st]. *)
let try_go adv choice st =
  let maybe_st = go choice adv st in
  match maybe_st with
  | Legal new_st -> new_st
  | Illegal ->
    ANSITerminal.(print_string [red]
                    ("\nChoice " ^ choice ^ " is not available.\n"));
    st

(** [try_take item st] is [st] after taking [item] in current room if available,
    else just the old [st]. *)
let try_take item st =
  let maybe_st = take item st in
  match maybe_st with
  | Legal new_st ->
    ANSITerminal.(print_string [yellow]
                    ("\nPicked up " ^ item ^ "\n"));
    new_st
  | Illegal ->
    ANSITerminal.(print_string [red]
                    ("\nItem " ^ item ^ " is not available.\n"));
    st

(** [try_drop item st] is [st] after drop [item] in current room if available,
    else just the old [st]. *)
let try_drop item st =
  let maybe_st = drop item st in
  match maybe_st with
  | Legal new_st ->
    ANSITerminal.(print_string [yellow]
                    ("\nDropped " ^ item ^ " in " ^ current_room_id new_st ^ "\n"));
    new_st
  | Illegal ->
    ANSITerminal.(print_string [red]
                    ("\nItem " ^ item ^ " is not in your inventory.\n"));
    st

(** [process_input adv str st] tries to go to a location or quits the game,
    depending on [str], for [adv] and state [st]. *)
let process_input adv str st =
  try let command = parse str in
    match command with
    | Go t ->
      try_go adv (String.concat " " t) st
    | Take t ->
      try_take (String.concat " " t) st
    | Drop t ->
      try_drop (String.concat " " t) st
    | Inv ->
      ANSITerminal.(print_string [yellow]
                      ("\nInventory: " ^ (String.concat ", " (current_inventory st)) ^ "\n"));
      st
    | Score ->
      ANSITerminal.(print_string [yellow]
                      ("\nScore: " ^ string_of_int (calc_score adv st) ^ "\n"));
      st
    | Quit ->
      print_endline "GOODbye";
      exit 0
  with Malformed ->
    ANSITerminal.(print_string [red] "\nDid not recognize command!\n");
    st

let maybe_win adv st =
  if all_items_correct adv st then begin
    ANSITerminal.(print_string [magenta]
                    ("\nVictory! All items placed in target location."
                     ^ win_msg adv ^ " Final score: "
                     ^ string_of_int (calc_score adv st) ^ "\n")); exit 0
  end

(** [game_loop adv st] loops the game for [adv] with state [st] *)
let rec game_loop adv st =
  print_endline ("\n\n" ^ (current_room_id st |> description adv));
  print_string  "\nCurrent location: ";
  ANSITerminal.(print_string [cyan] (current_room_id st ^ "\n"));
  print_string  "You have already visited: ";
  ANSITerminal.(print_string [blue] (String.concat ", " (visited st) ^ "\n"));
  print_string  "Items in this room: ";
  ANSITerminal.(print_string [yellow]
                  (String.concat ", " (current_room_items st) ^ "\n"));
  maybe_win adv st;
  print_string  "Enter input: ";
  ANSITerminal.(print_string [green] "go";
                print_string [default] " <location> | ";
                print_string [yellow] "take";
                print_string [default] " <item> | ";
                print_string [yellow] "drop";
                print_string [default] " <item> | ";
                print_string [yellow] "inventory";
                print_string [default] " | ";
                print_string [yellow] "score";
                print_string [default] " | ";
                print_string [red] "quit");
  print_string  "\n\n> ";
  match read_line () with
  | exception End_of_file -> ()
  | input -> process_input adv input st |> game_loop adv

(** [play_game f] starts the adventure in file [f]. *)
let play_game f =
  let adv = f |> Yojson.Basic.from_file |> from_json in
  let st = adv |> init_state in
  game_loop adv st

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to the Text Adventure Game engine.\n");
  print_endline "Please enter the name of the game file you want to load.\n";
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | file_name -> play_game file_name

(* Execute the game engine. *)
let () = main ()
