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
vector<string> constructors;

void lineRule() {
    numberOfLines++;
}

void whiteLineRule() {
    numberOfWhiteLines++;
}

void commentBlockRule() {
	numberOfLines++;
    numberOfCommentLines++;
}

void commentLineRule() {
    numberOfCommentLines++;
}

void literalStringRule() {
    numberOfLiteralStrings++;
}

string getClassNameFromFullString(string className) {
	className.erase(0, 6);
	className.erase(className.size()-2);
	return className;
}

void classRule() {
	string className(yytext);
	classes.push_back(getClassNameFromFullString(className));
}

string getInterfaceNameFromFullString(string interfaceName) {
	interfaceName.erase(0, 10);
	interfaceName.erase(interfaceName.size()-2);
	return interfaceName;
}

void interfaceRule() {
	string interfaceName(yytext);
	interfaces.push_back(getInterfaceNameFromFullString(interfaceName));
}

int findSpaceAfterReturnType(string methodName) {
	return methodName.find(" ")+1;
}

int findFirstParentesis(string methodName) {
	return methodName.find("(");
}

string getMethodNameFromFullString(string methodName) {
	methodName.erase(0, findSpaceAfterReturnType(methodName));
	methodName.erase(findFirstParentesis(methodName));
	return methodName;
}

void methodRule() {
	string methodName(yytext);
	methods.push_back(getMethodNameFromFullString(methodName));
}

void constructorRule() {
	string constructorName(yytext);
	constructors.push_back(constructorName);
}

%}

CAPITAL_LETTER 			[A-Z]
LOWER_LETTER 			[a-z]
LETTERS_AND_DIGITS 		[a-zA-Z0-9 ]*
PASCAL_CASE_AND_DIGITS 	{CAPITAL_LETTER}{LETTERS_AND_DIGITS}
CAMEL_CASE_AND_DIGITS 	{LOWER_LETTER}{LETTERS_AND_DIGITS}
TYPE 					(byte|short|int|long|float|double|boolean|char|{PASCAL_CASE_AND_DIGITS})
RETURN_TYPE 			(void|{TYPE})(\ )+
PARAMETERS				\((({TYPE}\ {CAMEL_CASE_AND_DIGITS})(,(\ )?({TYPE}\ {CAMEL_CASE_AND_DIGITS}))*)?\)
METHOD 					{RETURN_TYPE}{CAMEL_CASE_AND_DIGITS}(\ )?{PARAMETERS}
CONSTRUCTOR				{PASCAL_CASE_AND_DIGITS}(\ )?{PARAMETERS}

%x COMMENT_BLOCK
%x STRING_LITERAL

%%

"//"                            			commentLineRule();
\"		                          			literalStringRule(); BEGIN (STRING_LITERAL);
<STRING_LITERAL>\"							BEGIN (INITIAL);
"/*"                            			BEGIN (COMMENT_BLOCK);
<COMMENT_BLOCK>\n               			commentBlockRule();
<COMMENT_BLOCK>"*/"             			commentLineRule(); BEGIN (INITIAL);
<INITIAL,COMMENT_BLOCK>\n\n					whiteLineRule(); REJECT;
<INITIAL,STRING_LITERAL>\n         			lineRule();
class\ {PASCAL_CASE_AND_DIGITS}"{"			classRule();
interface\ {PASCAL_CASE_AND_DIGITS}"{"		interfaceRule();
{METHOD}									methodRule();
{CONSTRUCTOR}								constructorRule();
<INITIAL,COMMENT_BLOCK,STRING_LITERAL>.		{}

%%

void insertClassesIfNeeded(ofstream& statsFile) {
	statsFile << "Classes:" << endl;
	if (classes.size() > 0) {
		for (auto name: classes) {
			statsFile << "\t" << name << endl;
		}
	} else {
		statsFile << "\tThere are no classes in this file!" << endl;
	}
}

void insertInterfacesIfNeeded(ofstream& statsFile) {
	statsFile << "Interfaces:" << endl;
	if (interfaces.size() > 0) {
		for (auto name: interfaces) {
			statsFile << "\t" << name << endl;
		}
	} else {
		statsFile << "\tThere are no interfaces in this file!" << endl;
	}
}

void insertConstructorsIfNeeded(ofstream& statsFile) {
	statsFile << "Constructors: " << endl;
	if (constructors.size() > 0) {
		statsFile << "\t" << constructors.size() << " constructor(s) in this file!" << endl;
	} else {
		statsFile << "\tThere are no constructors in this file!" << endl;
	}
}

void insertMethodsIfNeeded(ofstream& statsFile) {
	statsFile << "Methods:" << endl;
	if (methods.size() > 0) {
		for (auto name: methods) {
			statsFile << "\t" << name << endl;
		}
	} else {
		statsFile << "\tThere are no methods in this file!" << endl;
	}
}

void insertNamesIntoFile(ofstream& statsFile) {
	insertClassesIfNeeded(statsFile);
	insertInterfacesIfNeeded(statsFile);
	insertConstructorsIfNeeded(statsFile);
	insertMethodsIfNeeded(statsFile);
}

int getNumberOfAllLines() {
	// We need to sum 1 because of EOF.
	return numberOfLines + 1;
}

void createAndPopulateStatsFile(char *filename) {
	ofstream statsFile;
	statsFile.open("jstats.txt");
    statsFile << "jstats " << filename << endl << endl;
    statsFile << "Number of lines:\t\t\t\t " << getNumberOfAllLines() << endl; 
	statsFile << "Number of comment lines:\t " << numberOfCommentLines << endl;
	statsFile << "Number of white lines:\t\t " << numberOfWhiteLines << endl;
	statsFile << "Number of literal strings:\t " << numberOfLiteralStrings << endl << endl;
	insertNamesIntoFile(statsFile);
	statsFile.close();
}

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	createAndPopulateStatsFile(argv[1]);
	return 0;
}
