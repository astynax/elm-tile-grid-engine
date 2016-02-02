module Sparkle where

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
  , updates = Keyboard.arrows |> Signal.map (State.moveTo (\_ -> True))
  }

initialState : State.State Int
initialState =
  { map =
      Matrix.fromList
      [ [ 0, 0, 0, 0 ]
      , [ 0, 1, 2, 3 ]
      , [ 0, 0, 0, 4 ]
      , [ 0, 0, 0, 5 ]
      ]
  , pos = Matrix.loc 3 2
  , player = 10
  }

tileSet : Game.TileSet Int
tileSet =
  { size = (24, 24)
  , default = "image/darkness.png"
  , tiles =
      Dict.fromList
            [ (1, "image/fire1.png")
            , (2, "image/fire2.png")
            , (3, "image/fire3.png")
            , (4, "image/fire4.png")
            , (5, "image/fire5.png")
            , (10, "image/sparkle1.png")
            , (11, "image/sparkle2.png")
            ]
  }
