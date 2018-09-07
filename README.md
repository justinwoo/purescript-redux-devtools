# PureScript-Redux-DevTools

Some bindings to work with Redux DevTools.

This doesn't do any magic and you will have to handle your own encodings to `Foreign` and whatever.

## Example usage

```purs
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
```
