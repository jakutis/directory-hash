module DirectoryHash.Executable (main) where

import Data.Aeson.Encode
import qualified Data.ByteString.Lazy
import qualified Data.ByteString.Lazy.Char8
import Data.Digest.Pure.SHA
import qualified Data.HashMap.Strict
import Data.List
import qualified System.Directory
import System.Directory.Tree
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main (directoryName:_) = do
    files <- findFiles [] directoryName
    result <- mapM (hashFile directoryName) files
    Data.ByteString.Lazy.putStr $ encode $ result
    exitSuccess

toFlatFileList :: String -> DirTree String -> [String]
toFlatFileList prefix (File name _) = [prefix ++ "/" ++ name]
toFlatFileList prefix (Dir name subdirs) = concat $ map (toFlatFileList $ prefix ++ "/" ++ name) subdirs

findFiles :: [String] -> String -> IO [String]
findFiles [] directoryName = do
    (_ :/ (Dir dir contents)) <- readDirectory directoryName
    return $ sort $ concat $ map (toFlatFileList "") contents

hashFile :: String -> String -> IO (Data.HashMap.Strict.HashMap String String)
hashFile directoryName name = do
    content <- Data.ByteString.Lazy.readFile $ directoryName ++ name
    let
      hash = showDigest $ sha512 content
      in return $ Data.HashMap.Strict.fromList [("name", name), ("sha512", hash)]
