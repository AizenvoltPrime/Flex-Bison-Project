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
%token COMMA "comma"
%token OPEN_QUOTE "opening quote"
%token CLOSE_QUOTE "closing quote"
%token OPEN_BRACKET "opening bracket"
%token CLOSE_BRACKET "closing bracket"
%token JSON_NUMBER "json number"
%token POS_INTEGER "positive integer"
%token DECIMAL "decimal number"
%token JSON_STRING "json string"
%token JSON_ARRAY "json array"
%token ANUM "alpharithmetic"
%token UNKNOWN "unknown"
%token EOL "end of line"
%token YYEOF 0 "end of file"

%%

object: OPEN_BRACKET obj_elems CLOSE_BRACKET
        | OPEN_BRACKET CLOSE_BRACKET
        | %empty 

obj_elems:  ANUM COLON OPEN_BRACKET sm_obj_elements CLOSE_BRACKET COMMA obj_elems
            | ANUM COLON OPEN_BRACKET sm_obj_elements CLOSE_BRACKET

sm_obj_elements:    ANUM COLON sub_value COMMA sm_obj_elements
                    | ANUM COLON sub_value
                    
sub_value:  value 
            | nested_obj 
            | obj_with_array CLOSE_BRACKET
            | arr_with_objects

nested_obj: OPEN_BRACKET sm_obj_elements CLOSE_BRACKET

obj_with_array: OPEN_BRACKET ANUM COLON OPEN_QUOTE arr_element cl_quote obj_with_array
                | OPEN_BRACKET OPEN_QUOTE cl_quote cl_bracket
                | ANUM COLON OPEN_QUOTE arr_element cl_quote

arr_with_objects: OPEN_QUOTE OPEN_BRACKET sm_obj_elements CLOSE_QUOTE COMMA

arr_element:    value COMMA arr_element 
                | value

cl_quote:   CLOSE_QUOTE COMMA
            | CLOSE_QUOTE

cl_bracket: CLOSE_BRACKET COMMA
            | CLOSE_BRACKET

value:  ANUM 
        | POS_INTEGER
        | DECIMAL

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
