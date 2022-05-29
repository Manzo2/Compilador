import compilerTools.TextColor;
import java.awt.Color;

%%
%class LexerColor
%type TextColor
%char
%{
    private TextColor textColor(long start, int size, Color color){
        return new TextColor((int) start, size, color);
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
{Comentario} { return textColor(yychar, yylength(), new Color(146, 146, 146)); }
{EspacioEnBlanco} { /*Ignorar*/ }

/*identificador*/
"$" {/*Ignorar*/}

/*Tipos de datos*/
numero|color { return textColor(yychar, yylength(), Color.red)); }

/*Numero*/
{Numer}{ return textColor(yychar, yylength(), Color.red)); }

/*Colores*/
#[{Letra}{Digito}] {6}{ return textColor(yychar, yylength(), Color.red)); }

/*Operadores de agrupacion*/
"("| ")"| "{"| "}" { return textColor(yychar, yylength(), Color.red)); }

/*Signos de puntuacion*/
"," | ";" { return textColor(yychar, yylength(), Color.red)); }

/*Operador de asignacion*/
--> { return textColor(yychar, yylength(), Color.red)); }

/*Palabras Reservadas*/

bool|int|char|byte|long|double|
if|else|while|for|switch|case|break|try|return|void|
public|protected|private|class|abstract|interface|this|
main|new|operator|sizeof|typedef { return textColor(yychar, yylength(), Color.red)); }

/*Operadores Logicos*/
"&" | "|" { return textColor(yychar, yylength(), Color.red)); }

/*Final*/
final { return textColor(yychar, yylength(), Color.red)); }

//numero erroneo 
0{Numero}{ /*Ignorar*/ }
//identificador erroneo 
{Identificador}{ return textColor(yychar, yylength(), Color.red)); }

. { /* Ignorar */ }