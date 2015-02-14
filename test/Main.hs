import Test.Hspec
import System.Exit
import qualified DirectoryHash.Executable

main = hspec $ do
  describe "main" $ do
    it "exits with success" $
      DirectoryHash.Executable.main `shouldThrow` (== ExitSuccess)
