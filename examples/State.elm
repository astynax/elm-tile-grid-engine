module State
  ( State, Direction
  , toMap, moveTo
  ) where

import Maybe exposing (Maybe(..))

import Matrix exposing (Matrix, Location)


type alias Direction =
  { x : Int
  , y : Int
  }

type alias State a =
  { map : Matrix a
  , pos : Location
  , player : a
  }

toMap : State a -> Matrix a
toMap s =
  Matrix.set s.pos s.player s.map

moveTo : (a -> Bool) -> Direction -> State a -> Maybe (State a)
moveTo p d s =
  let
    s' = move d s
  in
    if isPosInBounds s' && isPosValid p s'
    then Just s'
    else Nothing

move : Direction -> State a -> State a
move d s =
  { s | pos =
          Matrix.loc
                  (Matrix.row s.pos - d.y)
                  (Matrix.col s.pos + d.x)
  }

isPosValid : (a -> Bool) -> State a -> Bool
isPosValid p s =
  Maybe.withDefault False <| Maybe.map p <| Matrix.get s.pos s.map

isPosInBounds : State a -> Bool
isPosInBounds s =
  let
    col = Matrix.col s.pos
    row = Matrix.row s.pos
  in
    col >= 0
    && row >= 0
    && col < Matrix.colCount s.map
    && row < Matrix.rowCount s.map
