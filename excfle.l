/**array_number_member ({number}{whitespace},({whitespace}{number})|({number}{whitespace},{whitespace}{number}))***/
/*{number}|({number},)*/
%{
enum yytokentype {
    JSON_NUMBER = 258,
    POS_INTEGER = 259,
    JSON_STRING = 260,
    JSON_ARRAY = 261
};
int yylval;
%}

open_quote "["
close_quote "]"
character [A-Za-z]
digit [0-9]
whitespace [ ]*
string ^\"({digit}|{character}|.|{whitespace})*\"$
integer {digit}+
decimal {integer}?\.{digit}*
scientific {decimal}{digit}[Ee][+-]?{integer}*
number {integer}|{decimal}|{scientific}
negative -?({number})*
comma_number (,{negative}{number})*
array_number_member ({negative}{number}{whitespace},{whitespace}{negative}{number}{comma_number})*|(-?{number})
array_number {open_quote}{whitespace}{array_number_member}+{whitespace}{close_quote}

%%
^{number}$ { yylval = atoi(yytext); return POS_INTEGER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
{string} { return JSON_STRING; }
{array_number} { return JSON_ARRAY; }
%%


int main(int argc, char **argv)
{
    int tok;
    while(tok = yylex()) 
    {
        printf("%d", tok);
        if(tok == JSON_NUMBER) 
        {
            printf(" = %d\n", yylval);
        }
        else 
        {
            printf("\n");
        }
    }
}