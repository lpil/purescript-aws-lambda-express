module Test.Main
  ( handler
  ) where

import Prelude (discard)
import Effect.Exception (Error, message)
import Node.Express.App (App, useOnError, use, get)
import Node.Express.Handler (Handler)
import Node.Express.Response (sendJson, setStatus)
import Network.AWS.Lambda.Express


errorHandler :: Error -> Handler
errorHandler err = do
  setStatus 400
  sendJson { error: message err }


notFoundHandler :: Handler
notFoundHandler = do
  setStatus 404
  sendJson { error: "resource not found" }


indexHandler :: Handler
indexHandler = do
  sendJson { status: "ok" }


app :: App
app = do
  get "/" indexHandler
  use notFoundHandler
  useOnError errorHandler


handler :: HttpHandler
handler =
  makeHandler app
