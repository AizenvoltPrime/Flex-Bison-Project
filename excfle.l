%{
enum yytokentype {
    JSON_NUMBER = 258,
    JSON_STRING = 259,
};

int yylval;
%}

digit [0-9]
integer {digit}+
decimal {integer}?\.{digit}*
scientific {decimal}{digit}[Ee][+-]?{integer}*
number {integer}|{decimal}|{scientific}
negative -{number}

%%
^{number}$ { yylval = atoi(yytext); return JSON_NUMBER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
^\"([0-9]|[A-Za-z]|.|\t)*\"$ { return JSON_STRING; }
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