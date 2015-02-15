import Control.Exception
import qualified DirectoryHash.Executable
import qualified System.Directory
import System.Exit
import System.IO
import System.IO.Silently
import Test.Hspec

main = hspec $ do

  describe "main, called with []" $ do
    it "exits with error" $
      DirectoryHash.Executable.main [] `shouldThrow` (== ExitFailure 1)
    it "produces no output" $
      capture_ (catch (DirectoryHash.Executable.main []) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` ""

  describe "main, called with [\"./test/fixtures/a\"]" $ do
    it "produces correct output" $
      let a = "1\n[{\"sha512\":\"1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75\",\"name\":\"/a\"}]"
        in hCapture_ [stdout, stderr] (catch (DirectoryHash.Executable.main ["./test/fixtures/a"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` a

  describe "main, called with [\"./test/fixtures/b\"]" $ do
    it "produces correct output" $
      let b = "1\n[{\"sha512\":\"5267768822ee624d48fce15ec5ca79cbd602cb7f4c2157a516556991f22ef8c7b5ef7b18d1ff41c59370efb0858651d44a936c11b7b144c48fe04df3c6a3e8da\",\"name\":\"/b\"}]"
        in hCapture_ [stdout, stderr] (catch (DirectoryHash.Executable.main ["./test/fixtures/b"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` b

  describe "main, called with [\"./test/fixtures/empty\"]" $ do
    it "produces correct output" $ do
      System.Directory.createDirectoryIfMissing False "./test/fixtures/empty"
      capture_ (catch (DirectoryHash.Executable.main ["./test/fixtures/empty"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` "[]"

  describe "main, called with [\"./test/fixtures/cd\"]" $ do
    it "produces correct output" $
      let
      c = "{\"sha512\":\"acc28db2beb7b42baa1cb0243d401ccb4e3fce44d7b02879a52799aadff541522d8822598b2fa664f9d5156c00c924805d75c3868bd56c2acb81d37e98e35adc\",\"name\":\"/c\"}"
      d = "{\"sha512\":\"48fb10b15f3d44a09dc82d02b06581e0c0c69478c9fd2cf8f9093659019a1687baecdbb38c9e72b12169dc4148690f87467f9154f5931c5df665c6496cbfd5f5\",\"name\":\"/d\"}"
      in
      hCapture_ [stdout, stderr] (catch (DirectoryHash.Executable.main ["./test/fixtures/cd"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` ("2\n1\n[" ++ c ++ "," ++ d ++ "]")

  describe "main, called with [\"./test/fixtures/e\"]" $ do
    it "produces correct output" $
      let e = "1\n[{\"sha512\":\"87c568e037a5fa50b1bc911e8ee19a77c4dd3c22bce9932f86fdd8a216afe1681c89737fada6859e91047eece711ec16da62d6ccb9fd0de2c51f132347350d8c\",\"name\":\"/e/e\"}]"
        in hCapture_ [stdout, stderr] (catch (DirectoryHash.Executable.main ["./test/fixtures/e"]) ((\_ -> return ()) :: ExitCode -> IO ())) `shouldReturn` e

