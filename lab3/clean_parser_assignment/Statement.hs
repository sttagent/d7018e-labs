module Statement(T, parse, toString, fromString, exec) where
import Prelude hiding (return, fail, read)
import Parser hiding (T)
import qualified Dictionary
import qualified Expr
type T = Statement
data Statement =
    Assignment String Expr.T |
    If Expr.T Statement Statement |
    Skip |
    Read String |
    Write Expr.T |
    Begin [Statement] |
    While Expr.T Statement |
    Repeat Statement Expr.T
    deriving Show

assignment = word #- accept ":=" # Expr.parse #- require ";" >-> buildAss
buildAss (v, e) = Assignment v e

skip = accept "skip" # require ";" >-> buildSkip
buildSkip _ = Skip

read = accept "read" -# word #- require ";" >-> buildRead
buildRead = Read

write = accept "write" -# Expr.parse #- require ";" >-> buildWrite
buildWrite = Write

begin = accept "begin" -# iter parse #- require "end" >-> buildBegin
buildBegin = Begin

ifStmt = accept "if" -# Expr.parse # require "then" -# parse # require "else" -# parse >-> buildIf
buildIf ((cond, thenStmt), elseStmt) = If cond thenStmt elseStmt

whileStmt = accept "while" -# Expr.parse # require "do" -# parse >-> buildWhile
buildWhile (cond, stmt) = While cond stmt

repeatStmt = accept "repeat" -# parse # require "until" -# Expr.parse #- require ";" >-> buildRepeat
buildRepeat (stmts, cond) = Repeat stmts cond

exec :: [T] -> Dictionary.T String Integer -> [Integer] -> [Integer]
exec (If cond thenStmts elseStmts: stmts) dict input =
    if (Expr.value cond dict)>0
    then exec (thenStmts: stmts) dict input
    else exec (elseStmts: stmts) dict input

exec (Assignment var expr : stmts) dict input =
    exec stmts (Dictionary.insert (var, Expr.value expr dict) dict) input

exec (Skip: stmts) dict input = exec stmts dict input

exec (Read var : stmts) dict input =
    exec stmts (Dictionary.insert (var, head input) dict) (tail input)

exec (Write expr : stmts) dict input =
    Expr.value expr dict : exec stmts dict input

exec (Begin stmts : stmts') dict input = exec (stmts ++ stmts') dict input

exec (While cond stmt : stmts) dict input =
    if Expr.value cond dict > 0
    then exec (stmt : While cond stmt : stmts) dict input
    else exec stmts dict input

exec (Repeat doStmts cond: stmts) dict input = 
    exec (doStmts: after) dict input
        where 
            after
                | Expr.value cond dict <= 0 = Repeat doStmts cond : stmts
                | otherwise = stmts

exec _ _ _ = []

instance Parse Statement where
  parse = assignment ! skip ! read ! write ! begin ! ifStmt ! whileStmt ! repeatStmt
  toString = stringBuilder 0

stringBuilder :: Int -> Statement -> String
stringBuilder indent stmt = case stmt of
    Assignment var expr -> indentString ++ var ++ ":=" ++ Expr.toString expr ++ ";\n"
    If cond thenStmt elseStmt -> indentString ++ "if " ++ Expr.toString cond ++ " then\n"
        ++ stringBuilder (indent + 2) thenStmt
        ++ indentString ++ "else\n"
        ++ stringBuilder (indent + 2) elseStmt
    Skip -> indentString ++ "skip;\n"
    Read var -> indentString ++ "read " ++ var ++ ";\n"
    Write expr -> indentString ++ "write " ++ Expr.toString expr ++ ";\n"
    Begin xs -> indentString ++ "begin\n"
        ++ concatMap (stringBuilder (indent + 2)) xs
        ++ indentString ++ "end\n"
    While cond s -> indentString ++ "while " ++ Expr.toString cond ++ " do\n"
        ++ stringBuilder (indent + 2) s
    Repeat s cond -> indentString ++ "repeat\n"
        ++ stringBuilder (indent + 2) s
        ++ indentString ++ "until " ++ Expr.toString cond ++ ";\n"
    where indentString = replicate indent ' '