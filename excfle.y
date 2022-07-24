%{
#include <stdio.h>
%}

%token JSON_NUMBER

%%

calclist: /* nothing */
| calclist game_id EOL { printf("= %d\n", $1); }
;

game_id: POS_INTEGER { $$ = $1 + $1}
%%

main(int argc, char **argv)
{
    yyparse();
}

yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}