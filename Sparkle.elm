module Sparkle where

import Signal exposing (Signal)
import Time
import Keyboard

import Html exposing (Html)
import Matrix

import TileGrid exposing (TileSet)
import State exposing (State, Direction)

type alias FPS = Int

type alias Phase = Bool

type alias GameState = State Cell

type alias Evolution = Signal (TileGrid.Update GameState)

type Cell
  = Fire Int
  | Floor
  | Player Phase


main : Signal Html
main =
  let
    (<>) = TileGrid.mergeUpdates
  in
    TileGrid.start
    { state = initialState
    , getMap = State.toMap
    , tileSet = tileSet
    , updates =
        ( movement
            <> (3 `timesPerSec` playerBlinking)
            <> (5 `timesPerSec` flameDying)
        ) `andAfter` putFlameAtPlayerPos
    }

initialState : GameState
initialState =
  { map = Matrix.square 11 (\_ -> Floor)
  , pos = Matrix.loc 5 5
  , player = Player True
  }


tileSet : TileSet Cell
tileSet =
  { size = (24, 24)
  , toTile = \cell ->
      case cell of
        Fire 1 -> "image/fire1.png"
        Fire 2 -> "image/fire2.png"
        Fire 3 -> "image/fire3.png"
        Fire 4 -> "image/fire4.png"
        Fire 5 -> "image/fire5.png"
        Player True -> "image/sparkle1.png"
        Player False -> "image/sparkle2.png"
        _ -> "image/darkness.png"
  }

movement : Evolution
movement =
  Keyboard.arrows
    |> Signal.map (State.moveTo (\_ -> True))


playerBlinking : GameState -> GameState
playerBlinking state =
  { state | player =
      case state.player of
        Player p -> Player (not p)
        _ -> state.player
  }

flameDying : GameState -> GameState
flameDying state =
  { state | map =
      Matrix.map
      (\cell -> case cell of
                  Fire 1 -> Fire 2
                  Fire n -> Fire (n - 1)
                  _ -> cell
      )
      state.map
  }

timesPerSec : FPS -> (GameState -> GameState) -> Evolution
timesPerSec fps update =
  Time.fps fps
    |> Signal.map
       (\_ state -> Just <| update state )


andAfter : Evolution -> (GameState -> GameState) -> Evolution
andAfter evo update =
  Signal.map (\u state -> Maybe.map update <| u state) evo


putFlameAtPlayerPos : GameState -> GameState
putFlameAtPlayerPos state =
  { state | map = Matrix.set state.pos (Fire 5) state.map }
