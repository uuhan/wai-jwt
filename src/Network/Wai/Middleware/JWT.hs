{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE PostfixOperators #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
module Network.Wai.Middleware.JWT
    ( jwt
    ) 
  where

import           Network.Wai
import           Web.JWT
import           Data.Time.Clock.POSIX (getPOSIXTime)
import qualified Network.HTTP.Types as H
import           Data.Text (Text)
import           Data.ByteString (ByteString)
import           Data.Text.Encoding (decodeUtf8)
import           Data.CaseInsensitive (mk)

import           Prelude hiding (exp)

jwt :: Text -> ByteString -> Middleware
jwt sec jwtKey app req sendRsp = 
    let jwtAuth v = do
            maybe
                (sendRsp reject)
                (ifExpired . claims)
                (decodeAndVerifySignature (secret sec) v)

        ifExpired :: JWTClaimsSet -> IO ResponseReceived
        ifExpired JWTClaimsSet{..} = do
            curr <- round <$> getPOSIXTime
            if maybe (0) (fromEnum . secondsSinceEpoch) exp <=  curr
                then sendRsp reject
                else app req sendRsp
    in
    maybe 
        (sendRsp reject)
        (jwtAuth . decodeUtf8)
        (lookup (mk jwtKey) headers)
  where
    headers = requestHeaders req

reject :: Response
reject = responseLBS H.status401 [] mempty
