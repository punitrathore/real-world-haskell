module SafeHello where

import MonadHandle
import System.IO (IOMode(..))

safeHello :: MonadHandle h m => FilePath -> m ()
safeHello path = do
  h <- openFile path WriteMode
  hPutStrLn h "hey hey... heyheyheyhey"
  hClose h
