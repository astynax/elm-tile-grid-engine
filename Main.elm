module Main where

import Dict
import Signal exposing (Signal)
import Keyboard

import Html exposing (Html)
import Matrix

import Game
import State exposing (State, Direction)

main : Signal Html
main =
  Game.start
  { state = initialState
  , getMap = State.toMap
  , tileSet = tileSet
  , updates = Keyboard.arrows |> Signal.map (State.moveTo (\x -> x == "F"))
  }

initialState : State.State String
initialState =
  { map =
      Matrix.fromList
      [ [ "B", "B", "F", "B" ]
      , [ "F", "F", "F", "B" ]
      , [ "B", "F", "B", "B" ]
      , [ "B", "F", "F", "F" ]
      ]
  , pos = Matrix.loc 1 1
  , player = "P"
  }

tileSet : Game.TileSet String
tileSet =
  { size = (32, 32)
  , default = "image/brick.png"
  , tiles =
      Dict.fromList
            [ ("F", "image/floor.png")
            , ("P", "image/pc_on_floor.png")
            ]
  }
