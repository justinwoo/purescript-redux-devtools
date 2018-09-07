module ReduxDevTools where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried as EU
import Foreign (Foreign)
import Prim.Row as Row
import Unsafe.Coerce (unsafeCoerce)

-- | The actual Redux DevTools Extension object, retrieved with `getExtension`
foreign import data Extension :: Type

-- | An instance of Redux DevTools, typically created with `connect`
foreign import data Instance :: Type

-- | Get the Redux DevTools Extension object, Maybe for the value being missing
getExtension :: Effect (Maybe Extension)
getExtension = Nullable.toMaybe <$> _getExtension

-- | Get an instance that attaches to Redux DevTools
connect :: Extension -> ConnectOptions -> Effect Instance
connect = EU.runEffectFn2 _connect

subscribe :: Instance -> (Message -> Effect Unit) -> Effect Unit
subscribe inst cb = EU.runEffectFn2 _subscribe inst (EU.mkEffectFn1 cb)

-- | Messages from Redux DevTools on events for `subscribe`
type Message =
  { id :: InstanceId
  , payload :: Foreign
  , source :: String -- | usually "@devtools-extension"
  , state :: State
  , "type" :: String -- | usually "DISPATCH" or "ACTION", "START"/"STOP" on toggle
  }

-- | Instance Id used by Redux DevTools
type InstanceId = String

unsubscribe :: Instance -> Effect Unit
unsubscribe = EU.runEffectFn1 _unsubscribe

send :: Instance -> { state :: State, action :: Action } -> Effect Unit
send inst {action, state} = EU.runEffectFn3 _send inst action state

send' :: Instance -> Action -> State -> Effect Unit
send' = EU.runEffectFn3 _send

init :: Instance -> State -> Effect Unit
init = EU.runEffectFn2 _init

error :: Instance -> String -> Effect Unit
error = EU.runEffectFn2 _error

-- | Redux DevTools `connect` options
foreign import data ConnectOptions :: Type

-- | make Redux DevTools Connect Options by specifying any subset of options
mkConnectOptions :: forall r r'. Row.Union r r' AllConnectOptions => { | r } -> ConnectOptions
mkConnectOptions = unsafeCoerce

-- | Options that may be passed to Redux DevTools `connect`
-- | See <https://github.com/zalmoxisus/redux-devtools-extension/blob/master/docs/API/Arguments.md>
-- | Not all options will be completely typed unless contributed. Submit an issue or PR for more.
type AllConnectOptions =
  ( name :: String
  , actionCreators :: Foreign
  , latency :: Milliseconds
  , maxAge :: IntGreaterThanOne
  , actionSanitizer :: Action -> Foreign
  , stateSanitizer :: State -> Foreign
  , actionsBlacklist :: Array String
  , actionsWhitelist :: Array String
  , predicate :: EU.EffectFn2 State Action Boolean
  , shouldRecordChanges :: Boolean
  , features :: FeaturesOptions
  )

-- | A set of feature flags for Redux DevTools `connect` options
foreign import data FeaturesOptions :: Type

-- | make Redux DevTools  Features Options by specifying any subset of options
mkFeaturesOptions :: forall r r'. Row.Union r r' AllFeaturesOptions => { | r } -> FeaturesOptions
mkFeaturesOptions = unsafeCoerce

-- | Options that may be passed to `features` for Redux DevTools `connect` options
-- | See <https://github.com/zalmoxisus/redux-devtools-extension/blob/master/docs/API/Arguments.md#features>
-- | Not all options will be completely typed unless contributed. Submit an issue or PR for more.
type AllFeaturesOptions =
  ( pause :: Boolean
  , lock :: Boolean
  , persist :: Boolean
  , export :: Boolean
  , "import" :: String
  , jump :: Boolean
  , skip :: Boolean
  , reorder :: Boolean
  , dispatch :: Boolean
  , test :: Boolean
  )

-- | Type alias for Foreign that is an Action of your application
type Action = Foreign

-- | Type alias for Foreign that is the State of your application
type State = Foreign

-- | Type alias for Number that is a Millisecond quantity
type Milliseconds = Number

-- | Type alias for Int that is greater than 1
type IntGreaterThanOne = Int

foreign import _getExtension :: Effect (Nullable.Nullable Extension)
foreign import _connect :: EU.EffectFn2 Extension ConnectOptions Instance
foreign import _subscribe :: EU.EffectFn2 Instance (EU.EffectFn1 Message Unit) Unit
foreign import _unsubscribe :: EU.EffectFn1 Instance Unit
foreign import _send :: EU.EffectFn3 Instance Action State Unit
foreign import _init :: EU.EffectFn2 Instance State Unit
foreign import _error :: EU.EffectFn2 Instance String Unit
