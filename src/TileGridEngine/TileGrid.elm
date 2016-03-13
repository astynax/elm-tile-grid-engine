module TileGridEngine.TileGrid
  ( Dimensions, Map, TileSet, TileId, grid
  ) where

import Array exposing (Array)
import Graphics.Element exposing (Element)

import Native.TileGridEngine.TileGrid


type alias TileId = Int

type alias Dimensions = (Int, Int)

type alias Map = Array (Array TileId)

type alias TileSet = (Dimensions, List (TileId, String))


grid : Dimensions -> TileSet -> Map -> Element
grid = Native.TileGridEngine.TileGrid.grid
