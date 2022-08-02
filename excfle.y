%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *

int yylex();
int yyerror(const char *s);
%}

%token JSON_NUMBER POS_INTEGER JSON_STRING JSON_ARRAY ANUM UNKNOWN
%token EOL

%%

calclist: /* nothing */
| calclist game_id EOL {printf("=%d\n", atoi($2));}
| calclist string EOL {printf("=%s\n",$2);}
;

game_id: POS_INTEGER {$$ = $1;};

string: ANUM {$$ = $1;};
%%
int main(int argc, char **argv)
{
}

int yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}