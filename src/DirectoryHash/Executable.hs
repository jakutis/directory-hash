module DirectoryHash.Executable (main) where

import Data.Aeson.Encode
import qualified Data.ByteString.Lazy
import Data.Digest.Pure.SHA
import qualified Data.HashMap.Strict
import Data.List
import System.Directory
import System.Exit
import System.IO

main :: [String] -> IO ()
main [] = exitFailure
main [directoryName] = do
    files <- fmap sort (deepListFiles directoryName "")
    result <- hashFiles directoryName files (length files)
    Data.ByteString.Lazy.putStr $ encode $ result
    exitSuccess

showProgress :: Int -> IO ()
showProgress left = do
    hPutStrLn stderr $ show left
    hFlush stderr

hashFiles :: String -> [String] -> Int -> IO [Data.HashMap.Strict.HashMap String String]
hashFiles _ [] _ = return []
hashFiles directoryName (file:files) left = do
    showProgress left
    result <- hashFile directoryName file
    results <- hashFiles directoryName files (left - 1)
    return $ result : results

deepListFiles :: String -> String -> IO [String]
deepListFiles pathPrefix path = do
    isDir <- doesDirectoryExist (pathPrefix ++ path)
    case isDir of
        True -> do
            files <- getDirectoryContents (pathPrefix ++ path)
            prefixedFiles <- mapM (\x -> return $ path ++ "/" ++ x) (filter (\x -> x /= "." && x /= "..") files)
            allFiles <- mapM (deepListFiles pathPrefix) prefixedFiles
            return $ concat allFiles
        False -> return [path]

hashFile :: String -> String -> IO (Data.HashMap.Strict.HashMap String String)
hashFile directoryName name = do
    content <- Data.ByteString.Lazy.readFile $ directoryName ++ name
    let
      hash = showDigest $ sha512 content
      in return $! Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]
