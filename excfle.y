%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *

extern FILE *yyin;

extern int yylex();
extern void yyerror(const char *s);
%}

%define parse.error verbose

%token COLON "colon"
%token OPEN_BRACKET "opening bracket"
%token CLOSE_BRACKET "closing bracket"
%token JSON_NUMBER "json number"
%token POS_INTEGER "positive integer"
%token JSON_STRING "json string"
%token JSON_ARRAY "json array"
%token ANUM "alpharithmetic"
%token UNKNOWN "unknown"
%token EOL "end of line"
%token YYEOF 0 "end of file"

%%

program: OPEN_BRACKET POS_INTEGER CLOSE_BRACKET

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
