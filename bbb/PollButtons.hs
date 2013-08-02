module Main where

import Control.Monad
import System.ZMQ
import Safe (headMay)
import Data.ByteString hiding (putStrLn, zip, readFile)
import Data.Serialize
import Control.Concurrent (threadDelay)
import Common
import SetupGPIO

type DurationSecs = Double

-- |Timeout value: Intention is to make sure that the client has
-- Enough time to unsubscribe from the publisher after seeing a push.
-- This is NOT meant to enfoce rules about repeated button presses
-- within a round, etc.  That stuff has to be handled by the client.
timeout :: DurationSecs
timeout = 0.5

main :: IO ()
main = do
  mapM_ exportPin threePins
  withContext 1 $ \ctx -> do
    withSocket ctx Pub $ \pub -> do
      bind pub "tcp://*:5227"
      pollPublishPushes pub timeout threePins
      
pollPublishPushes :: Socket Pub -> DurationSecs -> [Pin] -> IO ()
pollPublishPushes sock delaySec pins = forever $ do
  vs <- forM pins (\p -> return . read =<< readFile (pinValueFile p)) 
  let downs = [fst xy | xy <- zip "ABC" vs, snd xy == 1]
  case headMay downs of
    Nothing -> threadDelay 1000
    Just c  -> do
      putStrLn $ "Sending char: " ++ [c]
      send sock (encode c) []
      threadDelay $ floor (timeout * 1000000)