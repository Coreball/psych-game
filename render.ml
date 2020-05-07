open Adventure
open State
open ANSITerminal

let hide_cursor () = printf [] "\027[?25l%!"

let rec print_choices_rec input pos l =
  let style = if (input = pos) then [Inverse] else [] in
  match l with
  | [] -> ()
  | h::t ->
    print_string style h; move_cursor 1 0;
    print_choices_rec input (pos + 1) t

let print_choices input adv current_room =
  print_choices_rec input 0 (choices adv current_room)

let draw input adv st =
  let current_room = current_room_id st in
  erase Screen;
  hide_cursor ();
  set_cursor 1 1;
  print_endline (description adv current_room);
  move_cursor 2 1;
  print_choices input adv current_room
