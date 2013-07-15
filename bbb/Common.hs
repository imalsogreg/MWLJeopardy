module Common where

data Header         = P8 | P9 deriving (Show)
type GPIOController = Int
type GPIOIndex      = Int

data Pin = Pin Header GPIOController GPIOIndex deriving (Show)

threePins :: [Pin]
threePins = [Pin P9 0 7
            ,Pin P9 1 16
            ,Pin P9 1 18
            ]
            
gpioBaseDir :: FilePath
gpioBaseDir = "/sys/class/gpio/"

pinFullNumber :: Pin -> Int
pinFullNumber (Pin _ c i) = 32 * c + i

pinBaseDir :: Pin -> FilePath
pinBaseDir p =  gpioBaseDir ++ "gpio" ++ show (pinFullNumber p)

pinDirectionFile :: Pin -> FilePath
pinDirectionFile p = (pinBaseDir p) ++ "/direction"

pinValueFile :: Pin -> FilePath
pinValueFile p = (pinBaseDir p) ++ "/value"

physicalLocation :: Pin -> String
physicalLocation (Pin P9 0 7)  = "Header 9 Pin 42"
physicalLocation (Pin P9 1 16) = "Header 9 Pin 15"
physicalLocation (Pin P9 1 18) = "Header 9 Pin 14"
physicalLocation _ = "Unknown"