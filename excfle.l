/**array_number_member ({number}{whitespace},({whitespace}{number})|({number}{whitespace},{whitespace}{number}))***/
/*  r{3}ux  rrrux rrrrux rrrrrux */
/*{array_multi} { return JSON_ARRAY_MULTI; }*/

%{
enum yytokentype {
    JSON_NUMBER = 258,
    POS_INTEGER = 259,
    JSON_STRING = 260,
    JSON_ARRAY = 261,
    JSON_ARRAY_MULTI = 262,
    TEST = 263,
    TEST2 = 264
};
int yylval;

%}

open_quote "["
close_quote "]"
character [A-Za-z]
digit [0-9]
whitespace [ ]*
string \".*[^\",\"]\"
string_in_string \"(.*(\\\").*(\\\").*)*\"
part_string \".*\"
last_part_string \"{character}*\"
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
array_multi {open_quote}{whitespace}{part_string}{whitespace}{close_quote}

%%
^{number}$ { yylval = atoi(yytext); return POS_INTEGER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
{array_number} { return JSON_ARRAY; }
{part_string} {
    int length = strlen(yytext)+1;
    int position = 1;
    int counter=0;
    int i=0;
    char *insert = yytext;
    *insert++;
    int elements_count=0;
    while (i==0)
    {
        printf("The char is %c\n",*insert);;
        if(*insert=='\\')
        {
            *insert++;
            position++;
            if(*insert=='\"')
            {
                counter++;
                *insert++;
                position++;
            }
            else
            {
                printf("Bad input");
                break;
            }
        }
        if(*insert=='\"' && counter == 0)
        {
            elements_count++;
            printf("The string doesn't contains more strings\n");
            if(position+3>length)
            {
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            else 
            {
                *insert++;
                position++;
                while(*insert!='\"')
                {
                    *insert++;
                    position++;
                }
                *insert++;
                position++;
            }
        }
        else if(*insert=='\"' && counter > 0)
        {
            elements_count++;
            printf("The string contains more strings\n");
            if(position+3>length)
            {
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            else 
            {
                *insert++;
                position++;
                while(*insert!='\"')
                {
                    *insert++;
                    position++;
                }
                *insert++;
                position++;
            }
        }
        else
        {
            *insert++;
            position++;
        }
    }
}

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