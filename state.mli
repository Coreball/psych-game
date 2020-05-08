(**
   Representation of dynamic adventure state.

   This module represents the state of an adventure as it is being played,
   including the adventurer's current room, the rooms that have been visited,
   and functions that cause the state to change.
*)

(** The abstract type of values representing the game state. *)
type t

(** [init_state a] is the initial state of the game when playing adventure [a].
    In that state the adventurer is currently located in the starting room,
    and they have visited only that room. *)
val init_state : Adventure.t -> t

(** [people_names st] is the list of people *)
val people_names : t -> string list

(** [current_room_id st] is the identifier of the room in which the adventurer
    currently is located in state [st]. *)
val current_room_id : t -> string

(** [visited st] is a set-like list of the room identifiers the adventurer has
    visited in state [st]. The adventurer has visited a room [rm] if their
    current room location is or has ever been [rm]. *)
val visited : t -> string list

(** [calc_score adv st] is the calculated score of [st] in [adv] *)
val calc_score : Adventure.t -> t -> int

(** The type representing the result of an attempted movement. *)
type result = Legal of t | Illegal

(** [go choice adv st] is [r] if attempting to go through choice [choice] in state
    [st] and adventure [adv] results in [r].  If [choice] is an choice from the
    adventurer's current room, then [r] is [Legal st'], where in [st'] the
    adventurer is now located in the room to which [choice] leads.  Otherwise,
    the result is [Illegal].
    Effects: none.  [go] is not permitted to do any printing. *)
val go : Adventure.choice_name -> Adventure.t -> t -> result
