Maiara Lange
Trabalho 01 - Tradutores

Usei C++ para facilitar o tratamento de strings.
Junto com o trabalho, estou enviando os arquivos .lex, os compilados e os executáveis, assim como os arquivos que eu usei para teste (Text.txt, Java.java e Email.java) e os respectivos resultados que consegui (jstats.txt e stats.txt).

A sintaxe que eu usei para compilar e gerar o executável é a seguinte: 
1. Text Lexical Analyzer:
flex -o TextLexicalAnalyzer.cpp TextLexicalAnalyzer.lex && g++ -std=c++11 -o TextLexicalAnalyzer TextLexicalAnalyzer.cpp && ./TextLexicalAnalyzer <filename>
2. Java Lexical Analyzer:
flex -o JavaLexicalAnalyzer.cpp JavaLexicalAnalyzer.lex && g++ -std=c++11 -o JavaLexicalAnalyzer JavaLexicalAnalyzer.cpp && ./JavaLexicalAnalyzer <filename>

Somente algumas considerações sobre o trabalho:
1. Text Lexical Analyzer:
  Foi considerado frases que terminam com ponto, dois pontos, vários pontos (reticências), interrogação ou exclamação.
  Não considerei números como palavras.

2. Java Lexical Analyzer:
  Eu considerei "linhas de código" como todas as linhas do programa, incluindo comentários e demais coisas.
  As "linhas de comentário" contam as linhas do bloco de comentário, também.
  As "strings literais" podem estar em mais de uma linha.
  Separei por "classes", "interfaces" (pois não se encaixam na mesma definição), número de construtores e "métodos".
  Não considerei a visibilidade (somente para a REGEX do construtor).
  Como foi mostrado no exemplo, eu coloquei o "extends <class>" como parte do nome da classe.
  Como não foi definido na descrição, eu resolvi mostrar só o nome de todas as coisas, sem parâmetros, retornos ou visibilidade.