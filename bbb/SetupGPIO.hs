module SetupGPIO where

import System.IO
import Control.Monad
import System.Directory

import Common

main :: IO ()
main = do
  mapM_ (exportPin) threePins
  
  
exportPin :: Pin -> IO ()
exportPin p = let dir = pinBaseDir p in 
  do
    dAlready <- doesDirectoryExist dir
    if dAlready 
      then return ()
      else writeFile (gpioBaseDir ++ "export") (show $ pinFullNumber p)
     

