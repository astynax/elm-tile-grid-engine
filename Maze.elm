module Maze where

import Signal exposing (Signal)
import Keyboard

import Html exposing (Html)
import Matrix

import TileGrid exposing (App, TileSet)
import State exposing (State, Direction)

type Cell
  = F  -- floor
  | B  -- brick
  | P  -- player

main : Signal Html
main =
  TileGrid.start
  { state = initialState
  , getMap = State.toMap
  , tileSet = tileSet
  , updates = Keyboard.arrows |> Signal.map (State.moveTo ((==) F))
  }

initialState : State.State Cell
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

tileSet : TileSet Cell
tileSet =
  { size = (32, 32)
  , toTile = \cell ->
      case cell of
        F -> "image/floor.png"
        P -> "image/pc_on_floor.png"
        _ -> "image/brick.png"
  }
