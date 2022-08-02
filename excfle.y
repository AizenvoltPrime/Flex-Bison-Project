%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *

extern FILE *yyin;

extern int yylex();
extern void yyerror(const char *s);
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

int main(int argc, char *argv[])
{
    int token;
    if(argc>1)
    {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL)
        {
            perror("Error opening file");
            return -1;
        }
    }
    yyparse();
    fclose(yyin);
    return 0;
}
