module TileGrid
  ( App, TileMap, Update
  , TileAsset, TileSize, TileSet
  , start
  ) where

import Dict exposing (Dict)
import Maybe exposing (Maybe)
import Signal exposing (Signal)
import String

import Html exposing (Html)
import Html.Attributes exposing (src, style)
import Signal.Extra as Signal


type alias App a b =
  { state : a
  , getMap : a -> TileMap b
  , updates : Signal (Update a)
  , tileSet : TileSet b
  }

type alias TileMap a = List (List a)

type alias Update a = a -> Maybe a

type alias TileAsset = String

type alias TileSize = (Int, Int)

type alias TileSet a =
  { size : TileSize
  , toTile : a -> TileAsset
  }


start : App a b -> Signal Html
start app =
  Signal.map (\g -> render g.tileSet <| g.getMap g.state)
  <| Signal.filterFold updateState app app.updates


render : TileSet b -> TileMap b -> Html
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


updateState : Update a -> App a b -> Maybe (App a b)
updateState update app =
  Maybe.map (\s -> { app | state = s}) <| update app.state
