%option noyywrap

%{

#include <stdio.h>
#include <vector>
#include <string>

using namespace std;

vector<string> listOfWords;

int words = 0;
int averageWordsPerPhrase = 0;
int lexicalDensity = 0; 

vector<string> explode(const string& s, const char& c)
{
	string buff{""};
	vector<string> v;
	
	for(auto n:s)
	{
		if(n != c) buff+=n; else
		if(n == c && buff != "") { v.push_back(buff); buff = ""; }
	}
	if(buff != "") v.push_back(buff);
	
	return v;
}

%}

%%

[A-Za-z ]*\. {
	string text(yytext);
	auto numOfWords = explode(text, ' ').size();
	words += numOfWords;
	phrases++;
}

%%

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);

    printf("Number of words is %d\n", words); 
	printf("Number of phrases is %d\n", phrases); 

	return 0;
}
