module State
  ( State, Direction
  , toMap, moveTo
  )where

import Maybe exposing (Maybe(..))

import Matrix exposing (Matrix, Location)

type alias Direction =
  { x : Int
  , y : Int
  }

type alias State =
  { map : Matrix String
  , pos : Location
  }

toMap : State -> List (List String)
toMap s =
  Matrix.set s.pos "P" s.map |> Matrix.toList

moveTo : Direction -> State -> Maybe State
moveTo d s =
  let
    s' = move d s
  in
    if isPosValid s' && cellAtPos s' == "F"
    then Just s'
    else Nothing

move : Direction -> State -> State
move d s =
  { s
    | pos = Matrix.loc
            (Matrix.row s.pos - d.y)
            (Matrix.col s.pos + d.x)
  }

cellAtPos : State -> String
cellAtPos s = Maybe.withDefault "" <| Matrix.get s.pos s.map

isPosValid : State -> Bool
isPosValid s =
  let
    col = Matrix.col s.pos
    row = Matrix.row s.pos
  in
    col >= 0
    && row >= 0
    && col < Matrix.colCount s.map
    && row < Matrix.rowCount s.map
