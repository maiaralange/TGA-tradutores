%option noyywrap

%{

#include <stdio.h>
#include <vector>
#include <string>

using namespace std;

int words = 0;
int phrases = 0;

%}

%%

[a-zA-Z]+\. { phrases++; REJECT; }
[a-zA-Z]* {	words++; }
. {}

%%

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);

    printf("Number of words is %d.\n", words); 
	printf("Number of phrases is %d.\n", phrases); 

	return 0;
}
