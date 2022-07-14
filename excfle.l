%{

enum yytokentype {
    JSON_NUMBER = 258,
    JSON_STRING = 259,
};

int yylval;
%}

%%

^[0-9]*(\.[0-9]*)?$ { yylval = atoi(yytext); return JSON_NUMBER; }
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