%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "interprete.tab.h"
extern int yylex();
extern int yyparse();

void inicializarVectorNombre(void);
%}
%option noyywrap

espacio         [ ]+
tab							[\t]+
enter						[\n]+
INICIO INICIO
FIN FIN
LEER LEER
ESCRIBIR ESCRIBIR
identificador	[a-zA-Z][a-zA-Z0-9]{0,31}
integer		[0-9]+

%%

{espacio}		{}
{tab}		{}
{enter}		{}
{INICIO}	{ return INICIO;}
{FIN}	{ return FIN; }
{LEER}	{return LEER;}
{ESCRIBIR}	{return ESCRIBIR;}
{integer}	{
				yylval.val=atoi(yytext);
				return INTEGER;
				}
{identificador}	{
				strcpy(yylval.text,yytext);
				return ID;
				}


"+"					return(MAS);
"-"					return(MENOS);
"("					return(PARENT_IZQ);
")"					return(PARENT_DER);
":="				return(ASIGNACION);
","					return(COMA);
";"					return(FIN_SENTENCIA);

%%

int main(int argc,char **argv) {
    inicializarVectorNombre();
    if(argc==1){
        yyparse();
    } else if(argc==2){
        yyin = fopen(argv[1], "r");
        if(!yyin){
            printf("ERROR: no se pudo abrir el archivo. Ingrese otro.");
            return -1;
          }
        yyparse();
				fclose(yyin);
        }
    else { printf("ERROR: Parametros incorrectos. Por favor ingrese la cantidad de parametros correcta."); }
    return 0;
}
