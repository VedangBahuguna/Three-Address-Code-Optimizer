%{
    #include<bits/stdc++.h>
    using namespace std;
    #include "a4.tab.h"
    void yyerror(string);
%}

%%
if  {yylval.STR = strdup(yytext); return IF;}

goto    {yylval.STR = strdup(yytext); return GOTO;}

print   {yylval.STR = strdup(yytext); return PRINT;}

read    {yylval.STR = strdup(yytext); return READ;}

[\+\-\/\*\!\:\=]  {return *yytext;}

\=\=    {yylval.STR = strdup(yytext); return COMPARISON;}

\!\=    {yylval.STR = strdup(yytext); return COMPARISON;}

[\<]    {yylval.STR = strdup(yytext); return COMPARISON;}

\<\=    {yylval.STR = strdup(yytext); return COMPARISON;}

[\>]    {yylval.STR = strdup(yytext); return COMPARISON;}

\>\=    {yylval.STR = strdup(yytext); return COMPARISON;}

[0-9]+  {yylval.STR = strdup(yytext); return NUMBER;}

[a-zA-Z][a-zA-Z0-9]*    {yylval.STR = strdup(yytext); return IDENTIFIER;}

[ \n\t\r\v\f]   {}

.   {yyerror("");}
%%

int yywrap()
{
    return 1;
}