%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//#include <conio.h>
#define SIZE 100
#define IDSIZE 33
#define YYERROR_VERBOSE 1

struct identificador{
    char *nombre;
    int valor;
}identificadores[SIZE];

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int linea;

//void inicializarVectorNombre(void);
void yyerror(const char *);
int existeID(char *,int *);
void declaracionOAsignacion(char *,int );
void leer(char *);
void escribir(int);
int buscarValor(char *);
int esUnNumero(char *);

%}

%union{
        int val;
        char *text;
}


%token 	<val>INTEGER
%token 	SUMA RESTA
%token 	FIN_SENTENCIA
%token 	PARENT_IZQ 		PARENT_DER
%token 	ASIGNACION
%token 	COMA
%token 	INICIO 			FIN
%token 	LEER 			ESCRIBIR
%token  ID

%left 	SUMA RESTA

%type<val>Expresion //@la expresion tiene type?
%type<val>Primaria
%type<text>ID


%start 	Input

%%

Input:  INICIO Lista_Sentencias FIN {printf("\nProgram executed successfully!.\n");/*getch();*/exit(0);}
				;

Lista_Sentencias:	Sentencia
					      | Sentencia Lista_Sentencias
					      ;

Sentencia:  ID ASIGNACION Expresion FIN_SENTENCIA  { declaracionOAsignacion($1,$3); }
					| LEER PARENT_IZQ Lista_Ids PARENT_DER FIN_SENTENCIA
					| ESCRIBIR PARENT_IZQ Lista_Expr PARENT_DER FIN_SENTENCIA
					;

Lista_Ids:  ID { leer($1); }
					| Lista_Ids COMA ID { leer($3); }
					;

Lista_Expr:	Expresion { escribir($1); }
					| Lista_Expr COMA Expresion { escribir($3); }
					;

Expresion:	Primaria { $$=$1; }
          | RESTA Primaria { $$ = -$2; }
					| Expresion SUMA Primaria { $$ = $1 + $3; }
          | Expresion RESTA Primaria { $$ = $1 - $3; }
					;

Primaria:		ID { $$ = buscarValor($1); }
					| INTEGER { $$ = $1; }
          | SUMA INTEGER {$$ = $2;}
          | PARENT_IZQ Expresion PARENT_DER { $$ = $2; }
					;

%%
void inicializarVectorNombre(void){
    for (int i=0;i<SIZE;i++) identificadores[i].nombre=NULL;
}

void vaciarVectorNombre(void){
    for (int i=0;i<SIZE;i++) free(identificadores[i].nombre);
}

int main(int argc,char **argv) {
    inicializarVectorNombre();

    if(argc==1){
        yyparse();
    } else if(argc==2){
        yyin = fopen(argv[1], "r");
        if(!yyin){
            printf("\nERROR: The file couldn't be opened.\n");
            return -1;
          }
        yyparse();
        fclose(yyin);
        }
    else { printf("\nERROR: Incorrect number of parameters to the funtion.\n"); return -2;}
    vaciarVectorNombre();
    return 0;
}


void yyerror(const char *s){
  printf("Error on line %d. Message: %s\n",linea,s);
  //getch();
  exit(-1);
}

int existeID(char *nombre,int *i){
    for(*i;*i<SIZE && identificadores[*i].nombre!=NULL;(*i)++) if (!strcmp(identificadores[*i].nombre,nombre)) return 1;
    return 0;
}

void declaracionOAsignacion(char *nombre,int valor){
  int i = 0;
  if(!existeID(nombre,&i)){ // Si no existe el ID (Declaracion y asignacion)
    identificadores[i].nombre=(char*)malloc(IDSIZE);
    strcpy(identificadores[i].nombre,nombre);
    identificadores[i].valor=valor;
  } else{ // Existe el ID (Asignacion)
    identificadores[i].valor=valor;
  }
  return;
}

void leer(char *nombre){
    char valor[30];
    printf("\nEnter the value of %s = ",nombre);
    scanf("%s\n",valor);
    if(!esUnNumero(valor)) yyerror("The value is not a number.");
    declaracionOAsignacion(nombre,atoi(valor));
}

int esUnNumero(char *numero){
    int i=0;
    if(*(numero+i)=='-' || *(numero+i)=='+')  i++;
    while(*(numero+i)!='\0'){
        if(*(numero+i) >= '0' && *(numero+i) <='9')i++;
        else return 0; // Cuando falla
    }
    return 1;
}

void escribir(int valor){
    printf("\nResult: %d\n",valor);
}

int buscarValor(char *nombre){
    int i=0;
    char mensajeError[100] = "Identifier [";
    strcat(mensajeError,nombre);
    strcat(mensajeError,"] doesn't exist.\n");
    if(!existeID(nombre,&i)) yyerror(mensajeError);
    return identificadores[i].valor;
}
