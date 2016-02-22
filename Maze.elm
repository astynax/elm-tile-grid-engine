module Maze where

import Signal exposing (Signal)
import Keyboard

import Matrix

import TileGrid exposing (TileSet, Screen)
import State exposing (State, Direction)

type Cell
  = F  -- floor
  | B  -- brick
  | P  -- player

port updates : Signal Screen
port updates =
  TileGrid.start
  { state = initialState
  , getMap = State.toMap
  , tileSet = tileSet
  , updates =
      Signal.map (State.moveTo ((==) F))
      <| Keyboard.arrows
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
  , toID = \cell ->
      case cell of
        F -> 1
        P -> 2
        _ -> 0
  }
