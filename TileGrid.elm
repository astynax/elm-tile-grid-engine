module TileGrid
  ( App, start
  , Update, TileMap, TileAsset, TileSize, TileSet
  , mergeUpdates, combine
  ) where

import Maybe exposing (Maybe)
import Signal exposing (Signal)
import String

import Html exposing (Html)
import Html.Attributes exposing (src, style)
import Signal.Extra as Signal


type alias App state cell =
  { state : state
  , getMap : state -> TileMap cell
  , updates : Signal (Update state)
  , tileSet : TileSet cell
  }

type alias TileMap cell = List (List cell)

type alias Update state = state -> Maybe state

type alias TileAsset = String

type alias TileSize = (Int, Int)

type alias TileSet cell =
  { size : TileSize
  , toTile : cell -> TileAsset
  }


start : App state cell -> Signal Html
start app =
  Signal.map (\g -> render g.tileSet <| g.getMap g.state)
  <| Signal.filterFold updateState app app.updates


render : TileSet cell -> TileMap cell -> Html
render ts map =
  let
    toPx x = String.append (toString x) "px"
    width =
      (*) (fst ts.size)
      <| Maybe.withDefault 0
      <| Maybe.map List.length
      <| List.head map
  in
    Html.div
    [ style [("width", toPx width)] ]
    <| List.map
         (\c ->
            Html.div
            [ style [ ("width", toPx <| fst ts.size)
                    , ("height", toPx <| snd ts.size)
                    , ("float", "left")
                    ] ]
            [ Html.img [ src (ts.toTile c) ] [] ]
         )
    <| List.concat map


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
