Maiara Lange
Trabalho 01 - Tradutores

Usei C++ para facilitar o tratamento de strings.
Junto com o trabalho, estou enviando os arquivos .lex, os compilados e os execut�veis, assim como os arquivos que eu usei para teste (Text.txt, Java.java e Email.java) e os respectivos resultados que consegui (jstats.txt e stats.txt).

A sintaxe que eu usei para compilar e gerar o execut�vel � a seguinte: 
1. Text Lexical Analyzer:
flex -o TextLexicalAnalyzer.cpp TextLexicalAnalyzer.lex && g++ -std=c++11 -o TextLexicalAnalyzer TextLexicalAnalyzer.cpp && ./TextLexicalAnalyzer <filename>
2. Java Lexical Analyzer:
flex -o JavaLexicalAnalyzer.cpp JavaLexicalAnalyzer.lex && g++ -std=c++11 -o JavaLexicalAnalyzer JavaLexicalAnalyzer.cpp && ./JavaLexicalAnalyzer <filename>

Somente algumas considera��es sobre o trabalho:
1. Text Lexical Analyzer:
  Foi considerado frases que terminam com ponto, dois pontos, v�rios pontos (retic�ncias), interroga��o ou exclama��o.
  N�o considerei n�meros como palavras.

2. Java Lexical Analyzer:
  Eu considerei "linhas de c�digo" como todas as linhas do programa, incluindo coment�rios e demais coisas.
  As "linhas de coment�rio" contam as linhas do bloco de coment�rio, tamb�m.
  As "strings literais" podem estar em mais de uma linha.
  Separei por "classes", "interfaces" (pois n�o se encaixam na mesma defini��o), n�mero de construtores e "m�todos".
  N�o considerei a visibilidade (somente para a REGEX do construtor).
  Como foi mostrado no exemplo, eu coloquei o "extends <class>" como parte do nome da classe.
  Como n�o foi definido na descri��o, eu resolvi mostrar s� o nome de todas as coisas, sem par�metros, retornos ou visibilidade.