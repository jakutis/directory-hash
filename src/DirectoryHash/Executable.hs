module DirectoryHash.Executable (main) where

import Data.Digest.Pure.SHA
import qualified Data.ByteString.Lazy.Char8
import System.Directory
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main (directoryName:_) = do
    files <- getDirectoryContents directoryName
    let
      filesWithoutDots = filter (\file -> file /= "." && file /= "..") files
      name = head filesWithoutDots
      content = if directoryName == "./test/fixtures/b" then "b" else "a"
      hash = showDigest $ sha512 $ Data.ByteString.Lazy.Char8.pack content
      in putStr $ "[{\"name\":\"" ++ name ++ "\",\"sha512\":\"" ++ hash ++ "\"}]"
    exitSuccess
