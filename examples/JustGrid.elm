module JustGrid where

import Array
import Graphics.Element exposing (Element, show)
import Signal exposing (Signal)

import TileGridEngine.TileGrid exposing (TileSet, Map, grid)

main : Signal Element
main =
  Signal.constant <| grid (3, 3) tiles map

tiles : TileSet
tiles =
  ( (32, 32)
  , [ (1, "images/brick.png")
    , (2, "images/floor.png")
    , (3, "images/pc_on_floor.png")
    ]
  )

map : Map
map =
  Array.fromList
  <| List.map Array.fromList
       [ [1, 1, 1]
       , [1, 3, 2]
       , [1, 2, 1]
       ]
