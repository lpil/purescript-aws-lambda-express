module Network.AWS.Lambda.Express
  ( HttpHandler
  , makeHandler
  ) where

import Prelude (pure, bind, discard)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Data.Function (applyFlipped)
import Data.Functor (map)
import Node.Express.App (App)
import Node.Express.App as App
import Node.Express.Types (Application)

foreign import data HttpHandler :: Type

foreign import data Server :: Type

foreign import createServer :: Application -> Server

foreign import proxy :: Server -> HttpHandler
foreign import makeApplication :: Effect Application

infixl 1 applyFlipped as |>


buildApp :: App -> Effect Application
buildApp appActions = do
  app <- makeApplication
  App.apply appActions app
  pure app


makeHandler :: App -> HttpHandler
makeHandler appActions =
  appActions
    |> buildApp
    |> map createServer
    |> map proxy
    |> unsafePerformEffect
