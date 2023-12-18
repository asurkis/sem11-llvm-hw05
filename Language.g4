grammar Language;

program: varList? block;
varList: 'var' IDENT (',' IDENT)*;

block: '{' '}';

INT: '-'? ('0'|[1-9][0-9]+);
IDENT: [a-zA-Z_][a-zA-Z_0-9]*;
