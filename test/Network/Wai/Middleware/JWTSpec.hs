{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE OverloadedStrings #-}
module Network.Wai.Middleware.JWTSpec
    ( main
    , spec
    ) 
  where

import           Network.Wai.Middleware.JWT (jwt)
import           Test.Hspec
import           Test.Hspec.Wai

import           Network.HTTP.Types
import           Network.Wai

sample :: Application
sample _ sendRsp = do
    sendRsp $ responseLBS status200 [] mempty

main :: IO ()
main = hspec spec

spec :: Spec
spec = do 
    describe "Test Some JWT Tokens" $ (with $ return (jwt "secret" "x-access-token" sample)) $ do
        it "Should return 401 without token" $ do
            get "/" `shouldRespondWith` 401
        it "Should return 401 with expired token" $ do
            get_with_header "/" [("x-access-token", "")] `shouldRespondWith` 401
        it "Should return 200 with valid token" $ do
            get_with_header "/" [("x-access-token", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDAwMDAwMDB9.RmlmMt-7TAVRfiZdflgAhiqY8yVZPA0lKZlIjU_HIQI")] 
                `shouldRespondWith` 200

get_with_header path header = request methodGet path header ""
