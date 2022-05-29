import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*
%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/*identificador*/
"$" {Identificador}{return token(yytext(), "IDENTIFICADOR", yyline, yycolumn);}

/*Tipos de datos*/
numero|color {return token(yytext(), "TIPO DATO", yyline, yycolumn);}

/*Numero*/
{Numer}{return token(yytext(), "NUMERO", yyline, yycolumn);}

/*Colores*/
#[{Letra}{Digito}] {6}{return token(yytext(), "COLOR", yyline, yycolumn);}

/*Operadores de agrupacion*/
"(" {return token(yytext(), "PARENTESIS_A", yyline, yycolumn);}
")" {return token(yytext(), "PARENTESIS_C", yyline, yycolumn);}
"{" {return token(yytext(), "LLAVE_A", yyline, yycolumn);}
"}" {return token(yytext(), "LLAVE_C", yyline, yycolumn);}

/*Signos de puntuacion*/
"," {return token(yytext(), "COMA", yyline, yycolumn);}
";"{return token(yytext(), "PUNTO_COMA", yyline, yycolumn);}

/*Operador de asignacion*/
--> {return token(yytext(), "OP_ASIG", yyline, yycolumn);}

/*Palabras Reservadas*/

bool|int|char|byte|long|double|
if|else|while|for|switch|case|break|try|return|void|
public|protected|private|class|abstract|interface|this|
main|new|operator|sizeof|typedef {return token(yytext(), "P_RESERVADA", yyline, yycolumn);}

/*Operadores Logicos*/
"&" | "|" { return token(yytext(), "O_LOGICO", yyline, yycolumn); }

/*Final*/
final { return token(yytext(), "FINAL", yyline, yycolumn); }

//numero erroneo 
0{Numero}{ return token(yytext(), "ERROR_1", yyline, yycolumn); }
//identificador erroneo 
{Identificador}{ return token(yytext(), "ERROR_2", yyline, yycolumn); }


. { return token(yytext(), "ERROR", yyline, yycolumn); }