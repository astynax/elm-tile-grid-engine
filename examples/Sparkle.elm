module Sparkle where

import Graphics.Element exposing (Element)
import Keyboard
import Signal exposing (Signal)
import Time

import Matrix
import Signal.Extra as Signal

import TileGridEngine.TileGrid exposing (Map, TileSet, TileId, grid)

import State exposing (View, Update, (%~), (^.))

import SimpleState exposing (State, Direction)


type alias Phase = Bool

type Cell
  = Fire Int
  | Floor
  | Player Phase

type alias GameState = State Cell

type alias Evolution = Signal (Update GameState)

type alias FPS = Int


main : Signal Element
main =
  State.start initialState view updates


initialState : GameState
initialState =
  { map_ = Matrix.matrix 30 40 <| always Floor
  , pos_ = Matrix.loc 5 5
  , player_ = Player True
  }


view : View GameState Element
view _ = grid (40, 30) tiles << Matrix.map toTileId << SimpleState.toMap


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


tiles : TileSet
tiles =
  ( (24, 24)
  , [ (0, "images/darkness.png")
    , (11, "images/fire1.png")
    , (12, "images/fire2.png")
    , (13, "images/fire3.png")
    , (14, "images/fire4.png")
    , (15, "images/fire5.png")
    , (21, "images/sparkle1.png")
    , (22, "images/sparkle2.png")
    ]
  )


updates : Evolution
updates =
  ( movement
      <> (3 `timesPerSec` playerBlinking)
      <> (5 `timesPerSec` flameDying)
  ) `andThen` putFlameAtPlayerPos


movement : Evolution
movement =
  let
    keys = Keyboard.arrows
    autorepeat = Signal.sampleOn (Time.fps 5)
  in
    Signal.merge keys (autorepeat keys)
    |> Signal.map (SimpleState.moveTo (always True))


playerBlinking : GameState -> GameState
playerBlinking =
  SimpleState.player
    %~ (\p ->
          case p of
            Player p' -> Player (not p')
            _ -> p
       )


flameDying : GameState -> GameState
flameDying =
  SimpleState.map
    %~ Matrix.map
       (\cell ->
          case cell of
            Fire 1 -> Fire 2
            Fire n -> Fire (n - 1)
            _ -> cell
       )


timesPerSec : FPS -> (GameState -> GameState) -> Evolution
timesPerSec fps update =
  Signal.map (always update) <| Time.fps fps


putFlameAtPlayerPos : Update GameState
putFlameAtPlayerPos state =
  state |> SimpleState.map %~ Matrix.set (state ^. SimpleState.pos) (Fire 5)


andThen : Evolution -> Update GameState -> Evolution
andThen ev update = Signal.map ((>>) update) ev


-- TODO: remove after updating elm-state
(<>) : Evolution -> Evolution -> Evolution
(<>) = Signal.fairMerge (<<)
