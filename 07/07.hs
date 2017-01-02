import qualified Data.ByteString as B
import Data.Char (chr, isSpace, ord)
import System.Environment (getArgs)
import System.IO (hClose, hGetContents, openFile, IOMode(ReadMode))

import Crypto.Cipher.AES (AES128)
import Crypto.Cipher.Types (cipherInit, ecbDecrypt)
import Crypto.Error (CryptoFailable(..))

import qualified ByteFormat


main = do
    [filename] <- getArgs
    handle <- openFile filename ReadMode
    contents <- hGetContents handle

    let joinedContents = filter (not . isSpace) contents
        Just decodedContents = ByteFormat.b64ToBytes joinedContents

        key = B.pack $ map (fromIntegral . ord) "YELLOW SUBMARINE"

        cipher :: AES128
        CryptoPassed cipher = cipherInit key
        plaintext = ecbDecrypt cipher decodedContents

    putStrLn $ map (chr . fromIntegral) $ B.unpack plaintext
    hClose handle
