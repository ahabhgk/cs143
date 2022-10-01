/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */

CLASS [Cc][Ll][Aa][Ss][Ss]
ELSE [Ee][Ll][Ss][Ee]
FI [Ff][Ii]
IF [Ii][Ff]
IN [Ii][Nn]
INHERITS [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
ISVOID [Ii][Ss][Vv][Oo][Ii][Dd]
LET [Ll][Ee][Tt]
LOOP [Ll][Oo][Oo][Pp]
POOL [Pp][Oo][Oo][Ll]
THEN [Tt][Hh][Ee][Nn]
WHILE [Ww][Hh][Ii][Ll][Ee]
CASE [Cc][Aa][Ss][Ee]
ESAC [Ee][Ss][Aa][Cc]
NEW [Nn][Ee][Ww]
OF [Oo][Ff]
NOT [Nn][Oo][Tt]
TRUE t[Rr][Uu][Ee]
FALSE f[Aa][Ll][Ss][Ee]
DIGIT [0-9]

/*
 * Define states.
 */

%x COMMENT
  int comments_layer = 0;

%%

 /*
  *  Nested comments
  */

"(*" {
  BEGIN(COMMENT);
  comments_layer++;
}
<COMMENT>{
  "*)" {
    comments_layer--;
    if (comments_layer == 0) {
      BEGIN(INITIAL);
    }
  }
  <<EOF>> {
    cool_yylval.error_msg = "EOF in comments";
    BEGIN(INITIAL);
    return ERROR;
  }
  \n { curr_lineno++; }
  . { }
}
"*)" {
  cool_yylval.error_msg = "Unmatched *)";
  return ERROR;
}

 /*
  * Single line comment
  */

"--".* { }


 /*
  *  The multiple-character operators.
  */

"=>" { return DARROW; }
"<-" { return ASSIGN; }
"<=" { return LE; }
"<" { return int('<'); }
"+" { return int('+'); }
"-" { return int('-'); }
"*" { return int('*'); }
"/" { return int('/'); }
"=" { return int('='); }
"{" { return int('{'); }
"}" { return int('}'); }
":" { return int(':'); }
";" { return int(';'); }
"(" { return int('('); }
")" { return int(')'); }
"," { return int(','); }
"." { return int('.'); }
"~" { return int('~'); }
"@" { return int('@'); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  * 
  * class, else, fi, if, in, inherits, isvoid, let, loop, pool,
  * then, while, case, esac, new, of, not, true, false
  */

{CLASS} { return CLASS; }
{ELSE} { return ELSE; }
{FI} { return FI; }
{IF} { return IF; }
{IN} { return IN; }
{INHERITS} { return INHERITS; }
{ISVOID} { return ISVOID; }
{LET} { return LET; }
{LOOP} { return LOOP; }
{POOL} { return POOL; }
{THEN} { return THEN; }
{WHILE} { return WHILE; }
{CASE} { return CASE; }
{ESAC} { return ESAC; }
{NEW} { return NEW; }
{OF} { return OF; }
{NOT} { return NOT; }

 /* BOOL_CONST */
{TRUE} {
  cool_yylval.boolean = 1;
  return BOOL_CONST;
}
{FALSE} {
  cool_yylval.boolean = 0;
  return BOOL_CONST;
}

 /* INT_CONST */
{DIGIT}+ {
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
}

 /* TYPEID */
[A-Z][A-Za-z0-9_]* {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}

 /* OBJECTID */
[a-z][A-Za-z0-9_]* {
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

 /* Lines */
"\n" {
  curr_lineno++;
}

 /* White Space */
[ \f\r\t\v]+ { }

 /* . {
  *   cool_yylval.error_msg = yytext;
  *   return ERROR;
  * }
  */

%%
