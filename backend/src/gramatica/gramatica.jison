//CODIGO JS
%{
    console.log("SE COMPILO EL ARCHIVO .JISON");
%}


//configuraciones
%lex
%options case-insensitive

char                [\']([\\].|[^\'\n])[\']
int                 [0-9]+
boolean             'true'|'false'
double              {int}'.'{int}  
string              [\"]([\\][\"]|[^\"])*[\"]ß
letra               [a-zA-ZÑñ]+
id                  ({letra}|('_'{letra})|({letra}'_'))({letra}|{int}|'_')*


%%
//definir tokens
\s+                                         /* skip whitespace */

//COMENTARIOS
"//".*	                                    // comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]			// comentario multiple líneas
//PALABRAS RESERVADAS

//ESTRUCTURAS DE DATOS
"new"                   return 'new'
"DynamicList"           return 'lista_dinamica'
"append"                return 'append'
"getValue"              return 'getValue'
"setValue"              return 'setValue'

//SENTENCIAS
"if"                    return 'if'
"else"                  return 'else'
"switch"                return 'switch'
"case"                  return 'case'
"default"               return 'default'
"while"                 return 'while'
"for"                   return 'for'
"do"                    return 'do'
"break"                 return 'break'
"continue"              return 'continue'
"return"                return 'return'

//FUNCIONES
"void"                  return 'void'
"start"                 return 'start'
"with"                  return 'with'
"WriteLine"             return 'WriteLine' 
"toLower"               return 'toLower'
"toUpper"               return 'toUpper'
"length"                return 'length'
"truncate"              return 'truncate'
"round"                 return 'round' 
"typeof"                return 'typeof'
"tostring"              return 'tostring'
"toCharArray"           return 'toCharArray'

//TIPOS DE DATO
"string"                return 't_string'
"char"                  return 't_char'
"int"                   return 't_int'
"boolean"               return 't_boolean'
"double"                return 't_double' 



//OPERADORES ARITMETICOS
"++"                    return '++'
"--"                    return '--'
"+"                     return '+'
"-"                     return '-'
"*"                     return '*'
"/"                     return '/'
"ˆ"                     return 'ˆ'
"%"                     return '%'


//OPERADORES RELACIONALES
"<"                     return '<'
">"                     return '>'
"<="                    return '<='
">="                    return '>='
"=="                    return '=='
"!="                    return '!='

//ASIGNACION
"="                     return '='


//OPERADORES LOGICOS
"||"                    return '||'
"&&"                    return '&&'
"!"                     return '!'



//SIGNOS DE PUNTUACION
":"                     return ':'
"?"                     return '?'
";"                     return ';'
","                     return ','


//SIGNO IGUAL
"="                     return '='

//SIGNOS DE AGRUPACION
"("                     return '('
")"                     return ')' 
"{"                     return '{'
"}"                     return '}'
"["                     return '['
"]"                     return ']'

     

//VALORES-TIPO DE DATO
{char}                  return 'char'
{double}                return 'double'
{int}                   return 'int'
{boolean}               return 'boolean'
{string}                return 'string'
{id}                    return 'id'

<<EOF>>		            return 'EOF'

/lex

//DEFINIR PRECEDENCIA DE LOS OPERADORES
%right          '-'
%nonassoc       'ˆ'
%left           '/','*'
%left           '+','-'
%left           '==','!=','<','<=','>','>='
%right          '!'
%left           '&&'
%left           '||'
%left           '%'
%nonassoc       '++','--'
%left           '?', ':'
%nonassoc       '(' , ')'





//DEFINIR NO TERMINAL DE INICIO
%start INICIO

%%

//producciones
//NODO INICIAL
INICIO
    :ENTORNO_GLOBAL EOF {
        console.log('ANALISIS EXITOSO');
        return $1;
    }
    ;

//LISTA DE INSTRUCCIONES EN EL ENTORNO GLOBAL QUE EJECUTARA EL PROGRAMA
ENTORNO_GLOBAL
    :ENTORNO_GLOBAL GLOBAL {
        $1.push($2);
        $$ = $1;
    }
    |GLOBAL{
        $$=[$1];
    }
    ;

//INSTRUCCIONES GLOBALES
GLOBAL    
    :DECLARACION_VARIABLE{
        $$=$1;
    }
    |DECLARACION_FUNCIONES{
        $$=$1;
    }
    |INICIAR_SISTEMA{
        $$=$1
    }
    ;

//DECLARAR EL INICIO DEL SISTEMA
INICIAR_SISTEMA
    :'start' 'with' 'id' '(' ')' ';'
    |'start' 'with' 'id' '(' LISTA_VALORES ')' ';'
    ;

//LISTA DE VALORES PARA INGRESAR LOS PARAMETROS DE FUNCIONES Y METODOS PARA INICIAR EL SISTEMA
LISTA_VALORES
    :LISTA_VALORES ',' EXPRESION{
        $1.push($3);
        $$ = $1;
    }
    |EXPRESION{
        $$ = [$1];
    }
    ;


//DECLARACION DE FUNCIONES O METODOS
DECLARACION_FUNCIONES
    :TIPO_DATO 'id' '(' PARAMETROS_FUNCION ')' ENTORNO
    |'void' 'id' '(' PARAMETROS_FUNCION ')' ENTORNO
    |'void' 'id' '(' ')' ENTORNO
    |TIPO_DATO 'id' '(' ')' ENTORNO
    ;



//PARAMETROS PARA UNA FUNCION O METODO
PARAMETROS_FUNCION
    : PARAMETROS_FUNCION ',' TIPO_DATO 'id'
    |TIPO_DATO 'id'
    ;


//LISTA DE INSTRUCCIONES
INSTRUCCIONES
    :INSTRUCCIONES INSTRUCCION{
        $1.push($2);
        $$ = $1;
    }
    |INSTRUCCION{
        $$ = [$1];
    }
    ;

//INSTRUCCIONES QUE INGRESARAN EN UNA LISTA
INSTRUCCION
    :DECLARACION_VARIABLE{
        $$ = $1;
    }
    |ASIGNACION ';'{
        $$ = $1;
    }
    |FUNCIONES_CALL ';'{
        $$ = $1;
    }
    |SENTENCIAS{
        $$ = $1;
    }
    |TRANSFERENCIA ';'{
        $$ = $1;
    }
    ;

//SENTENCIAS DE TRANSFERENCIA
TRANSFERENCIA   
    :'break' 
    |'return' EXPRESION 
    |'return' 
    |'continue' 
    ;

//SENTENCIAS (CICLOS Y CONDICIONES) A UTILIZAR EN EL LENGUAJE
SENTENCIAS
    :GENERARIF{
        $$ = $1;
    }
    |GENERARSWITCH{
        $$ = $1;
    }
    |GENERARWHILE{
        $$ = $1;
    }
    |GENERARFOR{
        $$ = $1;
    }
    |GENERARDOWHILE{
        $$ = $1;
    }
    ;
   
//SENTENCIA PARA EL CICLO IF Y TODAS SUS VARIANTES
GENERARIF
    :'if' '(' EXPRESION ')' ENTORNO
    |'if' '(' EXPRESION ')' ENTORNO GENERARELSE
    |'if' '(' EXPRESION ')' ENTORNO GENERARELSEIF
    ;

//SENTENCIA PARA ELSE
GENERARELSE
    :'else' ENTORNO
    ;

//SENTENCIA PARA ELSE IF
GENERARELSEIF
    :'else' GENERARIF 
    ;

//SENTENCIA PARA SWITCH
GENERARSWITCH
    :'switch' '(' EXPRESION ')' ENTORNO
    ;

//LISTA DE CASOS DEL SWITCH
CASES_LIST
    :CASES_LIST 'case' EXPRESION ':' INSTRUCCIONES
    |'case' EXPRESION ':' INSTRUCCIONES
    ;

//DEFAULT PARA EL SWITCH
DEFAULT
    :'default' ':' INSTRUCCIONES
    ;

//SENTENCIA PARA WHILE
GENERARWHILE
    :'while' '(' EXPRESION ')' ENTORNO
    ;

//SENTENCIA PARA FOR
GENERARFOR
    :'for' '(' DECLARACION_VARIABLE EXPRESION ';' ASIGNACION ')' ENTORNO
    |'for' '(' ASIGNACION ';' EXPRESION ';' ASIGNACION ')' ENTORNO
    ;

//SENTENCIA PARA DO WHILE
GENERARDOWHILE
    :'do' ENTORNO 'while' '(' EXPRESION ')' ';'
    ;

//ENTORNO PARA EL ENCAPSULAMIENTO DE INSTRUCCIONES EN DIFERENTES AMBITOS
ENTORNO
    :'{' '}' 
    |'{' INSTRUCCIONES '}'
    |'{' CASES_LIST DEFAULT '}' 
    |'{' CASES_LIST '}'
    |'{' DEFAULT '}'
    ;

//LLAMADA DE FUNCIONES
FUNCIONES_CALL   
    :FUNCIONES_NATIVAS{
        $$ = $1;
    }
    |FUNCIONES_DECLARADAS{
        $$ = $1;
    }
    ;

//LLAMADA DE FUNCIONES DECLARADAS
FUNCIONES_DECLARADAS
    :'id' '(' PARAMETROS_CALL ')' 
    |'id' '(' ')' 
    ;

//PARAMETROS DE UNA LLAMADA DE FUNCION O METODO
PARAMETROS_CALL
    :PARAMETROS_CALL ',' 'id'
    |'id'
    ;

//LLAMADA DE FUNCIONES NATIVAS
FUNCIONES_NATIVAS
    :'append' '(' id ',' EXPRESION ')'
    |'getValue' '(' id ',' EXPRESION ')'
    |'setValue' '(' id ',' EXPRESION ',' EXPRESION ')'
    |'WriteLine' '(' EXPRESION ')'
    |'toLower' '(' id ',' EXPRESION ')' 
    |'toUpper' '(' id ',' EXPRESION ')' 
    |'length' '(' EXPRESION ')' 
    |'truncate' '(' EXPRESION ')' 
    |'round' '(' EXPRESION ')' 
    |'typeof' '(' EXPRESION ')' 
    |'tostring' '(' EXPRESION ')' 
    |'toCharArray' '(' EXPRESION ')' 
    ;


//DECLARACION DE VARIABLE
DECLARACION_VARIABLE
    :TIPO_DATO ASIGNACION ';'
    |'lista_dinamica' '<' TIPO_DATO '>' ASIGNACION ';'
    ;



//ASIGNACION DE VARIABLES
ASIGNACION
    :LISTA_ID '=' EXPRESION
    |LISTA_ID '[' ']' '=' EXPRESION
    |LISTA_ID '[' EXPRESION ']' '=' EXPRESION
    |LISTA_ID '[' ']'
    |LISTA_ID
    |'id' '++'
    |'id' '--'
    ;

//LISTA DE ID
LISTA_ID
    :LISTA_ID ',' 'id'{
        $1.push($3);
        $$ = $1;
    }
    |'id'{
        $$ = [$1];
    }
    ;

//TIPOS DE DATO
TIPO_DATO
    :'t_double'
    |'t_char'
    |'t_int'
    |'t_string'
    |'t_boolean'
    ;

//EXPRESIONES
EXPRESION
    :EXPMAT
    |EXPLOG
    |EXPREL
    |EXPTER
    |FUNCIONES_CALL
    |'(' TIPO_DATO ')' EXPRESION
    |'(' EXPRESION ')'
    |'new' 'lista_dinamica' '<' TIPO_DATO '>'
    |ARRAY
    |VALORES
    |'id'
    ;

//EXPRESIONES PARA DAR EL VALOR DEL ARRAY
ARRAY
    :'{' VALORES_LIST '}'
    |'new' TIPO_DATO '[' EXPRESION ']'
    |'id' '[' VALORES ']'
    ;

//EXPRESIONES ARITMETICAS
EXPMAT
    :EXPRESION '+' EXPRESION
    |EXPRESION '-' EXPRESION
    |EXPRESION '/' EXPRESION
    |EXPRESION '*' EXPRESION
    |EXPRESION 'ˆ' EXPRESION
    |EXPRESION '%' EXPRESION
    |'-' EXPRESION
    ;

//EXPRESIONES LOGICAS
EXPLOG
    :EXPRESION '&&' EXPRESION
    |EXPRESION '||' EXPRESION
    |'!' EXPRESION
    ;

//EXPRESIONES RELACIONALES
EXPREL
    :EXPRESION '==' EXPRESION
    |EXPRESION '!=' EXPRESION
    |EXPRESION '<' EXPRESION
    |EXPRESION '<=' EXPRESION
    |EXPRESION '>' EXPRESION
    |EXPRESION '>=' EXPRESION
    ;

//EXPRESION PARA OPERADOR TERNARIO
EXPTER  
    :EXPRESION '?' EXPRESION ':' EXPRESION
    ;



//LISTA DE LITERALES
VALORES_LIST
    :VALORES_LIST ',' VALORES
    |VALORES
    ;

//LITERALES
VALORES
    :'char'
    |'double'
    |'int'
    |'string'
    |'boolean'
    ;
