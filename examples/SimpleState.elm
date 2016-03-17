module SimpleState
  ( State, Direction
  , map, pos, player
  , toMap, moveTo
  ) where

import Focus exposing (Focus)
import Matrix exposing (Matrix, Location)

import State exposing ((^.))


type alias Direction =
  { x : Int
  , y : Int
  }

type alias State a =
  { map_ : Matrix a
  , pos_ : Location
  , player_ : a
  }


map : Focus (State a) (Matrix a)
map = Focus.create .map_ (\f s -> { s | map_ = f s.map_ })

pos : Focus (State a) Location
pos = Focus.create .pos_ (\f s -> { s | pos_ = f s.pos_ })

player : Focus (State a) a
player = Focus.create .player_ (\f s -> { s | player_ = f s.player_ })


toMap : State a -> Matrix a
toMap s =
  Matrix.set s.pos_ s.player_ s.map_


moveTo : (a -> Bool) -> Direction -> State a -> State a
moveTo test dir state =
  let
    newState = move dir state
  in
    if isPosInBounds newState && isPosValid test newState
    then newState
    else state


move : Direction -> State a -> State a
move d =
  Focus.update pos
         (\p -> Matrix.loc
            (Matrix.row p - d.y)
            (Matrix.col p + d.x))


isPosValid : (a -> Bool) -> State a -> Bool
isPosValid p s =
  Maybe.withDefault False <| Maybe.map p <| Matrix.get s.pos_ s.map_


isPosInBounds : State a -> Bool
isPosInBounds state =
  let
    m = state ^. map
    p = state ^. pos
    col = Matrix.col p
    row = Matrix.row p
  in
    col >= 0
    && row >= 0
    && col < Matrix.colCount m
    && row < Matrix.rowCount m
