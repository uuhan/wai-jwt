module Main (main) where

import           Network.Test.Yesod (yesod_site)
import           Network.Wai.Middleware.JWT (rewrite)
import           Network.Wai.Handler.Warp (run)

main :: IO ()
main = yesod_site >>= run 3000 . rewrite
