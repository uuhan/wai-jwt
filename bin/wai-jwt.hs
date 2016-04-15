{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Network.Test.Yesod (yesod_site)
import           Network.Wai.Middleware.JWT (jwt)
import           Network.Wai.Handler.Warp (run)

main :: IO ()
main = yesod_site >>= run 3000 . jwt "secret" "x-access-token"
