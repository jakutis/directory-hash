import Test.Hspec
import System.Exit
import System.IO.Silently
import Control.Exception
import qualified DirectoryHash.Executable

main = hspec $ do
  describe "main, called with []" $ do
    it "exits with error" $
      DirectoryHash.Executable.main [] `shouldThrow` (== ExitFailure 1)
    it "produces no output" $
      capture_ (catch (DirectoryHash.Executable.main []) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` ""
  describe "main, called with [\"./test/fixtures/a\"]" $ do
    it "produces correct output" $
      capture_ (catch (DirectoryHash.Executable.main ["./test/fixtures/a"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` a
      where
       a = "[{\"name\":\"a\",\"sha512\":\"1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75\"}]"
