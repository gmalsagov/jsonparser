package Example;

import java_cup.runtime.SymbolFactory;
%%
%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
	}
	private SymbolFactory sf;
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

// Below we defined our tokens using regular expressions

// A string is a sequence of zero or more Unicode characters, wrapped in double
// quotes, using backslash escapes. A character is represented as a single
// character string.
String = \"{chars}*\"
chars = {unicode_char} | {escape_char}
// Matches any unicode char if it's not a \ or "
unicode_char = [^\\\"]
escape_char = (\\)[\"\\/bfnrt] | (\\u)[0-9a-fA-F]{4}

// A number consists of mandatory integer part (int) and optional fractional
// (frac) and exponential (exp) parts
number = {int}{frac}?{exp}?
// Positive or negative number starting with zero or any digit (1-9) followed by
// positive digits
int = -?({digit}|{digit1_9}{digit}+)
digit = [0-9]
digit1_9 = [1-9]
// Fractional part must start with a "." (dot) followed by one or more
// positive digits
frac = {dot}{digit}+
dot = "."
// Exponential part starts with either "e" or "E" signifying Euler's number and
// Power of ten respectively and be follow by optional + or - and one or more
// digit, where unsigned digit means positive
exp = [eE][+-]?{digit}+

%%

// Defining punctuation
"," { return sf.newSymbol("Comma",sym.COMMA); }
"{" { return sf.newSymbol("LCURLY", sym.LCURLY);}
"}" { return sf.newSymbol("RCURLY", sym.RCURLY);}
":" { return sf.newSymbol("COLON", sym.COLON);}
"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }

// Returning tokens to Parser.cup file
{String} {return sf.newSymbol("String",sym.STRING, new String(yytext()));}
{number} {return sf.newSymbol("Number",sym.NUMBER, new Double(yytext()));}
"true" {return sf.newSymbol("Boolean true",sym.TRUE, new Boolean(yytext()));}
"false" {return sf.newSymbol("Boolean false",sym.FALSE, new Boolean(yytext()));}
"null" {return sf.newSymbol("Null",sym.NULL);}

[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); }
