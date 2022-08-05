%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *

extern FILE *yyin;

extern int yylex();
extern void yyerror(const char *s);
%}

%define parse.error verbose

%token                              COLON                                           "colon"
%token                              COMMA                                           "comma"
%token                              OPEN_QUOTE                                      "opening quote"
%token                              CLOSE_QUOTE                                     "closing quote"
%token                              OPEN_BRACKET                                    "opening bracket"
%token                              CLOSE_BRACKET                                   "closing bracket"
%token                              JSON_NUMBER                                     "json number"
%token                              POS_INTEGER                                     "positive integer"
%token                              DECIMAL                                         "decimal number"
%token                              JSON_STRING                                     "json string"
%token                              JSON_ARRAY                                      "json array"
%token                              ANUM                                            "alpharithmetic"
%token                              UNKNOWN                                         "unknown"
%token                              EOL                                             "end of line"
%token                              YYEOF                     0                     "end of file"
%token                              LAST                                            "last"
%token                              ACTIVE                                          "active"
%token                              GAMEID                                          "gameId"
%token                              DRAWID                                          "drawId"
%token                              DRAWTIME                                        "drawTime"
%token                              STATUS                                          "status"
%token                              DRAWBREAK                                       "drawBreak"
%token                              VISUALDRAW                                      "visualDraw"
%token                              PRICEPOINTS                                     "pricePoints"
%token                              AMOUNT                                          "amount"
%token                              WINNINGNUMBERS                                  "winningNumbers"
%token                              PRIZECATEGORIES                                 "prizeCategories"
%token                              WAGERSTATISTICS                                 "wagerStatistics"
%token                              LIST                                            "list"
%token                              BONUS                                           "bonus"
%token                              ID                                              "id"
%token                              DIVIDENT                                        "divident"
%token                              WINNERS                                         "winners"
%token                              DISTRIBUTED                                     "distributed"
%token                              JACKPOT                                         "jackpot"
%token                              FIXED                                           "fixed"
%token                              CATEGORYTYPE                                    "categoryType"
%token                              GAMETYPE                                        "gameType"
%token                              MINIMUMDISTRIBUTED                              "minimumDistributed"
%token                              COLUMNS                                         "columns"
%token                              WAGERS                                          "wagers"
%token                              ADDON                                           "addOn"


%%

file:       OPEN_BRACKET LAST last ACTIVE active CLOSE_BRACKET
            | %empty 

last:       COLON OPEN_BRACKET GAMEID COLON POS_INTEGER COMMA DRAWID COLON POS_INTEGER COMMA DRAWTIME COLON POS_INTEGER COMMA STATUS COLON ANUM COMMA DRAWBREAK COLON POS_INTEGER COMMA VISUALDRAW COLON POS_INTEGER COMMA PRICEPOINTS pricePoints WINNINGNUMBERS winningNumbers PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET COMMA

pricePoints: COLON OPEN_BRACKET AMOUNT COLON DECIMAL CLOSE_BRACKET COMMA

winningNumbers: COLON OPEN_BRACKET LIST list BONUS bonus CLOSE_BRACKET COMMA

list: COLON OPEN_QUOTE arr_element CLOSE_QUOTE COMMA

arr_element:    POS_INTEGER COMMA arr_element 
                | POS_INTEGER

bonus: COLON OPEN_QUOTE POS_INTEGER CLOSE_QUOTE

prizeCategories: COLON OPEN_QUOTE prizeCategoriesElems CLOSE_QUOTE COMMA

prizeCategoriesElems:    OPEN_BRACKET ID COLON POS_INTEGER COMMA DIVIDENT COLON DECIMAL COMMA WINNERS COLON POS_INTEGER COMMA DISTRIBUTED COLON DECIMAL COMMA JACKPOT COLON DECIMAL COMMA FIXED COLON DECIMAL COMMA CATEGORYTYPE COLON POS_INTEGER COMMA GAMETYPE COLON ANUM CLOSE_BRACKET COMMA
                        | OPEN_BRACKET ID COLON POS_INTEGER COMMA DIVIDENT COLON DECIMAL COMMA WINNERS COLON POS_INTEGER COMMA DISTRIBUTED COLON DECIMAL COMMA JACKPOT COLON DECIMAL COMMA FIXED COLON DECIMAL COMMA CATEGORYTYPE COLON POS_INTEGER COMMA GAMETYPE COLON ANUM CLOSE_BRACKET

wagerStatistics:  COLON OPEN_BRACKET wagerStatisticsElems CLOSE_BRACKET

wagerStatisticsElems:  COLUMNS COLON POS_INTEGER COMMA WAGERS COLON POS_INTEGER COMMA ADDON COLON JSON_ARRAY

active: COLON OPEN_BRACKET GAMEID COLON POS_INTEGER COMMA DRAWID COLON POS_INTEGER COMMA DRAWTIME COLON POS_INTEGER STATUS COLON ANUM COMMA DRAWBREAK COLON POS_INTEGER COMMA VISUALDRAW COLON POS_INTEGER COMMA PRICEPOINTS pricePoints PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET COMMA

%%

int main(int argc, char *argv[])
{
    int token;
    if(argc>1)
    {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL)
        {
            perror("Error opening file");
            return -1;
        }
    }
    yyparse();
    fclose(yyin);
    return 0;
}
