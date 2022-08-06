%{
#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#define YYSTYPE char *
#include "excfle.tab.h"

void print_token(int token);
void yyerror(const char* error);
bool number_validation(char *insert, int *position, int *elements_count, int *digit_block, bool *scientific, bool *correct_value);
%}

%option noyywrap
%option yylineno

last                                \""last"\":
active                              \""active"\":
gameId                              \""gameId"\":
drawId                              \""drawId"\":
drawTime                            \""drawTime"\":
status                              \""status"\":
drawBreak                           \""drawBreak"\":
visualDraw                          \""visualDraw"\":
pricePoints                         \""pricePoints"\":
amount                              \""amount"\":
winningNumbers                      \""winningNumbers"\":
prizeCategories                     \""prizeCategories"\":
wagerStatistics                     \""wagerStatistics"\":
list                                \""list"\":
bonus                               \""bonus"\":
id                                  \""id"\":
divident                            \""divident"\":
winners                             \""winners"\":
distributed                         \""distributed"\":
jackpot                             \""jackpot"\":
fixed                               \""fixed"\":
categoryType                        \""categoryType"\":
gameType                            \""gameType"\":
minimumDistributed                  \""minimumDistributed"\":
columns                             \""columns"\":
wagers                              \""wagers"\":
addOn                               \""addOn"\":

comma                               ","
colon                               ":"
open_bracket                        "{"
close_bracket                       "}"
open_quote                          "["
close_quote                         "]"
character                           [A-Za-z]
digit                               [0-9]
whitespace                          [ ]*
string                              \"(([A-Za-z])|([0-9]))*\"
json_string                         \".*\"
integer                             {digit}+
decimal                             {integer}?\.{digit}*
scientific                          {decimal}[Ee][+-]?{integer}*
number                              (-?{integer})|(-?{decimal})|(-?{scientific})
comma_mult                          (({whitespace},{whitespace}{json_string})|({whitespace},{whitespace}{number}))*
array_multi                         ({open_quote}{whitespace}(({json_string}{whitespace},{whitespace}{number}{comma_mult})|({number}{whitespace},{whitespace}{json_string}{comma_mult})|({number}{whitespace},{whitespace}{number}{comma_mult}))*{whitespace}{close_quote})|({open_quote}{whitespace}({json_string}|{number}){whitespace}{close_quote})
false_array_catch                   {open_quote}.*{close_quote}

%%

