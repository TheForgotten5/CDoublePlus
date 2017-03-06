#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include "patient.h"

using namespace std;

int main ()
{
	patient* linkedlist = new patient();

	ifstream inputStream;
	ofstream outputStream;

	string fileName = "";

	//Loads a file for reading
	ifstream loadFile("Control.txt", ios::in);

	//Open file and insert elements
	string line;
	string proteinIdentifier;
	string DNASequence;
	string templateStrand;
	string codingStrand;
	while (getline(loadFile, line)) {
		stringstream ss(line);
		ss >> proteinIdentifier;
		ss >> DNASequence;
		ss >> templateStrand;
		ss >> codingStrand;
		linkedlist->insert(proteinIdentifier, DNASequence, templateStrand, codingStrand);
	}

	linkedlist->print();
	return 0;
}
