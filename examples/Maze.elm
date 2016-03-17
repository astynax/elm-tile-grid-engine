module Maze where

import Graphics.Element exposing (Element)
import Keyboard
import Signal exposing (Signal)

import Matrix

import TileGridEngine.TileGrid exposing (Map, TileSet, TileId, grid)

import State exposing (View, Update)

import SimpleState exposing (State, Direction)


type Cell
  = F  -- floor
  | B  -- brick
  | P  -- player


main : Signal Element
main =
  State.start initialState view updates


initialState : State Cell
initialState =
  { map_ =
      Matrix.fromList
      [ [ B, B, F, B ]
      , [ F, F, F, B ]
      , [ B, F, B, B ]
      , [ B, F, F, F ]
      ]
  , pos_ = Matrix.loc 1 1
  , player_ = P
  }


view : View (State Cell) Element
view _ = grid (4, 4) tiles << Matrix.map toTileId << SimpleState.toMap


updates : Signal (Update (State Cell))
updates =
  Signal.map (SimpleState.moveTo ((==) F)) Keyboard.arrows


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
