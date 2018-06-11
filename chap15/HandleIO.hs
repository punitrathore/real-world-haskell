{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module HandleIO
  (
    HandleIO
  , Handle
  , IOMode(..)
  , runHandleIO
  , openFile
  , hClose
  , hPutStrLn
  ) where

import System.IO (Handle, IOMode(..))
import qualified System.IO
import Control.Monad.Trans (MonadIO(..))

newtype HandleIO a = HandleIO { runHandleIO :: IO a }
  deriving (Functor, Applicative, Monad)

openFile :: FilePath -> IOMode -> HandleIO Handle
openFile path mode = HandleIO (System.IO.openFile path mode)

hClose :: Handle -> HandleIO ()
hClose = HandleIO . System.IO.hClose

hPutStrLn :: Handle -> String -> HandleIO ()
hPutStrLn h str = HandleIO (System.IO.hPutStrLn h str)

safeHello :: FilePath -> HandleIO ()
safeHello path = do
  h <- openFile path WriteMode
  hPutStrLn h "Aloha beautiful world"
  hClose h

-- in order to allow for an escape route, so that we can perform restricted
-- actions, we can implement the MonadIO typeclass

instance MonadIO HandleIO where
  liftIO = HandleIO
