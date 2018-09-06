flex -o JavaLexicalAnalyzer.cpp JavaLexicalAnalyzer.lex && g++ -std=c++11 -o JavaLexicalAnalyzer JavaLexicalAnalyzer.cpp && ./JavaLexicalAnalyzer Java.java
flex -o TextLexicalAnalyzer.cpp TextLexicalAnalyzer.lex && g++ -std=c++11 -o TextLexicalAnalyzer TextLexicalAnalyzer.cpp && ./TextLexicalAnalyzer Text.txt
