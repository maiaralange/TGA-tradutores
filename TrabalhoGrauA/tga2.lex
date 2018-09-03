%option noyywrap

%{

#include <iostream>
#include <stdio.h>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int numberOfLines = 0;
int numberOfWhiteLines = 0;
int numberOfCommentLines = 0;
int numberOfLiteralStrings = 0;
vector<string> classes;
vector<string> interfaces;
vector<string> methods;

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

void classRule() {
	string className(yytext);
	className.erase(0, 6);
	className.erase(className.size()-2);
	classes.push_back(className);
}

void interfaceRule() {
	string interfaceName(yytext);
	interfaceName.erase(0, 10);
	interfaceName.erase(interfaceName.size()-2);
	interfaces.push_back(interfaceName);
}

void methodRule() {
	string methodName(yytext);
	methodName.erase(0, methodName.find(" ")+1);
	methodName.erase(methodName.find("("));
	methods.push_back(methodName);
}

%}

CAPITAL_LETTER [A-Z]
LOWER_LETTER [a-z]
LETTERS_AND_DIGITS [a-zA-Z0-9 ]*
PASCAL_CASE_AND_DIGITS {CAPITAL_LETTER}{LETTERS_AND_DIGITS}
CAMEL_CASE_AND_DIGITS {LOWER_LETTER}{LETTERS_AND_DIGITS}
TYPE (byte|short|int|long|float|double|boolean|char|{PASCAL_CASE_AND_DIGITS})
RETURN_TYPE (void|{TYPE})(\ )?
PARAMETERS \((({TYPE}\ {CAMEL_CASE_AND_DIGITS})(,(\ )?({TYPE}\ {CAMEL_CASE_AND_DIGITS}))*)?\)
METHOD {RETURN_TYPE}{CAMEL_CASE_AND_DIGITS}(\ )?{PARAMETERS}

%x COMMENT_BLOCK

%%

"//"                            			commentLineRule();
\".*\"                          			literalStringRule();
"/*"                            			BEGIN (COMMENT_BLOCK);
<COMMENT_BLOCK>\n               			commentLineRule();
<COMMENT_BLOCK>"*/"             			commentLineRule(); BEGIN (INITIAL);
<INITIAL,COMMENT_BLOCK>\n\n     			whiteLineRule(); REJECT;
\n                              			lineRule();
class\ {PASCAL_CASE_AND_DIGITS}"{"			classRule();
interface\ {PASCAL_CASE_AND_DIGITS}"{"		interfaceRule();
{METHOD}									methodRule();
<INITIAL,COMMENT_BLOCK>.        			{}

%%

void createAndPopulateStatsFile(char *filename) {
	ofstream statsFile;
	statsFile.open("jstats.txt");
    statsFile << "jstat " << filename << endl << endl;
    statsFile << "Number of lines: " << numberOfLines << endl;
	statsFile << "Number of comment lines: " << numberOfCommentLines << endl;
	statsFile << "Number of white lines: " << numberOfWhiteLines << endl;
	statsFile << "Number of literal strings: " << numberOfLiteralStrings << endl;
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

	for(auto word: classes) {
		cout << word << endl;
	}

	for(auto word: interfaces) {
		cout << word << endl;
	}

	for(auto word: methods) {
		cout << word << endl;
	}

	return 0;
}
