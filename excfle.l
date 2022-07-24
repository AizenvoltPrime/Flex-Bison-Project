/**array_number_member ({number}{whitespace},({whitespace}{number})|({number}{whitespace},{whitespace}{number}))***/
/*{array_multi} { return JSON_ARRAY_MULTI; }*/

%{
#include <ctype.h>
#include <string.h>

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
comma_mult ((,{part_string})|(,{number}))*
array_multi ^({part_string}{comma_mult})|({number}{comma_mult})$

%%
^{integer}$ { yylval = atoi(yytext); return POS_INTEGER; }
^{number}$ { yylval = atoi(yytext); return JSON_NUMBER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
{array_number} { return JSON_ARRAY; }
{array_multi} {
    char *insert = yytext;
    char *temp = yytext;
    int length = yyleng;
    int position = 1;
    int inside_quotes_counter=0;
    int consecutive_quotes_counter=0;
    int elements_count=0;
    int stop=0;
    int temp_position;
    consecutive_quotes_counter++;
    if(*insert=='\"')
    {
        *insert++;
    }
    while (1)
    {
        if(*insert=='\\')
        {
            *insert++;
            position++;
            if(*insert=='\"')
            {
                inside_quotes_counter++;
                *insert++;
                position++;
            }
        }
        if(*insert=='\"')
        {
            if(position==length)
            {
                elements_count++;
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            temp=insert;
            temp_position=position;
            while(1)
            {
                *insert++;
                temp_position++;
                if(*insert==']')
                {
                    elements_count++;
                    printf("The number of elements is %d\n",elements_count);
                    break;
                }
                if(temp_position==length)
                {
                    insert = temp;
                    break;
                }
                else if(isspace(*insert))
                {
                    continue;
                }
                else if(*insert==',')
                {
                    insert = temp;
                    *insert++;
                    position++;
                    break;
                }
                else
                {
                    printf("ERROR\n");
                    stop=1;
                    break;
                }
            }       
            if(stop==1)
            {
                break;
            }
            elements_count++;
            *insert++;
            position++;
            if(inside_quotes_counter==0)
            {
                printf("The string doesn't contains more strings\n");
            }
            else
            {
                printf("The string contains more strings\n");
            }
            if(position+1>length)
            {
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            else if(!isdigit(*insert))
            {
                while(*insert!='\"')
                {
                    *insert++;
                    position++;
                }
                *insert++;
                position++;
            }
            else if(isdigit(*insert))
            {
                position++;
            }
        }
        else if(isdigit(*insert))
        {
            while(isdigit(*insert) && position<length)
            {
                *insert++;
                position++;
            }
            if(position==length && isdigit(*insert))
            {
                elements_count++;
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            else if(*insert==',')
            {
                elements_count++;
                *insert++;
                position++;
                if(*insert=='\"')
                {
                    *insert++;
                    position++;
                }
            }
            else
            {
                printf("NUMBER ERROR!!!!");
                break;
            }
        }
        else
        {
            *insert++;
            position++;
            if(position>length)
            {
                printf("ERROR!!!!");
                break;
            }
        }
    }
}
%%
