module Main where

import System.Environment

import qualified DirectoryHash.Executable

main = getArgs >>= DirectoryHash.Executable.main