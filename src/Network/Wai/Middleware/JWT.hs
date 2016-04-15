{-# LANGUAGE PostfixOperators #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
module Network.Wai.Middleware.JWT
    ( rewrite
    ) 
  where

import           Network.Wai
import           Web.JWT
import qualified Network.HTTP.Types as H

rewrite :: Middleware
rewrite app req sendRsp = do
    case (requestMethod req) of
        m | m == H.methodPost -> do
            if "x-access-token" `elem` (map fst $ requestHeaders req)
                then app req sendRsp
                else app req $ sendRsp . mapResponseStatus (const H.status401)
          | m == H.methodGet -> do
            app req $ sendRsp 
                . mapResponseHeaders f 
                . mapResponseHeaders (("Location", "https://google.com") :) 
                . mapResponseStatus (const H.status302)
        _ -> do
            sendRsp $ responseLBS H.status401 [] mempty
  where 
    f headers = 
        maybe 
            ((jwtKey, "_token"):headers)
            (const headers)
            (lookup jwtKey headers)

jwtKey = "x-access-token"

jwt :: Middleware
jwt app req sendRsp = 
    maybe 
        (app req $ sendRsp 
            . mapResponseStatus (const $ H.status401)
        )
        (const $ app req sendRsp)
        (lookup jwtKey headers)
  where
    headers = requestHeaders req
