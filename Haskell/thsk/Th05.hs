{-# LANGUAGE TemplateHaskell #-}

module Th05 (module Th05) where

import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Data.List (intercalate)

emptyShow :: Name -> Q [Dec]
emptyShow name = [d|instance Show $(conT name) where show _ = ""|]

listFields :: Name -> Q [Dec]
listFields name = do
    TyConI (DataD _ _ _ _ [RecC _ fields] _) <- reify name
    let names = map (\(name,_,_) -> name) fields
        showField :: Name -> Q Exp
        showField name = [|\x -> s ++ " = " ++ show ($(varE name) x)|] 
                  where  s = nameBase name
        showFields :: Q Exp
        showFields = listE $ map showField names
    [d|instance Show $(conT name) where
        show x = intercalate ", " (map ($ x) $showFields)|]

