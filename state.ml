open Adventure

type t = {
  curr : room_id;
  hist : room_id list;
}

(** [move_room room st] is [st] with [room] as the current room, adding it to
    the history of rooms in [st] if it is not already there *)
let move_room room st = {
  curr = room;
  hist = if List.mem room st.hist then st.hist else room::st.hist;
}

let init_state adv =
  move_room (start_room adv) {curr = ""; hist = []}

let current_room_id st =
  st.curr

let visited st =
  st.hist

(** [calc_score_rooms adv rooms acc] calculates the score of [st]
    from which rooms have been visited so far based on [adv] *)
let rec calc_score_rooms adv rooms acc =
  match rooms with
  | [] -> acc
  | h :: t -> calc_score_rooms adv t (acc + score adv h)

let calc_score adv st =
  calc_score_rooms adv st.hist 0

type result = Legal of t | Illegal

let go ex adv st =
  try Legal (move_room (next_room adv st.curr ex) st) with
  | UnknownRoom _ | UnknownChoice _ -> Illegal
