(** 
   Representation of static adventure data.

   This module represents the data stored in adventure files, including
   the rooms and choices.  It handles loading of that data from JSON as well
   as querying the data.
*)

(** The abstract type of values representing adventures. *)
type t

(** The type of room identifiers. *)
type room_id = string

(** The type of choice names. *)
type choice_name = string

(** The type of point identifiers. *)
type points = int

(** The type of item identifiers. *)
type item_id = string

(** Raised when an unknown room is encountered. *)
exception UnknownRoom of room_id

(** Raised when an unknown choice is encountered. *)
exception UnknownChoice of choice_name

(** Raised when an unknown item is encountered. *)
exception UnknownItem of item_id

(** [from_json j] is the adventure that [j] represents.
    Requires: [j] is a valid JSON adventure representation. *)
val from_json : Yojson.Basic.t -> t

(** [start_room a] is the identifier of the starting room in adventure 
    [a]. *)
val start_room : t -> room_id

(** [room_ids a] is a set-like list of all of the room identifiers in 
    adventure [a]. *)
val room_ids : t -> room_id list

(** [description a r] is the description of room [r] in adventure [a]. 
    Raises [UnknownRoom r] if [r] is not a room identifier in [a]. *)
val description : t -> room_id -> string

(** [score a r] is the score of room [r] in adventure [a].
    Raises [UnknownRoom r] if [r] is not a room identifier in [a]. *)
val score : t -> room_id -> int

(** [items a] is the list of (thing, start) for items in adventure [a]. *)
val items : t -> (item_id * room_id) list

(** [item_target a i] is the target room id of [i] in adventure [a]. *)
val item_target : t -> item_id -> room_id

(** [item_pts a i] is the points score of item [i] in adventure [a].
    Raises [UnknownItem i] if [i] is not an item in [a]. *)
val item_pts : t -> item_id -> int

(** [choices a r] is a set-like list of all choice names from room [r] in 
    adventure [a].
    Raises [UnknownRoom r] if [r] is not a room identifier in [a]. *)
val choices : t -> room_id -> choice_name list

(** [next_room a r e] is the room to which [e] choices from room [r] in
    adventure [a].
    Raises [UnknownRoom r] if [r] is not a room identifier in [a].
    Raises [UnknownChoice e] if [e] is not an choice from room [r] in [a]. *)
val next_room : t -> room_id -> choice_name -> room_id

(** [next_rooms a r] is a set-like list of all rooms to which there is an choice
    from [r] in adventure [a].
    Raises [UnknownRoom r] if [r] is not a room identifier in [a].*)
val next_rooms : t -> room_id -> room_id list

(** [win_msg a] is the win message for adventure [a]. *)
val win_msg : t -> string
