%{
#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include "excfle.tab.h"

void minimumdist_error_check(int token);
void yyerror(const char* error);
bool number_validation(char *insert, int *position, int *elements_count, int *digit_block, bool *scientific, bool *correct_value);

int token_counter=0;
char* minim_temp;
char* addon_temp;
int temp_position[3]={0,0,0};
int id_position=0;
int prize_object_counter=0;
int prize_categories_counter=0;
int prize_categories_position=0;
bool integer_array=true;
int count_of_id_1=0;
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

content                             \""content"\":
totalPages                          \""totalPages"\":
totalElements                       \""totalElements"\":
numberOfElements                    \""numberOfElements"\":
sort                                \""sort"\":
first                               \""first"\":
size                                \""size"\":
numberToken                         \""number"\":
direction                           \""direction"\":
property                            \""property"\":
ignoreCase                          \""ignoreCase"\":
nullHandling                        \""nullHandling"\":
descending                          \""descending"\":
ascending                           \""ascending"\":
bool                                "true"|"false"

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
class_string                        \"(([A-Za-z])|([0-9]))*\.(([A-Za-z])|([0-9]))*\"
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
{integer}                           { 
    if(token_counter==temp_position[2])
    {
        if( strcmp(yytext, "1100")==0 || strcmp(yytext, "1110")==0 ||
            strcmp(yytext, "2100")==0 || strcmp(yytext, "2101")==0 ||
            strcmp(yytext, "5103")==0 || strcmp(yytext, "5104")==0 ||
            strcmp(yytext, "5106")==0)
        {
            minimumdist_error_check(POS_INTEGER); 
            return POS_INTEGER; 
        }
        else
        {
            yyerror("Invalid gameId value!");
        }
    }
    if(token_counter==temp_position[0])
    {
        if(strcmp(yytext, "1")==0)
        {
            count_of_id_1=prize_object_counter;
        }
    }
    minimumdist_error_check(POS_INTEGER); 
    return POS_INTEGER; 
}
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
            if(token_counter!=temp_position[1])
            {
                minimumdist_error_check(ARRAY_INT); 
                return ARRAY_INT;
            }
            else{
                minimumdist_error_check(JSON_ARRAY); 
                return JSON_ARRAY;
            } 
        }
    }
    if(*insert=='\"')
    {
        *insert++;
        position++;
        digit_block=1;
        integer_array=false;
    }
    while (1)
    {
        if(*insert=='\\') //Checking for strings inside string
        {
            integer_array=false;
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
            integer_array=false;
            digit_block=0;
            if(position==length)
            {
                elements_count++;
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
                    correct_value=true;
                    stop=1;
                    break;
                }
                if(position==length)
                {
                    elements_count++;
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
                    stop=1;
                    break;
                }
            }       
            if(stop==1)
            {
                break;
            }
            elements_count++;
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
                integer_array=false;
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
            if(position>length) //If the position is above length then the number entered is invalid.
            {
                break;
            }
        }
    }
    if(correct_value == true && integer_array==false && token_counter==temp_position[1])
    {
        integer_array=true;
        minimumdist_error_check(JSON_ARRAY);
        return JSON_ARRAY;
    }
    else if(correct_value == true && integer_array==true && token_counter==temp_position[1])
    {
        minimumdist_error_check(JSON_ARRAY);
        return JSON_ARRAY;
    }   
    else if(correct_value == true && integer_array==true && token_counter!=temp_position[1])
    {
        minimumdist_error_check(ARRAY_INT);
        return ARRAY_INT;
    }
    else
    {
        yyerror("Invalid value in array!");
    }
}

