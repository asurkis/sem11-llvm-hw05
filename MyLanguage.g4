grammar MyLanguage;

program: varList? block;
varList: 'var' var1 (',' var1)* ';';
var1: IDENT;

block: '{' '}';

INT: '-'? ('0'|[1-9][0-9]+);
IDENT: [a-zA-Z_][a-zA-Z_0-9]*;
WS: [ \t\n\r]+ -> channel(HIDDEN);
