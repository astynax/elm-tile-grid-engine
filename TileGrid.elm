module TileGrid
  ( App, start
  , Update, TileMap, TileID, TileSize, TileSet, Screen
  , mergeUpdates, combine
  ) where

import Maybe exposing (Maybe)
import Signal exposing (Signal)

import Signal.Extra as Signal


type alias App state cell =
  { state : state
  , getMap : state -> TileMap cell
  , updates : Signal (Update state)
  , tileSet : TileSet cell
  }

type alias TileMap cell = List (List cell)

type alias Screen = List (List TileID)

type alias Update state = state -> Maybe state

type alias TileID = Int

type alias TileSize = (Int, Int)

type alias TileSet cell =
  { size : TileSize
  , toID : cell -> TileID
  }


start : App state cell -> Signal Screen
start app =
  Signal.map (\g -> render g.tileSet <| g.getMap g.state)
  <| Signal.filterFold updateState app app.updates


render : TileSet cell -> TileMap cell -> Screen
render ts =
  List.map (List.map ts.toID)


updateState : Update state -> App state cell -> Maybe (App state cell)
updateState update app =
  Maybe.map (\s -> { app | state = s}) <| update app.state


mergeUpdates
  : Signal (Update state) -> Signal (Update state) -> Signal (Update state)
mergeUpdates s1 s2 =
  Signal.fairMerge combine s1 s2


combine : Update state -> Update state -> Update state
combine u1 u2 =
  let
    try f x = Maybe.withDefault x <| f x
  in
    Just << try u2 << try u1
