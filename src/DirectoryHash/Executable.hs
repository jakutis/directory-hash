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
    let
      filesWithoutDots = filter (\file -> file /= "." && file /= "..") files
      name = head filesWithoutDots
      in do
        content <- Data.ByteString.Lazy.readFile $ directoryName ++ "/" ++ name
        let
          hash = showDigest $ sha512 content
          in Data.ByteString.Lazy.putStr $ encode $ [Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]]
    exitSuccess
