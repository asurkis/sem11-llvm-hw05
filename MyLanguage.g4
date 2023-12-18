grammar MyLanguage;

program: varList block;
varList: ('var' declVar (',' declVar)* ';')*;
declVar: IDENT;
block: '{' stmt* '}';
stmt: IDENT ':=' exprInt ';'                                  # stmtAssn
    | ifStmt                                                  # stmtIf
    | 'while' exprBool block                                  # stmtWhile
    | 'for' IDENT '=' exprInt '..' exprInt block              # stmtFor
    | 'set' 'pixel' 'at' exprInt ',' exprInt 'to' exprInt ';' # stmtSimSetPixel
    | 'flush' ';'                                             # stmtSimFlush
    ;
ifStmt: 'if' exprBool block ('else' (ifStmt | block))?;

exprBool: exprBool0;
exprBool0 : exprBool1 # exprBool01
          | exprBool1 '||' exprBool0 # exprBoolOr ;
exprBool1 : exprBool2 # exprBool12
          | exprBool1 '&&' exprBool0 # exprBoolAnd ;
exprBool2 : '(' exprBool0 ')' # exprBoolParens
          | exprInt '==' exprInt # exprEQ
          | exprInt '!=' exprInt # exprNE
          | exprInt '<'  exprInt # exprLT
          | exprInt '<=' exprInt # exprLE
          | exprInt # exprBoolInt
          | 'should' 'continue' # exprSimShouldContinue ;
exprInt: exprInt0;
exprInt0 : exprInt1 # exprInt01
         | exprInt1 '^' exprInt0 # exprBitXor ;
exprInt1 : exprInt2 # exprInt12
         | exprInt2 '+' exprInt1 # exprAdd ;
exprInt2 : exprInt3 # exprInt23
         | exprInt3 '*' exprInt2 # exprMul
         | exprInt3 '%' exprInt2 # exprMod ;
exprInt3 : '(' exprInt0 ')' # exprIntParens
         | IDENT # exprVar
         | CONST # exprConst ;

CONST: '0' | '-'? [1-9][0-9]*;
IDENT: [a-zA-Z_][a-zA-Z_0-9]*;
WHITESPACE: [ \t\n\r]+ -> channel(HIDDEN);
COMMENT: ('//' ~[\n]* | '/*' .*? '*/') -> skip;
