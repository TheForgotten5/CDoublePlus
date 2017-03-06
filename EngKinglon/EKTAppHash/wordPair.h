/*
wordPair.h

Class description: Seperates a string by into two words from a ':' character.
Class invariant: All data must be a string/char.

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>

using namespace std;

class wordPair {
private :
string word;
string translation;

public :
//Default constructor
wordPair();

//Constructor
wordPair(string pair);

//Getters
string getWord() const;
string getTranslation() const;
string getPair() const;

//Setters
void setWord(string newWord);
void setTranslation(string newTranslation);
void setPair(string newPair);

//Print
friend ostream & operator<<(ostream & os, wordPair& W);

//Miscellaneous opertaors
bool operator<(wordPair& W);
bool operator>(wordPair& W);
bool operator==(wordPair& W);
};

