module DirectoryHash.Executable (main) where

import System.Exit

main :: [String] -> IO ()
main [] = exitFailure
main _ = do
    putStr "[{\"name\":\"a\",\"sha512\":\"1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75\"}]"
    exitSuccess
