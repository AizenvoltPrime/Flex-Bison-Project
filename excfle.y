%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;

extern int yylex();
extern void yyerror(const char *s);
%}

%define parse.error verbose

%token                              COMMA                               "comma"
%token                              OPEN_QUOTE                          "opening quote"
%token                              CLOSE_QUOTE                         "closing quote"
%token                              OPEN_BRACKET                        "opening bracket"
%token                              CLOSE_BRACKET                       "closing bracket"
%token                              JSON_NUMBER                         "json number"
%token                              POS_INTEGER                         "positive integer"
%token                              DECIMAL                             "decimal number"
%token                              ARRAY_INT                           "array with integers"
%token                              JSON_STRING                         "json string"
%token                              JSON_ARRAY                          "json array"
%token                              ANUM                                "alpharithmetic"
%token                              CLASS_STRING                        "property class string"
%token                              UNKNOWN                             "unknown"
%token                              EOL                                 "end of line"
%token                              YYEOF                 0             "end of file"
%token                              LAST                                "last:"
%token                              ACTIVE                              "active:"
%token                              GAMEID                              "gameId:"
%token                              DRAWID                              "drawId:"
%token                              DRAWTIME                            "drawTime:"
%token                              STATUS                              "status:"
%token                              DRAWBREAK                           "drawBreak:"
%token                              VISUALDRAW                          "visualDraw:"
%token                              PRICEPOINTS                         "pricePoints:"
%token                              AMOUNT                              "amount:"
%token                              WINNINGNUMBERS                      "winningNumbers:"
%token                              PRIZECATEGORIES                     "prizeCategories:"
%token                              WAGERSTATISTICS                     "wagerStatistics:"
%token                              LIST                                "list:"
%token                              BONUS                               "bonus:"
%token                              ID                                  "id:"
%token                              DIVIDENT                            "divident:"
%token                              WINNERS                             "winners:"
%token                              DISTRIBUTED                         "distributed:"
%token                              JACKPOT                             "jackpot:"
%token                              FIXED                               "fixed:"
%token                              CATEGORYTYPE                        "categoryType:"
%token                              GAMETYPE                            "gameType:"
%token                              MINIMUMDISTRIBUTED                  "minimumDistributed:"
%token                              COLUMNS                             "columns:"
%token                              WAGERS                              "wagers:"
%token                              ADDON                               "addOn:"
%token                              CONTENT                             "content:"
%token                              TOTALPAGES                          "totalPages:"
%token                              TOTALELEMENTS                       "totalElements:"
%token                              NUMBEROFELEMENTS                    "numberOfElements:"
%token                              SORT                                "sort:"
%token                              FIRST                               "first:"
%token                              SIZE                                "size:"
%token                              NUMBERTOKEN                         "number:"
%token                              DIRECTION                           "direction:"
%token                              PROPERTY                            "property:"
%token                              IGNORECASE                          "ignoreCase:"
%token                              NULLHANDLING                        "nullHandling:"
%token                              DESCENDING                          "descending:"
%token                              ASCENDING                           "ascending:"
%token                              BOOL                                "boolean"
%token                              INVALID_STRING                      "alpharithmetic without quotes"


%%

file:       OPEN_BRACKET LAST last ACTIVE active CLOSE_BRACKET
            | OPEN_BRACKET CONTENT content TOTALPAGES POS_INTEGER COMMA TOTALELEMENTS POS_INTEGER COMMA LAST BOOL COMMA NUMBEROFELEMENTS POS_INTEGER COMMA SORT sort FIRST BOOL COMMA SIZE POS_INTEGER COMMA NUMBERTOKEN POS_INTEGER CLOSE_BRACKET
            | %empty 

