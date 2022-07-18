/**array_number_member ({number}{whitespace},({whitespace}{number})|({number}{whitespace},{whitespace}{number}))***/
/*{number}|({number},)*/
%{
enum yytokentype {
    JSON_NUMBER = 258,
    POS_INTEGER = 259,
    JSON_STRING = 260,
    JSON_ARRAY = 261,
    JSON_ARRAY_MULTI = 262
};
int yylval;
%}

open_quote "["
close_quote "]"
character [A-Za-z]
digit [0-9]
whitespace [ ]*
string \".*\"
js_string ^{string}$
integer {digit}+
decimal {integer}?\.{digit}*
scientific {decimal}[Ee][+-]?{integer}*
number {integer}|{decimal}|{scientific}
negative -{number}
comma_number (,-?{number})*
array_number_member ((-?{number}{whitespace},{whitespace}-?{number}{comma_number})*)|-?({number})
array_number {open_quote}{whitespace}{array_number_member}{whitespace}{close_quote}
comma_string (,{string})*
array_string_member ((({string}{whitespace}),({whitespace}{string}){comma_string})*)|({string})
array_string {open_quote}{whitespace}{array_string_member}{whitespace}{close_quote}
array_multi_member ({array_number_member}|{array_string_member})*
array_multi {open_quote}{whitespace}{array_multi_member}{whitespace}{close_quote}

%%
^{number}$ { yylval = atoi(yytext); return POS_INTEGER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
{js_string} { return JSON_STRING; }
{array_number} { return JSON_ARRAY; }
{array_string} { return JSON_ARRAY; }
{array_multi} { return JSON_ARRAY_MULTI; }
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