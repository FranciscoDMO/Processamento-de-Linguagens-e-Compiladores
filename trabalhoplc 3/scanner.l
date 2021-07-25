%{
#include <stdio.h>
#include <stdlib.h>


%}

%%
\"[^\"]*\" { yylval.texto = strdup(yytext); return LINK; }
[a-zA-Z][a-zA-Z0-9|_| |\(|\)|\'|\-|\/]* { yylval.texto = strdup(yytext); return ID; }
[\.\:\;\,\=] { return yytext[0]; }
.|\n                        { ; }
%%

int yywrap() {
    return 1;
}

