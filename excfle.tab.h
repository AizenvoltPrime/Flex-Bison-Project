/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_EXCFLE_TAB_H_INCLUDED
# define YY_YY_EXCFLE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    COMMA = 258,                   /* "comma"  */
    OPEN_QUOTE = 259,              /* "opening quote"  */
    CLOSE_QUOTE = 260,             /* "closing quote"  */
    OPEN_BRACKET = 261,            /* "opening bracket"  */
    CLOSE_BRACKET = 262,           /* "closing bracket"  */
    JSON_NUMBER = 263,             /* "json number"  */
    POS_INTEGER = 264,             /* "positive integer"  */
    DECIMAL = 265,                 /* "decimal number"  */
    ARRAY_INT = 266,               /* "array with integers"  */
    JSON_STRING = 267,             /* "json string"  */
    JSON_ARRAY = 268,              /* "json array"  */
    ANUM = 269,                    /* "alpharithmetic"  */
    CLASS_STRING = 270,            /* "property class string"  */
    UNKNOWN = 271,                 /* "unknown"  */
    EOL = 272,                     /* "end of line"  */
    LAST = 273,                    /* "last:"  */
    ACTIVE = 274,                  /* "active:"  */
    GAMEID = 275,                  /* "gameId:"  */
    DRAWID = 276,                  /* "drawId:"  */
    DRAWTIME = 277,                /* "drawTime:"  */
    STATUS = 278,                  /* "status:"  */
    DRAWBREAK = 279,               /* "drawBreak:"  */
    VISUALDRAW = 280,              /* "visualDraw:"  */
    PRICEPOINTS = 281,             /* "pricePoints:"  */
    AMOUNT = 282,                  /* "amount:"  */
    WINNINGNUMBERS = 283,          /* "winningNumbers:"  */
    PRIZECATEGORIES = 284,         /* "prizeCategories:"  */
    WAGERSTATISTICS = 285,         /* "wagerStatistics:"  */
    LIST = 286,                    /* "list:"  */
    BONUS = 287,                   /* "bonus:"  */
    ID = 288,                      /* "id:"  */
    DIVIDENT = 289,                /* "divident:"  */
    WINNERS = 290,                 /* "winners:"  */
    DISTRIBUTED = 291,             /* "distributed:"  */
    JACKPOT = 292,                 /* "jackpot:"  */
    FIXED = 293,                   /* "fixed:"  */
    CATEGORYTYPE = 294,            /* "categoryType:"  */
    GAMETYPE = 295,                /* "gameType:"  */
    MINIMUMDISTRIBUTED = 296,      /* "minimumDistributed:"  */
    COLUMNS = 297,                 /* "columns:"  */
    WAGERS = 298,                  /* "wagers:"  */
    ADDON = 299,                   /* "addOn:"  */
    CONTENT = 300,                 /* "content:"  */
    TOTALPAGES = 301,              /* "totalPages:"  */
    TOTALELEMENTS = 302,           /* "totalElements:"  */
    NUMBEROFELEMENTS = 303,        /* "numberOfElements:"  */
    SORT = 304,                    /* "sort:"  */
    FIRST = 305,                   /* "first:"  */
    SIZE = 306,                    /* "size:"  */
    NUMBERTOKEN = 307,             /* "number:"  */
    DIRECTION = 308,               /* "direction:"  */
    PROPERTY = 309,                /* "property:"  */
    IGNORECASE = 310,              /* "ignoreCase:"  */
    NULLHANDLING = 311,            /* "nullHandling:"  */
    DESCENDING = 312,              /* "descending:"  */
    ASCENDING = 313,               /* "ascending:"  */
    BOOL = 314,                    /* "boolean"  */
    INVALID_STRING = 315           /* "alpharithmetic without quotes"  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_EXCFLE_TAB_H_INCLUDED  */