last:    OPEN_BRACKET GAMEID POS_INTEGER COMMA DRAWID POS_INTEGER COMMA DRAWTIME POS_INTEGER COMMA STATUS ANUM COMMA DRAWBREAK POS_INTEGER COMMA VISUALDRAW POS_INTEGER COMMA PRICEPOINTS pricePoints WINNINGNUMBERS winningNumbers PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET COMMA last
        | OPEN_BRACKET GAMEID POS_INTEGER COMMA DRAWID POS_INTEGER COMMA DRAWTIME POS_INTEGER COMMA STATUS ANUM COMMA DRAWBREAK POS_INTEGER COMMA VISUALDRAW POS_INTEGER COMMA PRICEPOINTS pricePoints WINNINGNUMBERS winningNumbers PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET COMMA
        | OPEN_BRACKET GAMEID POS_INTEGER COMMA DRAWID POS_INTEGER COMMA DRAWTIME POS_INTEGER COMMA STATUS ANUM COMMA DRAWBREAK POS_INTEGER COMMA VISUALDRAW POS_INTEGER COMMA PRICEPOINTS pricePoints WINNINGNUMBERS winningNumbers PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET

pricePoints: OPEN_BRACKET AMOUNT DECIMAL CLOSE_BRACKET COMMA

winningNumbers: OPEN_BRACKET LIST ARRAY_INT COMMA BONUS ARRAY_INT CLOSE_BRACKET COMMA

prizeCategories: OPEN_QUOTE prizeCategoriesElems CLOSE_QUOTE COMMA

prizeCategoriesElems:   OPEN_BRACKET ID POS_INTEGER COMMA DIVIDENT DECIMAL COMMA WINNERS POS_INTEGER COMMA DISTRIBUTED DECIMAL COMMA JACKPOT DECIMAL COMMA FIXED DECIMAL COMMA CATEGORYTYPE POS_INTEGER COMMA GAMETYPE ANUM COMMA MINIMUMDISTRIBUTED DECIMAL CLOSE_BRACKET COMMA prizeCategoriesElems
                        | OPEN_BRACKET ID POS_INTEGER COMMA DIVIDENT DECIMAL COMMA WINNERS POS_INTEGER COMMA DISTRIBUTED DECIMAL COMMA JACKPOT DECIMAL COMMA FIXED DECIMAL COMMA CATEGORYTYPE POS_INTEGER COMMA GAMETYPE ANUM COMMA MINIMUMDISTRIBUTED DECIMAL CLOSE_BRACKET
                        | OPEN_BRACKET ID POS_INTEGER COMMA DIVIDENT DECIMAL COMMA WINNERS POS_INTEGER COMMA DISTRIBUTED DECIMAL COMMA JACKPOT DECIMAL COMMA FIXED DECIMAL COMMA CATEGORYTYPE POS_INTEGER COMMA GAMETYPE ANUM CLOSE_BRACKET
                        | OPEN_BRACKET ID POS_INTEGER COMMA DIVIDENT DECIMAL COMMA WINNERS POS_INTEGER COMMA DISTRIBUTED DECIMAL COMMA JACKPOT DECIMAL COMMA FIXED DECIMAL COMMA CATEGORYTYPE POS_INTEGER COMMA GAMETYPE ANUM CLOSE_BRACKET COMMA prizeCategoriesElems

wagerStatistics:  OPEN_BRACKET wagerStatisticsElems CLOSE_BRACKET

wagerStatisticsElems: COLUMNS POS_INTEGER COMMA WAGERS POS_INTEGER COMMA ADDON JSON_ARRAY

active: OPEN_BRACKET GAMEID POS_INTEGER COMMA DRAWID POS_INTEGER COMMA DRAWTIME POS_INTEGER COMMA STATUS ANUM COMMA DRAWBREAK POS_INTEGER COMMA VISUALDRAW POS_INTEGER COMMA PRICEPOINTS pricePoints PRIZECATEGORIES prizeCategories WAGERSTATISTICS wagerStatistics CLOSE_BRACKET

content: OPEN_QUOTE last CLOSE_QUOTE COMMA

sort: OPEN_QUOTE OPEN_BRACKET DIRECTION ANUM COMMA PROPERTY CLASS_STRING COMMA IGNORECASE BOOL COMMA NULLHANDLING ANUM COMMA DESCENDING BOOL COMMA ASCENDING BOOL CLOSE_BRACKET CLOSE_QUOTE COMMA

%%

int main(int argc, char *argv[])
{
    int c;
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
    if (yyin) {
    while ((c = getc(yyin)) != EOF)
        putchar(c);
    }
    printf("\n\n");
    fclose(yyin);
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