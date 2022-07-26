%{
#include <stdio.h>

int yylex();
int yyerror(const char *s);
%}

%token POS_INTEGER JSON_NUMBER
%token EOL

%%

calclist: /* nothing */
| calclist game_id EOL { printf("= %d\n", $1); }
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