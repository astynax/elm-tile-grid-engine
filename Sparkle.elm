module Sparkle where

import Signal exposing (Signal)
import Time
import Keyboard

import Matrix

import TileGrid exposing (Update, Screen, TileId)
import State exposing (State, Direction)


type alias Phase = Bool

type Cell
  = Fire Int
  | Floor
  | Player Phase

type alias GameState = State Cell

type alias Evolution = Signal (Update GameState)

type alias FPS = Int


port redraw : Signal Screen
port redraw =
  TileGrid.start
  { state = initialState
  , getMap = State.toMap
  , toTileId = toTileId
  , updates = updates
  }


initialState : GameState
initialState =
  { map = Matrix.matrix 30 40 (\_ -> Floor)
  , pos = Matrix.loc 5 5
  , player = Player True
  }


toTileId : Cell -> TileId
toTileId cell =
  case cell of
    Fire 1 -> 11
    Fire 2 -> 12
    Fire 3 -> 13
    Fire 4 -> 14
    Fire 5 -> 15
    Player True -> 21
    Player False -> 22
    _ -> 0


updates : Evolution
updates =
  let
    (<>) = TileGrid.mergeUpdates
  in
    ( movement
        <> (3 `timesPerSec` playerBlinking)
        <> (5 `timesPerSec` flameDying)
    ) `andAfter` putFlameAtPlayerPos


movement : Evolution
movement =
  let
    keys = Keyboard.arrows
    autorepeat = Signal.sampleOn (Time.fps 5)
  in
    Signal.merge keys (autorepeat keys)
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
