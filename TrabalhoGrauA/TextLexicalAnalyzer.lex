%option noyywrap

%{

#include <stdio.h>
#include <fstream>
#include <string>
#include <set>

using namespace std;

float numberOfWords = 0;
float numberOfPhrases = 0;
set<string> differentWords;

void increasePhrasesCounter() {
	numberOfPhrases++;
}

void endOfPhraseRule() {
	increasePhrasesCounter();
}

void increaseWordsCounter() {
	numberOfWords++;
}

void addWordToSetOfDifferentWords() {
	string newWord(yytext);
	differentWords.insert(newWord);
}

void wordsRule () {
	increaseWordsCounter();
	addWordToSetOfDifferentWords();
}

%}

%%

[a-zA-Z]+(\.|\?|\!|\:) 	endOfPhraseRule(); REJECT;
[a-zA-Z]* 				wordsRule();
\n						{}
. 						{}

%%

int getNumberOfDifferentWords() {
	return differentWords.size();
}

float getAverageNumberOfWordsPerPhrase() {
	return numberOfWords / numberOfPhrases;
}

float getLexicalDensity() {
	float numberOfDifferentWords = differentWords.size();
	float lexicalDensity = numberOfDifferentWords / numberOfWords;
	return lexicalDensity * 100;
}

void createAndPopulateStatsFile() {
	ofstream statsFile;
	statsFile.open("stats.txt");
	statsFile << "Number of words:\t\t\t\t\t\t\t " << numberOfWords << endl;
	statsFile << "Number of phrases:\t\t\t\t\t\t\t " << numberOfPhrases << endl;
	statsFile << "Number of different words:\t\t\t\t\t " << getNumberOfDifferentWords() << endl;
	statsFile << "Average number of words per phrases:\t\t " << getAverageNumberOfWordsPerPhrase() << endl;
	statsFile << "Lexical density of the text:\t\t\t\t\t " << getLexicalDensity() << endl;
	statsFile.close();
}

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	createAndPopulateStatsFile();
	return 0;
}
