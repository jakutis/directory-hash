module DirectoryHash.Executable (main) where

import Data.Digest.Pure.SHA
import qualified Data.ByteString.Lazy.Char8
import qualified Data.ByteString.Lazy
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
          in putStr $ "[{\"name\":\"" ++ name ++ "\",\"sha512\":\"" ++ hash ++ "\"}]"
    exitSuccess
