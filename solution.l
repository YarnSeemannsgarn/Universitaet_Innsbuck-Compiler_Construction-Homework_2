%x COMMENT
%{
#include <stdio.h>

int lexicalErrors = 0;
char output[] = "Line %3u: %20s (%s)\n";
FILE *genFile;

// For modula 2 comments
int comment_nesting = 0;
int total_number_of_comments = 0;
int max_comment_nesting = 0;

char *convertToUpper(char *text);
void substring(char s[], char sub[], int p, int l);

%}

%option yylineno

WHITESPACE [ \t\n]
DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z_0-9]*

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]

%%
    /* Keywords */
{P}{R}{O}{G}{R}{A}{M}|{V}{A}{R}|{I}{N}{T}{E}{G}{E}{R}|{A}{R}{R}{A}{Y}|{O}{F}|{R}{E}{A}{L}|{B}{E}{G}{I}{N}|{W}{H}{I}{L}{E}|{D}{O}|{I}{F}|{T}{H}{E}{N}|{E}{L}{S}{E}|{E}{N}{D}|{F}{O}{R}|{T}{O}|{C}{O}{N}{S}{T} {
  printf(output, yylineno, yytext, "keyword");
  fprintf(genFile, "%s", convertToUpper(yytext));
} 

   /* Special symbols */
";"|","|":="|":"|"["|"]"|".."|"."|"("|")"|"*"|"/"|"+"|"-"|"<>"|"<"|">"|">="|"<="|"=" { printf( output, yylineno, yytext, "special symbol" ); fprintf( genFile, "%s", yytext ); }

\"(\\.|[^\\"])*\"|\'(\\.|[^\\'])*\'             { printf(output, yylineno, yytext, "string"); fprintf(genFile, "%s", yytext); }

    /* Numbers */
{DIGIT}+                      { printf(output, yylineno, yytext, "integer"); fprintf(genFile, "%s", yytext); }

    /* Identifiers */
{ID}                          { printf(output, yylineno, yytext, "identifier"); fprintf(genFile, "%s", yytext); }

    /* Garbage */
"{"[^}\n]*"}"                 { 
                                total_number_of_comments++;
                                int length = strlen(yytext)-2;
                                char sub[length];
                                substring(yytext, sub, 2, length); 
                                fprintf(genFile, "(*%s*)", sub);
                              }

    /* Modula 2 comments */
"(*"                          { 
                                BEGIN(COMMENT);
                                ++comment_nesting;
                                if(comment_nesting > max_comment_nesting) {
                                  max_comment_nesting = comment_nesting;
                                }
                              }
<COMMENT>[^*)]                /* Eat non-comment delimiters */
<COMMENT>"(*"                 { 
                                ++comment_nesting;
                                if(comment_nesting > max_comment_nesting) {
                                  max_comment_nesting = comment_nesting;
                                }
                              }
<COMMENT>"*)"                 { 
                                total_number_of_comments++; 
                                if(--comment_nesting == 0) {
                                  BEGIN(INITIAL);
                                }
                              }
<COMMENT>[*)]                 /* Eat a ) or * if it doesn't match comment sequence */

    /* Whitespaces */
{WHITESPACE}+                 fprintf(genFile, " ");

    /* Lexical errors */
.                             { 
                                  printf(output, yylineno, yytext, "LEXICAL ERROR - Unrecognized character");
                                  lexicalErrors++;
                              }

%%

main(int argc, char **argv) {
  if(argc != 3) {
    printf("ERROR - Wrong number of arguments!\nUsage: solution <inputFile> <genOutputFile>\n");
    return 1;
  }

  yyin = fopen(argv[1], "r");
  genFile = fopen(argv[2], "w+");

  char stars[] = "*********************************************************\n";
  printf("%sScanning starts\n%s", stars, stars);

  yylex();
  
  printf("\n%sThere is/are %d lexical error/s in the programme\n", stars, lexicalErrors);
  printf("There are %d comments in total\n", total_number_of_comments);
  printf("The maximum nested comment level is %d\n%s", max_comment_nesting, stars); 
  fclose(genFile);
  return 0;
}

char *convertToUpper(char *text){
  char *nText = strdup(text);
  int i;

  for(i=0; i<=strlen(text); i++){
    if((text[i] > 96 ) && (text[i] < 123)) // is the char lower case
      nText[i] = text[i] - 'a' + 'A';   //make upper
    else
      nText[i] = text[i]; //do nothing
  }
  return nText;
}

void substring(char s[], char sub[], int p, int l) {
  int c = 0;
 
  while (c < l) {
    sub[c] = s[p+c-1];
    c++;
  }
  sub[c] = '\0';
}
