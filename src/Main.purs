module Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Maybe (Maybe(..))
import Prelude (Unit, bind, const, pure, show, (-), (+), ($), (>>=), (<<<))
import Pux (CoreEffects, EffModel, noEffects, onlyEffects, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Random (RANDOM, randomInt)
import Text.Smolder.HTML (button, div, span)
import Text.Smolder.Markup (text, (#!))

data Event = Increment | Decrement | Random | Set Int

type State = Int

type AppEffects = (console :: CONSOLE, random :: RANDOM)

foldp :: Event -> State -> EffModel State Event AppEffects
foldp Decrement count = noEffects $ count - 1
foldp Increment count = noEffects $ count + 1
foldp Random count = onlyEffects count
  [ liftEff $ randomInt 1000 >>= pure <<< Just <<< Set ]
foldp (Set count) _ = noEffects $ count

view :: State -> HTML Event
view count =
  div do
    button #! onClick (const Increment) $ text "Increment"
    span $ text (show count)
    button #! onClick (const Decrement) $ text "Decrement"
    button #! onClick (const Random) $ text "Random"

main :: Eff (CoreEffects AppEffects) Unit
main = do
  app <- start
    { initialState: 0
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
