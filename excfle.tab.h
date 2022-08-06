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
    JSON_STRING = 266,             /* "json string"  */
    JSON_ARRAY = 267,              /* "json array"  */
    ANUM = 268,                    /* "alpharithmetic"  */
    UNKNOWN = 269,                 /* "unknown"  */
    EOL = 270,                     /* "end of line"  */
    LAST = 271,                    /* "last"  */
    ACTIVE = 272,                  /* "active"  */
    GAMEID = 273,                  /* "gameId"  */
    DRAWID = 274,                  /* "drawId"  */
    DRAWTIME = 275,                /* "drawTime"  */
    STATUS = 276,                  /* "status"  */
    DRAWBREAK = 277,               /* "drawBreak"  */
    VISUALDRAW = 278,              /* "visualDraw"  */
    PRICEPOINTS = 279,             /* "pricePoints"  */
    AMOUNT = 280,                  /* "amount"  */
    WINNINGNUMBERS = 281,          /* "winningNumbers"  */
    PRIZECATEGORIES = 282,         /* "prizeCategories"  */
    WAGERSTATISTICS = 283,         /* "wagerStatistics"  */
    LIST = 284,                    /* "list"  */
    BONUS = 285,                   /* "bonus"  */
    ID = 286,                      /* "id"  */
    DIVIDENT = 287,                /* "divident"  */
    WINNERS = 288,                 /* "winners"  */
    DISTRIBUTED = 289,             /* "distributed"  */
    JACKPOT = 290,                 /* "jackpot"  */
    FIXED = 291,                   /* "fixed"  */
    CATEGORYTYPE = 292,            /* "categoryType"  */
    GAMETYPE = 293,                /* "gameType"  */
    MINIMUMDISTRIBUTED = 294,      /* "minimumDistributed"  */
    COLUMNS = 295,                 /* "columns"  */
    WAGERS = 296,                  /* "wagers"  */
    ADDON = 297                    /* "addOn"  */
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
