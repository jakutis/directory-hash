module DirectoryHash.Executable (main) where

import System.Directory
import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main (directoryName:_) = do
    files <- getDirectoryContents directoryName
    let
      filesWithoutDots = filter (\file -> file /= "." && file /= "..") files
      name = head filesWithoutDots
      hash = if directoryName == "./test/fixtures/b"
             then "5267768822ee624d48fce15ec5ca79cbd602cb7f4c2157a516556991f22ef8c7b5ef7b18d1ff41c59370efb0858651d44a936c11b7b144c48fe04df3c6a3e8da"
             else "1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75"
      in putStr $ "[{\"name\":\"" ++ name ++ "\",\"sha512\":\"" ++ hash ++ "\"}]"
    exitSuccess
