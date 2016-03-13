module TileGridEngine
  ( Update, withUpdates, mergeUpdates, (<|>)
  )  where

import Maybe exposing (Maybe)
import Signal exposing (Signal)

import Signal.Extra as Signal

import TileGridEngine.TileGrid as Grid exposing (Map)


type alias Update state = state -> Maybe state


withUpdates : state -> Signal (Update state) -> Signal state
withUpdates state =
  Signal.filterFold (<|) state


mergeUpdates
  : Signal (Update state) -> Signal (Update state) -> Signal (Update state)
mergeUpdates s1 s2 =
  Signal.fairMerge combine s1 s2


(<|>) = mergeUpdates


combine : Update state -> Update state -> Update state
combine u1 u2 =
  let
    try f x = Maybe.withDefault x <| f x
  in
    Just << try u2 << try u1
