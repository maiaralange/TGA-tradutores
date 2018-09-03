%option noyywrap

%{

#include <iostream>
#include <stdio.h>
#include <fstream>
#include <string>
#include <set>

using namespace std;

int numberOfLines = 0;
int numberOfWhiteLines = 0;
int numberOfCommentLines = 0;
int numberOfLiteralStrings = 0;

void lineRule() {
    numberOfLines++;
}

void whiteLineRule() {
    numberOfWhiteLines++;
}

void commentLineRule() {
    numberOfLines++;
    numberOfCommentLines++;
}

void literalStringRule() {
    numberOfLiteralStrings++;
}

%}

%%

"//" commentLineRule();
\n\n whiteLineRule(); REJECT;
\n lineRule();
\".*\" literalStringRule();
. {}

%%

void createAndPopulateStatsFile() {
	ofstream statsFile;
	statsFile.open("stats.txt");
	statsFile.close();
}

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);

	printf("Number of lines: %d\n", numberOfLines);
	printf("Number of comment lines: %d\n", numberOfCommentLines);
	printf("Number of white lines: %d\n", numberOfWhiteLines);
    printf("Number of literal strings: %d\n", numberOfLiteralStrings);

	return 0;
}
