module Main where

import Control.Monad.Eff (Eff)
import Prelude (Unit, bind, const, show, (-), (+), ($))
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onClick)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, span)
import Text.Smolder.Markup (text, (#!))

data Event = Increment | Decrement

type State = Int

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp Increment count = { state: count + 1, effects: [] }
foldp Decrement count = { state: count - 1, effects: [] }

view :: State -> HTML Event
view count =
  div do
    button #! onClick (const Increment) $ text "Increment"
    span $ text (show count)
    button #! onClick (const Decrement) $ text "Decrement"

main :: ∀ fx. Eff ( CoreEffects fx ) Unit
main = do
  app <- start
    { initialState: 0
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
