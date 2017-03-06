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
#include "binaryTree.h"
#include "array.h"
#include "wordPair.h"

using namespace std;


template <class Type>
//Desscription: Creates a binary tree of words using file io
void constructFromFileInput(binaryTree<Type>* tree, treeNode<Type>* temp) {
	string words;
	string filename = "test.in";
	//Opens file for input and reading
	ifstream myfile (filename.c_str());
	//Creates binary tree
	if (myfile.is_open()) {
		while (getline(myfile,words)) {
			wordPair wordsFromFile(words);
			tree->insert(wordsFromFile,temp);
		}
		myfile.close();
	} else cout << "Unable to open file" << endl;
}

//Description: Checks if the user has specified the display command
template <class Type>
bool checkDisplayCommand(int C,char* input,binaryTree<Type>* tree,treeNode<Type>* temp) {
	string inputDisplay = "display";
	//Checks if display is the command to run
	if (C==2 && input==inputDisplay) {
		tree->printSortedOrder(temp);
		return true;
	}
	return false;
}

//Description: Checks if the user's words exist within the tree.
template <class Type>
void inputAndTranslation(binaryTree<Type>* tree, treeNode<Type>* temp) {
	string words;
	array<wordPair>* translations = new array<wordPair>;
	//Processes the user's input
	while(getline(cin, words)) {
		stringstream ss(words);
		getline(ss, words); //This allows whitespaces by pasting what's in ss into words
		wordPair wordInput(words);

		//Checks if there is an existing word
		treeNode<wordPair>* wordNode = tree->retrieve(wordInput,temp);
		if (wordNode == NULL) {
			wordInput.setWord(words);
			wordInput.setTranslation("<not found>");
		} else {
			wordInput.setWord(wordNode->data.getWord());
			wordInput.setTranslation(wordNode->data.getTranslation());
		}
		translations->insert(wordInput);
	}
	
	cout << endl;
	//Prints the order of input that the user has entered
	translations->printOrder();

	//Free memory by deleting array
	translations->~array();

	cout << endl;
}



int main (int argc, char* argv[]) {
	//Initialize the tree
	binaryTree<wordPair>* binaryWordTree = new binaryTree<wordPair>;
	treeNode<wordPair>* temp = new treeNode<wordPair>;

	constructFromFileInput(binaryWordTree,temp);
	//Check if "display" is in the command line argument
	if (checkDisplayCommand(argc,argv[1],binaryWordTree,temp)) return 0;
	inputAndTranslation(binaryWordTree,temp);

	//Debug statement
	/*cout << "Insertion complete." << endl;
	//cout << "Root is: " << binaryWordTree->root->data << endl;

	cout << "Calling destructor..." << endl;
	binaryWordTree->~binaryTree(); */

	//Free memory by destroying the tree
	binaryWordTree->~binaryTree(); 

	//cout << "Program ran successfully" << endl;
}
