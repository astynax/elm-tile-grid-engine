module Maze where

import Keyboard
import Signal exposing (Signal)
import Time

import Matrix

import TileGrid exposing (Screen, Update)
import State exposing (State, Direction)

type Cell
  = F  -- floor
  | B  -- brick
  | P  -- player

port redraw : Signal Screen
port redraw =
  TileGrid.start
  { state = initialState
  , getMap = State.toMap
  , toTileId = toTileId
  , updates = updates
  }


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


toTileId : Cell -> TileGrid.TileId
toTileId cell =
  case cell of
    F -> 1
    P -> 2
    _ -> 0


updates : Signal (Update (State Cell))
updates =
  let
    movement =
      Signal.map (State.moveTo ((==) F))
      <| Keyboard.arrows
  in
    Signal.merge rerfesh movement


-- TODO: remove when I find a way to do a first (and alone) refresh
rerfesh : Signal (Update (State Cell))
rerfesh =
  Signal.map (always Maybe.Just) <| Time.fps 10
