{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Network.Wai
import           Network.HTTP.Types (status200)
import           Network.Wai.Middleware.JWT (jwt)
import           Network.Wai.Handler.Warp (run)

app :: Application
app _ sendRsp = do
    sendRsp $ responseLBS 
        status200
        []
        mempty

main :: IO ()
main = run 3000 $ jwt "secret" "x-access-token" app
