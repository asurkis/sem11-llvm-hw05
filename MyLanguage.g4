grammar MyLanguage;

program: varList block;
varList: ('var' declVar (',' declVar)* ';')*;
declVar: IDENT;
block: '{' stmt* '}';
stmt: IDENT ':=' expr ';'                        # stmtAssn
	| ifStmt                                     # stmtIf
	| 'while' expr block                         # stmtWhile
	| 'for' IDENT 'from' expr 'until' expr block # stmtFor
	| 'set' 'pixel' expr expr expr ';'           # stmtSimSetPixel
	| 'flush' ';'                                # stmtSimFlush
	;
ifStmt: 'if' expr block ('else' (ifStmt | block))?;

expr: expr0;
expr0 : expr1 # expr01
      | expr1 '&&' expr1 # exprAnd
      | expr1 '||' expr1 # exprOr ;
expr1 : expr2 # expr12
      | expr2 '==' expr2 # exprEQ
      | expr2 '<' expr2 # exprLT
      | expr2 '<=' expr2 # exprLE ;
expr2 : expr3 # expr23
      | expr3 '^' expr2 # exprBitXor ;
expr3 : expr4 # expr34
      | expr4 '+' expr3 # exprAdd ;
expr4 : expr5 # expr45
      | expr5 '*' expr4 # exprMul
      | expr5 '%' expr4 # exprMod ;
expr5 : '(' expr0 ')' # exprParens
      | IDENT # exprVar
      | CONST # exprConst
      | 'should' 'continue' # exprSimShouldContinue ;

CONST: '0' | '-'? [1-9][0-9]*;
IDENT: [a-zA-Z_][a-zA-Z_0-9]*;
WHITESPACE: [ \t\n\r]+ -> channel(HIDDEN);
COMMENT: ('//' ~[\n]* | '/*' .*? '*/') -> skip;
