%{
#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#define YYSTYPE char *
#include "excfle.tab.h"

void minimumdist_error_check(int token);
void yyerror(const char* error);
bool number_validation(char *insert, int *position, int *elements_count, int *digit_block, bool *scientific, bool *correct_value);

int temp=0;
int token_counter=0;
int temp_position=0;
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

{open_bracket}                      { minimumdist_error_check(OPEN_BRACKET); return OPEN_BRACKET; }
{close_bracket}                     { minimumdist_error_check(CLOSE_BRACKET); return CLOSE_BRACKET; }
{integer}                           { minimumdist_error_check(POS_INTEGER); return POS_INTEGER; }
{last}                              { minimumdist_error_check(LAST); return LAST; }
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
            minimumdist_error_check(JSON_ARRAY);
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
        minimumdist_error_check(JSON_ARRAY);
        return JSON_ARRAY;
    }
    else
    {
        yyerror("Wrong value in array!");
    }
}

{false_array_catch}             {yyerror("Wrong value in array!");}
{open_quote}                    { minimumdist_error_check(OPEN_QUOTE); return OPEN_QUOTE; }
{close_quote}                   { minimumdist_error_check(CLOSE_QUOTE); return CLOSE_QUOTE; }
{comma}                         { minimumdist_error_check(COMMA); return COMMA; }
{decimal}                       { minimumdist_error_check(DECIMAL); return DECIMAL; }
{active}                        { minimumdist_error_check(ACTIVE); return ACTIVE; }
{gameId}                        { minimumdist_error_check(GAMEID); return GAMEID; }
{drawId}                        { minimumdist_error_check(DRAWID); return DRAWID; }
{drawTime}                      { minimumdist_error_check(DRAWTIME); return DRAWTIME; }
{status}                        { minimumdist_error_check(STATUS); return STATUS; }
{drawBreak}                     { minimumdist_error_check(DRAWBREAK); return DRAWBREAK; }
{visualDraw}                    { minimumdist_error_check(VISUALDRAW); return VISUALDRAW; }
{pricePoints}                   { minimumdist_error_check(PRICEPOINTS); return PRICEPOINTS; }
{amount}                        { minimumdist_error_check(AMOUNT); return AMOUNT; }
{winningNumbers}                { minimumdist_error_check(WINNINGNUMBERS); return WINNINGNUMBERS; }
{prizeCategories}               { minimumdist_error_check(PRIZECATEGORIES); return PRIZECATEGORIES; }                        
{wagerStatistics}               { minimumdist_error_check(WAGERSTATISTICS); return WAGERSTATISTICS; }
{list}                          { minimumdist_error_check(LIST); return LIST; }
{bonus}                         { minimumdist_error_check(BONUS); return BONUS; }
{id}                            { minimumdist_error_check(ID); return ID; }
{divident}                      { minimumdist_error_check(DIVIDENT); return DIVIDENT; }
{winners}                       { minimumdist_error_check(WINNERS); return WINNERS; }
{distributed}                   { minimumdist_error_check(DISTRIBUTED); return DISTRIBUTED; }
{jackpot}                       { minimumdist_error_check(JACKPOT); return JACKPOT; }
{fixed}                         { minimumdist_error_check(FIXED); return FIXED; }
{categoryType}                  { minimumdist_error_check(CATEGORYTYPE); return CATEGORYTYPE; }
{gameType}                      { minimumdist_error_check(GAMETYPE); return GAMETYPE; }
{minimumDistributed}            { 
        if(token_counter-22==temp_position && temp==1)
        {
            minimumdist_error_check(MINIMUMDISTRIBUTED);
            return MINIMUMDISTRIBUTED; 
        }
        else
        {
            yyerror("id of minimumDistributed is not 1");
        }
    } 
{columns}                       { minimumdist_error_check(COLUMNS); return COLUMNS; }
{wagers}                        { minimumdist_error_check(WAGERS); return WAGERS; }
{addOn}                         { minimumdist_error_check(ADDON); return ADDON; }
{string}                        { minimumdist_error_check(ANUM); return ANUM; }
{character}+                    { return INVALID_STRING; }

[ \t] { }
\n { }
\r\n { }
. { yyerror("Unrecognized character!"); return UNKNOWN; }
<<EOF>> { printf("File had no errors.\n"); return YYEOF; }
%%

void yyerror(const char* error)
{
    printf("ERROR AT LINE %d - ERROR TYPE IS: %s\n",yylineno,error);
    exit(EXIT_FAILURE);
}

void minimumdist_error_check(int token)
{
    token_counter++;
    if(atoi(yytext)==1)
    {
        temp=atoi(yytext);
        temp_position=token_counter;
    }
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