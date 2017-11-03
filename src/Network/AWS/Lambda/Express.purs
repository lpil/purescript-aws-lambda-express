module Network.AWS.Lambda.Express
  ( HttpHandler
  , makeHandler
  ) where

import Prelude (pure, bind, discard)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Unsafe as Eff
import Data.Function (applyFlipped)
import Data.Functor (map)
import Node.Express.App (App)
import Node.Express.App as App
import Node.Express.Types (Application, ExpressM, EXPRESS)

foreign import data HttpHandler :: Type

foreign import data Server :: Type

foreign import createServer :: Application -> Server

foreign import proxy :: Server -> HttpHandler

foreign import makeApplication :: forall e. ExpressM e Application

infixl 1 applyFlipped as |>


buildApp :: forall e. App e -> Eff (express :: EXPRESS | e) Application
buildApp appActions = do
  app <- makeApplication
  App.apply appActions app
  pure app


makeHandler :: forall e. App e -> HttpHandler
makeHandler appActions =
  appActions
    |> buildApp
    |> map createServer
    |> map proxy
    |> Eff.unsafePerformEff
