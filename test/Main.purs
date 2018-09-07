module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Variant as Variant
import Effect (Effect)
import Effect.Console (error, log)
import Effect.Ref as Ref
import Record as Record
import ReduxDevTools as DT
import Simple.JSON as JSON
import Type.Prelude (SProxy(..))

type State =
  { count :: Int
  }

initialState :: State
initialState =
  { count: 0
  }

type Action = Variant.Variant
  ( add :: Int
  , sub :: Int
  )

countS = SProxy :: SProxy "count"
addS = SProxy :: SProxy "add"
subS = SProxy :: SProxy "sub"

update :: Action -> State -> State
update action s = Variant.match
  { add: \x -> Record.modify countS (add x) s
  , sub: \x -> Record.modify countS (sub x) s
  } action

main :: Effect Unit
main = do
  mExt <- DT.getExtension
  case mExt of
    Just ext -> do
      log "Found extension"

      -- make instance
      inst <- DT.connect ext (DT.mkConnectOptions {})

      -- feed initial state to DevTools
      DT.init inst (JSON.write initialState)

      -- ref where i'll keep my state in this example
      ref <- Ref.new initialState

      let handle' = handle inst ref
      handle' (add_ 1)
      handle' (sub_ 1)
      handle' (add_ 1)

      -- listen and just print out what we get from DevTools
      DT.subscribe inst (log <<< JSON.writeJSON)
    Nothing -> do
      error "No extension found"
  where
    -- handler that will modify my state ref
    handle inst ref action = do
      s <- Ref.modify (update action) ref
      log $ "New action: " <> JSON.writeJSON action
      log $ "New state: " <> JSON.writeJSON s

      DT.send inst { state: JSON.write s, action: JSON.write action }


    add_ = Variant.inj addS
    sub_ = Variant.inj subS
