#include <iostream>
#include <string>
#include "protein.h"

using namespace std;

class patient {
	private:
	protein* head;
	int proteinCount;

	public:
	patient();
	//Inserts a new element into linked list
	bool insert(string pName, string DNAseq, string templateSeq, string codingSeq);
	//Deletes an element from linked list
	bool removeTargetProtein(string targetProtein);
	//Retrieves a node by its protein name
	protein* retrieveName(string targetName);
	//Retrieves a node by its DNA
	protein* retrieveDNA(string targetDNA);
	//Updates current protein
	void modProtein(protein* current, string pName, string DNASeq, string TemplateSeq, string CodingSeq);

	//Prints out contents
	void print();
};
