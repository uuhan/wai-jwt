{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Network.Test.Yesod
    ( yesod_site
    ) 
  where

import           Yesod
import           Yesod.EmbeddedStatic
import           Network.HTTP.Types

mkEmbeddedStatic 
    False
    "eGen"
    [ embedDir "assets" ]

data App = App 
    { getStatic :: EmbeddedStatic
    }

mkYesod "App" [parseRoutes|
/           HomeR   GET POST PUT            
/public     StaticR     EmbeddedStatic getStatic
|]

instance Yesod App where
    makeSessionBackend _ = return Nothing

getHomeR :: Handler ()
getHomeR = do
    sendResponseStatus status200 ()

postHomeR :: Handler ()
postHomeR = do
    sendResponseStatus status200 ()

putHomeR :: Handler ()
putHomeR = do
    sendResponseStatus status200 ()

yesod_site = toWaiApp $ App eGen
