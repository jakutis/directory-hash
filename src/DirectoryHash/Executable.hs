module DirectoryHash.Executable (main) where

import Data.Aeson.Encode
import qualified Data.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8
import Data.Digest.Pure.SHA
import qualified Data.HashMap.Strict
import System.Directory
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main (directoryName:_) = do
    files <- getDirectoryContents directoryName
    result <- hashFiles directoryName (filter (\file -> file /= "." && file /= "..") files)
    Data.ByteString.Lazy.putStr $ encode $ result
    exitSuccess

hashFiles :: String -> [String] -> IO [Data.HashMap.Strict.HashMap String String]
hashFiles directoryName [] = return []
hashFiles directoryName (name:_) = do
    content <- Data.ByteString.Lazy.readFile $ directoryName ++ "/" ++ name
    let
      hash = showDigest $ sha512 content
      in return [Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]]
