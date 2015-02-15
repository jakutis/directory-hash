module DirectoryHash.Executable (main) where

import Data.Aeson.Encode
import qualified Data.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8
import Data.Digest.Pure.SHA
import qualified Data.HashMap.Strict
import Data.List
import qualified System.Directory
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main (directoryName:_) = do
    files <- findFiles directoryName
    result <- mapM (hashFile directoryName) files
    Data.ByteString.Lazy.putStr $ encode $ result
    exitSuccess

listFiles :: String -> IO [String]
listFiles directoryName = do
    filesIncludingDots <- System.Directory.getDirectoryContents directoryName
    return $ filter (\file -> file /= "." && file /= "..") filesIncludingDots

findFiles :: String -> IO [String]
findFiles directoryName = do
    files <- listFiles directoryName
    return $ sort $ files

hashFile :: String -> String -> IO (Data.HashMap.Strict.HashMap String String)
hashFile directoryName name = do
    content <- Data.ByteString.Lazy.readFile $ directoryName ++ "/" ++ name
    let
      hash = showDigest $ sha512 content
      in return $ Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]
