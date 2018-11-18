%{
#include "interprete.tab.h"
int linea =1;
%}
%option noyywrap

espacio [ ]+
tab [\t]+
enter \n
INICIO inicio
FIN fin
LEER leer
ESCRIBIR escribir
identificador [a-zA-Z][a-zA-Z0-9]{0,31}
integer [0-9]+
suma [+]+
resta -(--)*
suma_resta (--)+
error_cons [!-&.<-@\]*[0-9][a-zA-Z0-9!-&.<-@]+[0-9]*
error_sym [!-&.<-@\]+

%%
{espacio} {;}
{tab} {;}
{enter} {linea++;}
{INICIO} {return INICIO;}
{FIN} {return FIN;}
{LEER} {return LEER;}
{ESCRIBIR} {return ESCRIBIR;}
{integer} {yylval.val=atoi(yytext); return INTEGER;}
{identificador} {yylval.text = strdup(yytext); return ID;}
{suma}				return(SUMA);
{resta}             return(RESTA);
{suma_resta}        return(SUMA);
"("					return(PARENT_IZQ);
")"					return(PARENT_DER);
":="				return(ASIGNACION);
","					return(COMA);
";"					return(FIN_SENTENCIA);
{error_cons}				{yyerror("The value is not a number.");}
{error_sym}         {yyerror("Unacceptable character.");}

%%
