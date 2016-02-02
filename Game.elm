module Game
  ( Game, GameMap, Update, TileAsset, TileSet
  , start
  ) where

import Dict exposing (Dict)
import Maybe exposing (Maybe)
import Signal exposing (Signal)
import String

import Html exposing (Html)
import Html.Attributes exposing (src, style)

type alias Game a comparable =
  { state : a
  , getMap : a -> GameMap comparable
  , updates : Signal (Update a)
  , tileSet : TileSet comparable
  }

type alias GameMap a = List (List a)

type alias Update a = a -> Maybe a

type alias TileAsset = String

type alias TileSet comparable =
  { size : (Int, Int)
  , default : TileAsset
  , tiles : Dict comparable TileAsset
  }


start : Game a comparable -> Signal Html
start game =
  Signal.map (\g -> render g.tileSet <| g.getMap g.state)
  <| Signal.foldp
       (\update g ->
          { g | state = Maybe.withDefault g.state <| update g.state })
         game
         game.updates


render : TileSet comparable -> GameMap comparable -> Html
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
            [ Html.img [ src (assetFor ts c) ] [] ]
         )
    <| List.concat map


assetFor : TileSet comparable -> comparable -> TileAsset
assetFor ts t =
  Maybe.withDefault ts.default <| Dict.get t ts.tiles
