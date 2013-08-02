module Main where

import Control.Monad
import qualified System.ZMQ as Z
import qualified Data.ByteString as B

main :: IO ()
main = do
  Z.withContext 1 $ \ctx -> do
    Z.withSocket ctx Z.Sub $ \sock -> do
      Z.connect sock "tcp://10.121.43.229:5227"
      Z.subscribe sock ""
      putStrLn "Handling data."
      handleMessages sock

handleMessages :: Z.Socket a -> IO ()
handleMessages sock = forever $ do
  putStrLn "Awaiting message"
  m <- Z.receive sock []
  putStrLn $ show m