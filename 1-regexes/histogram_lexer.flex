%option noyywrap

%{
/* Now in a section of C that will be embedded
   into the auto-generated code. Flex will not
   try to interpret code surrounded by %{ ... %} */

/* Bring in our declarations for token types and
   the yylval variable. */
#include "histogram.hpp"
#include <iostream>
#include <string.h>

// This is to work around an irritating bug in Flex
// https://stackoverflow.com/questions/46213840/get-rid-of-warning-implicit-declaration-of-function-fileno-in-flex
extern "C" int fileno(FILE *stream);

/* End the embedded code section. */
%}


%%

-?[0-9]+[\.[0-9]+]         { fprintf(stderr, "Number : %s\n", yytext); /* TODO: get value out of yytext and into yylval.numberValue */
                             double numVal;
                             numVal = stod(yytext);
                             numVal = round_to(fractionVal, 0.001); //set to 3 decimal places
                             Number = to_string(numVal);

                              ;  return Number; }

-?[0-9]+/-?[0-9]+          { fprintf(stderr, "Number : %s\n", yytext); /* TODO: get value out of yytext and into yylval.numberValue */
                              double numerator;
                              double denominator;
                              double fractionVal;
                              bool foundFraction = false;
                              int i = 0;
                              while(!foundFraction){
                                 if (yytext(i) == "/"){
                                    numerator = stod(yytext.substr (0,i));
                                    denominator = stod(yytext.substr ((i+1),(len(yytext) - (i+1))))
                                    foundFraction = true
                                 }
                                 i++;
                              }
                              fractionVal = numerator/denominator;
                              fractionVal = round_to(fractionVal, 0.001);
                              Number = to_string(fractionVal)

                              ;  return Number; }



[a-zA-Z]+          { fprintf(stderr, "Word : %s\n", yytext); /* TODO: get value out of yytext and into yylval.wordValue */
                                 Word = yytext;
                              ;  return Word; }

\n              { fprintf(stderr, "Newline\n"); }

[ ]              { fprintf(stderr, "Space\n"); }

\[.*\]
%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s); /* s is the text that wasn't matched */
  exit(1);
}
