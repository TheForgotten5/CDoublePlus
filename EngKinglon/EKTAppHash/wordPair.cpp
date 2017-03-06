/*
wordPair.cpp

Class description: Seperates a string by into two words from a ':' character.
Class invariant: All data must be a string/char.

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>
#include "wordPair.h"

using namespace std;

wordPair::wordPair() {
	word = "";
	translation = "";
}

wordPair::wordPair(string pairOfWords) {
	word = "";
	translation = "";
	bool endOfFirst = false;
	for (unsigned int i=0; i<pairOfWords.length(); i++) {
		if (pairOfWords[i] == ':') endOfFirst = true;
		else if (!endOfFirst) word += pairOfWords[i];
		else translation += pairOfWords[i];
	}
}

string wordPair::getWord() const {
	return word;
}

string wordPair::getTranslation() const {
	return translation;
}

string wordPair::getPair() const {
	if (word=="" && translation=="") return "";
	else if (word!="" && translation=="") return word;
	else if (word=="" && translation!="") return translation;
	else return word + ':' + translation;
}

void wordPair::setWord(string newWord) {
	word = newWord;
}

void wordPair::setTranslation(string newTranslation) {
	translation = newTranslation;
}

void wordPair::setPair(string newPair) {
	word = "";
	translation = "";
	bool endOfFirst = false;
	for (unsigned int i=0; i<newPair.length(); i++) {
		if (newPair[i] == ':') endOfFirst = true;
		else if (!endOfFirst) word += newPair[i];
		else translation += newPair[i];
	}
}

ostream & operator<<(ostream & os, wordPair& W) {
	os << W.getPair();
	return os;
}

bool wordPair::operator<(wordPair& W) {
	return (this->getPair() < W.getPair());
}

bool wordPair::operator>(wordPair& W) {
	return (this->getPair() > W.getPair());
}

bool wordPair::operator==(wordPair& W) {
	return (word == W.getWord());
}
