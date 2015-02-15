module DirectoryHash.Executable (main) where

import Data.Aeson.Encode
import qualified Data.ByteString.Lazy
import Data.Digest.Pure.SHA
import qualified Data.HashMap.Strict
import Data.List
import System.Directory
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main [directoryName] = do
    files <- deepListFiles directoryName ""
    result <- mapM (hashFile directoryName) files
    Data.ByteString.Lazy.putStr $ encode $ result
    exitSuccess

deepListFiles :: String -> String -> IO [String]
deepListFiles pathPrefix path = do
    isDir <- doesDirectoryExist (pathPrefix ++ path)
    case isDir of
        True -> do
            files <- getDirectoryContents (pathPrefix ++ path)
            prefixedFiles <- mapM (\x -> return $ path ++ "/" ++ x) (filter (\x -> x /= "." && x /= "..") files)
            allFiles <- mapM (deepListFiles pathPrefix) prefixedFiles
            return $ sort $ concat allFiles
        False -> return [path]

hashFile :: String -> String -> IO (Data.HashMap.Strict.HashMap String String)
hashFile directoryName name = do
    content <- Data.ByteString.Lazy.readFile $ directoryName ++ name
    let
      hash = showDigest $ sha512 content
      in return $! Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]
