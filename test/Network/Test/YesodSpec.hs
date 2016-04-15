{-# LANGUAGE OverloadedStrings #-}
module Network.Test.YesodSpec
    ( main
    , spec
    ) 
  where

import           Test.Hspec
import           Test.Hspec.Wai
import           Network.Test.Yesod (yesod_site)

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "Yesod" $ with yesod_site $ do
        it "[GET /] should return 200" $ do
            get "/" `shouldRespondWith` 200
