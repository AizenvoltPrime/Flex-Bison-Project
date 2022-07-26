/**array_number_member ({number}{whitespace},({whitespace}{number})|({number}{whitespace},{whitespace}{number}))***/
/*{array_multi} { return JSON_ARRAY_MULTI; }*/

%{
#include <ctype.h>
#include <string.h>
#include "excfle.tab.h"

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
comma_mult ((,{whitespace}{part_string})|(,{whitespace}{number}))*
array_multi ({open_quote}{whitespace}(({part_string}{whitespace},{whitespace}{number}{comma_mult})|({number}{whitespace},{whitespace}{part_string}{comma_mult})|({number}{whitespace},{whitespace}{number}{comma_mult}))*{whitespace}{close_quote})|({open_quote}{whitespace}({part_string}|{number}){whitespace}{close_quote})

%%
^{integer}$ { yylval = atoi(yytext); return POS_INTEGER; }
^{number}$ { yylval = atoi(yytext); return JSON_NUMBER; }
^{negative}$ { yylval = atoi(yytext); return JSON_NUMBER; }
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
    int digit_block=0;
    if(*insert=='[')
    {
        *insert++;
        position++;
        while(isspace(*insert))
        {
            *insert++;
            position++;
        }
    }
    if(*insert=='\"')
    {
        *insert++;
        position++;
        digit_block=1;
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
            digit_block=0;
            if(position==length)
            {
                elements_count++;
                printf("The number of elements is %d\n",elements_count);
                break;
            }
            while(1)
            {
                *insert++;
                position++;
                if(*insert==']')
                {
                    elements_count++;
                    printf("The number of elements is %d\n",elements_count);
                    stop=1;
                    break;
                }
                if(position==length)
                {
                    elements_count++;
                    printf("The number of elements is %d\n",elements_count);
                    stop=1;
                    break;
                }
                else if(isspace(*insert))
                {
                    continue;
                }
                else if(*insert==',')
                {
                    *insert++;
                    position++;
                    while(isspace(*insert))
                    {
                        *insert++;
                        position++;
                    }
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
            if(inside_quotes_counter==0)
            {
                printf("The string doesn't contains more strings\n");
            }
            else
            {
                printf("The string contains more strings\n");
            }
            if(!isdigit(*insert) && *insert=='\"')
            {
                digit_block=1;
                *insert++;
                position++;
            }
        }
        else if(isdigit(*insert) && digit_block==0)
        {
            while(isdigit(*insert) && position<length)
            {
                *insert++;
                position++;
            }
            if (isspace(*insert))
            {
                while(isspace(*insert))
                {
                    *insert++;
                    position++;
                }
            }
            if(*insert==']')
            {
                elements_count++;
                printf("The number of elements is %d\n",elements_count);
                break;
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
                while(isspace(*insert))
                {
                    *insert++;
                    position++;
                }
                if(*insert=='\"')
                {
                    *insert++;
                    position++;
                    digit_block=1;
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