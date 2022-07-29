%{
#include <stdio.h>

int yylex();
int yyerror(const char *s);
%}

%token JSON_NUMBER POS_INTEGER JSON_STRING JSON_ARRAY ANUM
%token EOL

%%

calclist: /* nothing */
| calclist game_id EOL { printf("= %d\n", $2);}
;

game_id: POS_INTEGER { $$ = $1 + $1;}
;
%%

int main(int argc, char **argv)
{
    yyparse();
}

int yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}