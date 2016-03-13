module Maze where

import Graphics.Element exposing (Element)
import Keyboard
import Signal exposing (Signal)

import Matrix

import TileGridEngine exposing (Update, withUpdates)
import TileGridEngine.TileGrid exposing (Map, TileSet, TileId, grid)

import State exposing (State, Direction)


type Cell
  = F  -- floor
  | B  -- brick
  | P  -- player


main : Signal Element
main =
  Signal.map (grid (4, 4) tiles << Matrix.map toTileId << State.toMap)
  <| initialState `withUpdates` updates


initialState : State Cell
initialState =
  { map =
      Matrix.fromList
      [ [ B, B, F, B ]
      , [ F, F, F, B ]
      , [ B, F, B, B ]
      , [ B, F, F, F ]
      ]
  , pos = Matrix.loc 1 1
  , player = P
  }


updates : Signal (Update (State Cell))
updates =
  Signal.map (State.moveTo ((==) F)) Keyboard.arrows


tiles : TileSet
tiles =
  ( (32, 32)
  , [ (1, "images/brick.png")
    , (2, "images/floor.png")
    , (3, "images/pc_on_floor.png")
    ]
  )


toTileId : Cell -> TileId
toTileId cell =
  case cell of
    F -> 2
    P -> 3
    _ -> 1