{open_bracket}                      { print_token(OPEN_BRACKET); return OPEN_BRACKET; }
{close_bracket}                     { print_token(CLOSE_BRACKET); return CLOSE_BRACKET; }
{integer}                           { print_token(POS_INTEGER); return POS_INTEGER; }
{last}                              { print_token(LAST); return LAST; }
{array_multi} {
    char *insert = yytext;
    int length = yyleng;
    int position = 1;
    int inside_quotes_counter = 0;
    int elements_count = 0;
    int stop = 0;
    int digit_block = 0;
    bool scientific = false;
    bool correct_value = false;
    if(*insert=='[')
    {
        *insert++;
        position++;
        while(isspace(*insert))
        {
            *insert++;
            position++;
        }
        if(*insert==']')
        {
            print_token(JSON_ARRAY);
            return JSON_ARRAY;
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
        if(*insert=='\\') //Checking for strings inside string
        {
            *insert++;
            position++;
            if(*insert=='\"')
            {
                inside_quotes_counter++;
                *insert++;
                position++;
            }
            while(*insert=='\\')
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
        }
        if(*insert=='\"')
        {
            digit_block=0;
            if(position==length)
            {
                elements_count++;
                //printf("The number of elements is %d\n",elements_count);
                correct_value=true;
                break;
            }
            while(1)
            {
                *insert++;
                position++;
                if(*insert==']')
                {
                    elements_count++;
                    //printf("The number of elements is %d\n",elements_count);
                    correct_value=true;
                    stop=1;
                    break;
                }
                if(position==length)
                {
                    elements_count++;
                    //printf("The number of elements is %d\n",elements_count);
                    correct_value=true;
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
                    //printf("ERROR\n");
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
                //printf("The string doesn't contains more strings\n");
            }
            else
            {
                //printf("The string contains more strings\n");
            }
            if(!isdigit(*insert) && *insert=='\"')
            {
                digit_block=1;
                *insert++;
                position++;
            }
        }
        else if(isdigit(*insert) && digit_block==0)//Checking for correct number values
        {
            int i=position;
            if(number_validation(insert, &position, &elements_count, &digit_block, &scientific, &correct_value) == true)
            {
                break;
            }
            for(i; i<position;i++)
            {
                *insert++;
            }
            i=position+1;
            if(*insert=='.')
            {
                *insert++;
                position++;
                if(isdigit(*insert) || *insert == 'E' || *insert == 'e')
                {
                    if(*insert == 'E' || *insert == 'e')
                    {
                        scientific=true;
                    }
                    if(number_validation(insert, &position, &elements_count, &digit_block, &scientific, &correct_value) == true)
                    {
                        break;
                    }
                    for(i; i<position;i++)
                    {
                        *insert++;
                    }
                }
            }
        }
        else
        {
            *insert++;
            position++;
            if(position>length) //If the position is above length then the number entered is wrong.
            {
                //printf("ERROR!!!!");
                break;
            }
        }
    }
    if(correct_value == true)
    {
        //printf("correct value\n");
        print_token(JSON_ARRAY);
        return JSON_ARRAY;
    }
    else
    {
        yyerror("Wrong value in array!");
    }
}

{false_array_catch}             {yyerror("Wrong value in array!");}
{open_quote}                    { print_token(OPEN_QUOTE); return OPEN_QUOTE; }
{close_quote}                   { print_token(CLOSE_QUOTE); return CLOSE_QUOTE; }
{comma}                         { print_token(COMMA); return COMMA; }
{decimal}                       { print_token(DECIMAL); return DECIMAL; }
{active}                        { print_token(ACTIVE); return ACTIVE; }
{gameId}                        { print_token(GAMEID); return GAMEID; }
{drawId}                        { print_token(DRAWID); return DRAWID; }
{drawTime}                      { print_token(DRAWTIME); return DRAWTIME; }
{status}                        { print_token(STATUS); return STATUS; }
{drawBreak}                     { print_token(DRAWBREAK); return DRAWBREAK; }
{visualDraw}                    { print_token(VISUALDRAW); return VISUALDRAW; }
{pricePoints}                   { print_token(PRICEPOINTS); return PRICEPOINTS; }
{amount}                        { print_token(AMOUNT); return AMOUNT; }
{winningNumbers}                { print_token(WINNINGNUMBERS); return WINNINGNUMBERS; }
{prizeCategories}               { print_token(PRIZECATEGORIES); return PRIZECATEGORIES; }                        
{wagerStatistics}               { print_token(WAGERSTATISTICS); return WAGERSTATISTICS; }
{list}                          { print_token(LIST); return LIST; }
{bonus}                         { print_token(BONUS); return BONUS; }
{id}                            { print_token(ID); return ID; }
{divident}                      { print_token(DIVIDENT); return DIVIDENT; }
{winners}                       { print_token(WINNERS); return WINNERS; }
{distributed}                   { print_token(DISTRIBUTED); return DISTRIBUTED; }
{jackpot}                       { print_token(JACKPOT); return JACKPOT; }
{fixed}                         { print_token(FIXED); return FIXED; }
{categoryType}                  { print_token(CATEGORYTYPE); return CATEGORYTYPE; }
{gameType}                      { print_token(GAMETYPE); return GAMETYPE; }
{minimumDistributed}            { print_token(MINIMUMDISTRIBUTED); return MINIMUMDISTRIBUTED; }
{columns}                       { print_token(COLUMNS); return COLUMNS; }
{wagers}                        { print_token(WAGERS); return WAGERS; }
{addOn}                         { print_token(ADDON); return ADDON; }
{string}                        { print_token(ANUM); return ANUM; }


[ \t] { }
\n { }
\r\n { }
. { yyerror("Unrecognized character!"); return UNKNOWN; }
<<EOF>> { return YYEOF; }
%%

void yyerror(const char* error)
{
    printf("ERROR AT LINE %d - ERROR TYPE IS: %s\n",yylineno,error);
    exit(EXIT_FAILURE);
}

void print_token(int token)
{
    printf("Token '%s' (%d) was found at line %d\n",yytext, token, yylineno);
}

bool number_validation(char *insert, int *position, int *elements_count, int *digit_block, bool *scientific, bool *correct_value)
{
    int digit_counter=0;
    while(isdigit(*insert))
    {
        *insert++;
        (*position)++;
        digit_counter++;
    }
    if (isspace(*insert))
    {
        while(isspace(*insert))
        {
            *insert++;
            (*position)++;
        }
    }
    if(*insert=='E' || *insert=='e')
    {
        *scientific=true;
    }
    if((*insert=='E' || *insert=='e') && *scientific==true)
    {
        if(digit_counter==0)
        {
            *insert++;
            (*position)++;
            if(isdigit(*insert) || *insert== '-' || *insert== '+')
            {
                if(isdigit(*insert))
                {
                    while(isdigit(*insert))
                    {
                        *insert++;
                        (*position)++;
                    }
                    if (isspace(*insert))
                    {
                        while(isspace(*insert))
                        {
                            *insert++;
                            (*position)++;
                        }
                    }
                    *scientific==false;
                }
                else if(*insert== '-' || *insert== '+')
                {
                    *insert++;
                    (*position)++;
                    while(isdigit(*insert))
                    {
                        *insert++;
                        (*position)++;
                    }
                    if (isspace(*insert))
                    {
                        while(isspace(*insert))
                        {
                            *insert++;
                            (*position)++;
                        }
                    }
                    *scientific==false;
                }
            }
            else
            {
                //printf("NUMBER ERROR!!!!");
                return true;
            }
        }
        else if(digit_counter>0)
        {
            *insert++;
            (*position)++;
            if(isdigit(*insert))
            {
                while(isdigit(*insert))
                {
                    *insert++;
                    (*position)++;
                }
                if (isspace(*insert))
                {
                    while(isspace(*insert))
                    {
                        *insert++;
                        (*position)++;
                    }
                }
                *scientific==false;
            }
            else if(*insert== '-' || *insert== '+')
            {
                *insert++;
                (*position)++;
                if(isdigit(*insert))
                {
                    while(isdigit(*insert))
                    {
                        *insert++;
                        (*position)++;
                    }
                    if (isspace(*insert))
                    {
                        while(isspace(*insert))
                        {
                            *insert++;
                            (*position)++;
                        }
                    }
                    *scientific==false;
                }
                else
                {
                    //printf("NUMBER ERROR!!!!");
                    return true;
                }
            }
            else
            {
                //printf("NUMBER ERROR!!!!");
                return true;
            }
        }
    }
    if(*insert==']')
    {
        (*elements_count)++;
        //printf("The number of elements is %d\n",*elements_count);
        *correct_value=true;
        return true;
    }
    else if(*insert==',')
    {
        (*elements_count)++;
        *insert++;
        (*position)++;
        while(isspace(*insert))
        {
            *insert++;
            (*position)++;
        }
        if(*insert=='\"')
        {
            *insert++;
            (*position)++;
            *digit_block=1;
        }
    }
    else if(*insert=='.')
    {
        return false;
    }
    else
    {
        //printf("NUMBER ERROR!!!!");
        return true;
    }
    return false;
}