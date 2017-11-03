module Main
  ( handler
  ) where

import Prelude (discard)
import Control.Monad.Eff.Exception (Error, message)
import Node.Express.App (App, useOnError, use, get)
import Node.Express.Handler (Handler)
import Node.Express.Response (sendJson, setStatus)
import Network.AWS.Lambda.Express


errorHandler :: forall e. Error -> Handler e
errorHandler err = do
  setStatus 400
  sendJson { error: message err }


notFoundHandler :: forall e. Handler e
notFoundHandler = do
  setStatus 404
  sendJson { error: "resource not found" }


indexHandler :: forall e. Handler e
indexHandler = do
  sendJson { status: "ok" }


app :: forall e. App e
app = do
  get "/" indexHandler
  use notFoundHandler
  useOnError errorHandler


handler :: HttpHandler
handler =
  makeHandler app
