open Yojson.Basic.Util

type room_id = string
type choice_name = string
type points = int
exception UnknownRoom of room_id
exception UnknownChoice of choice_name

(** The values representing choices. *)
type choice = {
  name : choice_name;
  room_id : room_id;
}

(** The values representing rooms. *)
type room = {
  id : room_id;
  description : string;
  score : points;
  choices : choice list;
}

type t = {
  rooms : room list;
  start_room : room_id;
  win_msg : string;
}

(** [choice_of_json j] is the choice that [j] represents. *)
let choice_of_json j = {
  name = j |> member "name" |> to_string;
  room_id = j |> member "room id" |> to_string;
}

(** [room_of_json j] is the room that [j] represents. *)
let room_of_json j = {
  id = j |> member "id" |> to_string;
  description = j |> member "description" |> to_string;
  score = j |> member "score" |> to_int;
  choices = j |> member "choices" |> to_list |> List.map choice_of_json;
}

(** [adventure_of_json j] is the adventure that [j] represents. *)
let adventure_of_json j = {
  rooms = j |> member "rooms" |> to_list |> List.map room_of_json;
  start_room = j |> member "start room" |> to_string;
  win_msg = j |> member "win message" |> to_string;
}

(** [room_exists a r] checks if room with id [r] exists in adventure [a]. *)
let room_exists a r =
  List.exists (fun room -> room.id = r) a.rooms

(** [room_wid a r] is room with id [r] in adventure [a].
    Requires: [r] exists in [a]. *)
let room_wid a r =
  List.find (fun room -> room.id = r) a.rooms

let from_json j =
  try j |> adventure_of_json
  with Type_error (s, _) -> failwith ("Parsing error: " ^ s)

let start_room adv =
  adv.start_room

let room_ids adv =
  List.map (fun room -> room.id) adv.rooms |> List.sort_uniq compare

let description adv room =
  if room_exists adv room then (room_wid adv room).description
  else raise (UnknownRoom room)

let score adv room =
  if room_exists adv room then (room_wid adv room).score
  else raise (UnknownRoom room)

let choices adv room =
  if room_exists adv room then
    List.map (fun choice -> choice.name) (room_wid adv room).choices
    |> List.sort_uniq compare
  else raise (UnknownRoom room)

let next_room adv room ex =
  if room_exists adv room then
    let room_choices = (room_wid adv room).choices in
    try (List.find (fun choice -> choice.name = ex) room_choices).room_id with
    | Not_found -> raise (UnknownChoice ex)
  else raise (UnknownRoom room)

let next_rooms adv room =
  if room_exists adv room then
    List.map (fun choice -> choice.room_id) (room_wid adv room).choices
    |> List.sort_uniq compare
  else raise (UnknownRoom room)

let win_msg adv =
  adv.win_msg
