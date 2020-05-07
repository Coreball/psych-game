open Adventure

type loc = Inventory | Room of room_id

type item_loc = {
  item_id : item_id;
  loc : loc;
}

type t = {
  curr : room_id;
  hist : room_id list;
  locs : item_loc list;
}

(** [move_room room st] is [st] with [room] as the current room, adding it to
    the history of rooms in [st] if it is not already there *)
let move_room room st = {
  curr = room;
  hist = if List.mem room st.hist then st.hist else room::st.hist;
  locs = st.locs
}

(** [take_item item st] is [st] with [item] in the inventory if [item] is
    present in the current room of [st].
    Raises: [Not_found] if [item] is not in the list of items or
    if [item] is not located in the current room. *)
let take_item item st = {
  st with
  locs =
    let wanted_item = (List.find (fun i -> i.item_id = item) st.locs) in
    if wanted_item.loc = Room st.curr
    then {item_id = wanted_item.item_id; loc = Inventory}
         :: List.filter (fun i -> i <> wanted_item) st.locs
    else raise Not_found
}

(** [drop_item item st] is [st] with after dropping [item] in the current room.
    Raises: [Not_found] if [item] is not in the list of items or
    if [item] is not in the inventory. *)
let drop_item item st = {
  st with
  locs =
    let wanted_item = (List.find (fun i -> i.item_id = item) st.locs) in
    if wanted_item.loc = Inventory
    then {item_id = wanted_item.item_id; loc = Room st.curr}
         :: List.filter (fun i -> i <> wanted_item) st.locs
    else raise Not_found
}

let init_state adv =
  let locs = List.map (fun i ->
      {item_id = fst i; loc = Room (snd i)}) (items adv) in
  move_room (start_room adv) {curr = ""; hist = []; locs = locs}

let current_room_id st =
  st.curr

let visited st =
  st.hist

let current_inventory st =
  List.filter (fun i -> i.loc = Inventory) st.locs
  |> List.map (fun i -> i.item_id)

let current_room_items st =
  List.filter (fun i -> i.loc = Room st.curr) st.locs
  |> List.map (fun i -> i.item_id)

(** [calc_score_rooms adv rooms acc] calculates the score of [st]
    from which rooms have been visited so far based on [adv] *)
let rec calc_score_rooms adv rooms acc =
  match rooms with
  | [] -> acc
  | h :: t -> calc_score_rooms adv t (acc + score adv h)

(** [calc_score_items adv items acc] calculates the score of [st]
    from the location of items based on target location in [adv] *)
let rec calc_score_items adv items acc =
  match items with
  | [] -> acc
  | h :: t -> calc_score_items adv t
                (if h.loc = Room (item_target adv h.item_id)
                 then acc + item_pts adv h.item_id
                 else acc)

let calc_score adv st =
  (calc_score_rooms adv st.hist 0) + (calc_score_items adv st.locs 0)

let all_items_correct adv st =
  List.for_all (fun i -> i.loc = Room (item_target adv i.item_id)) st.locs

type result = Legal of t | Illegal

let go ex adv st =
  try Legal (move_room (next_room adv st.curr ex) st) with
  | UnknownRoom _ | UnknownChoice _ -> Illegal

let take item st =
  try Legal (take_item item st) with
  | Not_found -> Illegal

let drop item st =
  try Legal (drop_item item st) with
  | Not_found -> Illegal
