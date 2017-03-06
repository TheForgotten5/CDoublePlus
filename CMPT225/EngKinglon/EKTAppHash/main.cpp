/*
Main.cpp

Class description: A test driver program.
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <fstream>
#include <iostream>
#include <sstream>
#include <cstdio>
#include <string>
#include <locale>
#include <cctype>
#include "hashTable.h"
#include "array.h"
#include "wordPair.h"

using namespace std;


//Desscription: Creates a binary tree of words using file io.
void constructFromFileInput(hashTable* table) {
	string words;
	string filename = "test.in";
	//Opens file for input and reading
	ifstream myfile (filename.c_str());
	//Creates hash table
	if (myfile.is_open()) {
		while (getline(myfile,words)) {
			wordPair wordsFromFile(words);
			table->insert(wordsFromFile.getWord(), wordsFromFile.getTranslation());
		}
		myfile.close();
	} else cout << "Unable to open file" << endl;
}

//Description: Checks if the user has specified the display command
bool checkDisplayCommand(int C,char* input, hashTable* table) {
	string inputDisplay = "display";
	//Checks if display is the command to run
	if (C==2 && input==inputDisplay) {
		table->display();
		return true;
	}
	return false;
}

//Description: Checks if the user's words exist within the tree.
void inputAndTranslation(hashTable* table) {
	string words;
	array* translations = new array;
	//Processes the user's input
	while(getline(cin, words)) {
		stringstream ss(words);
		getline(ss, words); //This allows whitespaces by pasting what's in ss into words
		wordPair wordInput(words);

		string theKey = wordInput.getWord();
		//Checks if there is an existing word
		hashNode* wordNode = table->retrieve(theKey);
		if (wordNode == NULL) {
			wordInput.setWord(words);
			wordInput.setTranslation("<not found>");
		} else {
			wordInput.setWord(wordNode->key);
			wordInput.setTranslation(wordNode->translation);
		}

		//Inserts the word and translation into array
		string theWord = wordInput.getWord();
		string theTranslation = wordInput.getTranslation();
		translations->insert(theWord + ':' + theTranslation);
	}
	
	cout << endl;
	//Prints the order of input that the user has entered
	translations->printOrder();

	//Free memory by deleting array
	translations->~array();

	cout << endl;
}



int main (int argc, char* argv[]) {
	//Initialize the hash table
	hashTable* hash = new hashTable;

	constructFromFileInput(hash);
	//Check if "display" is in the command line argument
	if (checkDisplayCommand(argc,argv[1],hash)) return 0;
	inputAndTranslation(hash);

	//Debug statement

	//cout << "Program ran successfully" << endl;
}