{false_array_catch}             {yyerror("Invalid value in array!");}
{open_quote}                    { minimumdist_error_check(OPEN_QUOTE); return OPEN_QUOTE; }
{close_quote}                   { minimumdist_error_check(CLOSE_QUOTE); return CLOSE_QUOTE; }
{comma}                         { minimumdist_error_check(COMMA); return COMMA; }
{decimal}                       { minimumdist_error_check(DECIMAL); return DECIMAL; }
{active}                        { minimumdist_error_check(ACTIVE); return ACTIVE; }
{gameId}                        { prize_categories_counter++; minimumdist_error_check(GAMEID); return GAMEID; }
{drawId}                        { minimumdist_error_check(DRAWID); return DRAWID; }
{drawTime}                      { minimumdist_error_check(DRAWTIME); return DRAWTIME; }
{status}                        { minimumdist_error_check(STATUS); return STATUS; }
{drawBreak}                     { minimumdist_error_check(DRAWBREAK); return DRAWBREAK; }
{visualDraw}                    { minimumdist_error_check(VISUALDRAW); return VISUALDRAW; }
{pricePoints}                   { minimumdist_error_check(PRICEPOINTS); return PRICEPOINTS; }
{amount}                        { minimumdist_error_check(AMOUNT); return AMOUNT; }
{winningNumbers}                { minimumdist_error_check(WINNINGNUMBERS); return WINNINGNUMBERS; }
{prizeCategories}               { 
    if(prize_categories_counter>1)
    {
        if(prize_object_counter>8)
        {
            printf("ERROR AT LINE %d - ERROR TYPE IS: prizeCategories contains more than 8 JSON objects, it must have exactly 8 JSON objects to be valid!\n",prize_categories_position);
            exit(EXIT_FAILURE);
        }
        else if(prize_object_counter<8)
        {
            printf("ERROR AT LINE %d - ERROR TYPE IS: prizeCategories contains less than 8 JSON objects, it must have exactly 8 JSON objects to be valid!\n",prize_categories_position);
            exit(EXIT_FAILURE);
        }
    }
    prize_categories_position=yylineno;
    prize_object_counter=0;
    minimumdist_error_check(PRIZECATEGORIES); 
    return PRIZECATEGORIES; 
}                        
{wagerStatistics}               { minimumdist_error_check(WAGERSTATISTICS); return WAGERSTATISTICS; }
{list}                          { minimumdist_error_check(LIST); return LIST; }
{bonus}                         { minimumdist_error_check(BONUS); return BONUS; }
{id}                            { 
    prize_object_counter++;
    id_position=token_counter+1;
    minimumdist_error_check(ID); 
    return ID; 
}
{divident}                      { minimumdist_error_check(DIVIDENT); return DIVIDENT; }
{winners}                       { minimumdist_error_check(WINNERS); return WINNERS; }
{distributed}                   { minimumdist_error_check(DISTRIBUTED); return DISTRIBUTED; }
{jackpot}                       { minimumdist_error_check(JACKPOT); return JACKPOT; }
{fixed}                         { minimumdist_error_check(FIXED); return FIXED; }
{categoryType}                  { minimumdist_error_check(CATEGORYTYPE); return CATEGORYTYPE; }
{gameType}                      { minimumdist_error_check(GAMETYPE); return GAMETYPE; }
{minimumDistributed}            { 
        if(prize_object_counter==count_of_id_1)
        {
            minimumdist_error_check(MINIMUMDISTRIBUTED);
            return MINIMUMDISTRIBUTED; 
        }
        else
        {
            printf("ERROR AT LINE %d - ERROR TYPE IS: id of minimumDistributed must be 1\n",yylineno-8);
            exit(EXIT_FAILURE);
        }
    }
{columns}                       { minimumdist_error_check(COLUMNS); return COLUMNS; }
{wagers}                        { minimumdist_error_check(WAGERS); return WAGERS; }
{addOn}                         { minimumdist_error_check(ADDON); return ADDON; }
{content}                       { minimumdist_error_check(CONTENT); return CONTENT; }
{totalPages}                    { minimumdist_error_check(TOTALPAGES); return TOTALPAGES; }
{totalElements}                 { minimumdist_error_check(TOTALELEMENTS); return TOTALELEMENTS; }
{numberOfElements}              { minimumdist_error_check(NUMBEROFELEMENTS); return NUMBEROFELEMENTS; }
{sort}                          { minimumdist_error_check(SORT); return SORT; }
{first}                         { minimumdist_error_check(FIRST); return FIRST; }
{size}                          { minimumdist_error_check(SIZE); return SIZE; }
{numberToken}                   { minimumdist_error_check(NUMBERTOKEN); return NUMBERTOKEN; }
{direction}                     { minimumdist_error_check(DIRECTION); return DIRECTION; }
{property}                      { minimumdist_error_check(PROPERTY); return PROPERTY; }
{ignoreCase}                    { minimumdist_error_check(IGNORECASE); return IGNORECASE; }
{nullHandling}                  { minimumdist_error_check(NULLHANDLING); return NULLHANDLING; }
{descending}                    { minimumdist_error_check(DESCENDING); return DESCENDING; }
{ascending}                     { minimumdist_error_check(ASCENDING); return ASCENDING; }
{bool}                          { minimumdist_error_check(BOOL); return BOOL; }
{string}                        { minimumdist_error_check(ANUM); return ANUM; }
{class_string}                  { minimumdist_error_check(CLASS_STRING); return CLASS_STRING; }
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
    if(strcmp(yytext, "\"id\":")==0)
    {
        temp_position[0]=token_counter;
    }
    else if(strcmp(yytext, "\"addOn\":")==0)
    {
        temp_position[1]=token_counter;
    }
    else if(strcmp(yytext, "\"gameId\":")==0)
    {
        temp_position[2]=token_counter;
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
        integer_array=false;
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
                    return true;
                }
            }
            else
            {
                return true;
            }
        }
    }
    if(*insert==']')
    {
        (*elements_count)++;
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
            integer_array=false;
            *insert++;
            (*position)++;
            *digit_block=1;
        }
    }
    else if(*insert=='.')
    {
        integer_array=false;
        return false;
    }
    else
    {
        return true;
    }
    return false;
}