import Test.Hspec
import System.Exit
import System.IO.Silently
import Control.Exception
import qualified DirectoryHash.Executable

main = hspec $ do
  describe "main" $ do
    it "exits with error" $
      DirectoryHash.Executable.main [] `shouldThrow` (== ExitFailure 1)
    it "produces no output" $
      capture_ (catch (DirectoryHash.Executable.main []) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` ""
