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
#include <cmath>

// This is to work around an irritating bug in Flex
// https://stackoverflow.com/questions/46213840/get-rid-of-warning-implicit-declaration-of-function-fileno-in-flex
extern "C" int fileno(FILE *stream);

/* End the embedded code section. */
%}


%%

-?[0-9]+(\.[0-9]*)?        { fprintf(stderr, "Number : %s\n", yytext); /* TODO: get value out of yytext and into yylval.numberValue */
                              double numVal;
                              numVal = std::stod(yytext);
                              yylval.numberValue = numVal;
                              return Number; }

-?[0-9]+[\/][0-9]+          { fprintf(stderr, "Number : %s\n", yytext); /* TODO: get value out of yytext and into yylval.numberValue */
                              double numerator;
                              double denominator;
                              double fractionVal;
                              bool foundFraction = false;
                              int i = 0;
                              std::string str(yytext);
                              while(!foundFraction){
                                 if (str[i] == '/'){
                                    numerator = std::stod(str.substr (0,i));
                                    denominator = std::stod(str.substr ((i+1),(str.length() - (i+1))));
                                    foundFraction = true;
                                 }
                                 i++;
                              }
                              fractionVal = numerator/denominator;
                              
                              yylval.numberValue = fractionVal

                              ;  return Number; }



[a-zA-Z]+          { fprintf(stderr, "Word : %s\n", yytext); /* TODO: get value out of yytext and into yylval.wordValue */
                                 
                                 yylval.wordValue = new std::string (yytext);
                                return Word; }

\[([^\]]*)\]            { fprintf(stderr, "Word : %s\n", yytext); /* TODO: get value out of yytext and into yylval.wordValue */
                                 std::string bracketString;
                                 std::string str(yytext);
                                 bracketString = str.substr(1, (str.length() - 2)); 
                                 yylval.wordValue = new std::string(bracketString)
                              ;  return Word; }

.|\n              { fprintf(stderr, "Newline\n"); }

[ \t]              { fprintf(stderr, "Space\n"); }


%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s); /* s is the text that wasn't matched */
  exit(1);
}
