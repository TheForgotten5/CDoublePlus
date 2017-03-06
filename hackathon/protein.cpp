#include "protein.h"
#include <string>

using namespace std;

//IMPLEMENTATION

//Constructor
protein::protein() {
	pname = "";
	DNAseq = "";
	templateSeq = "";
	codingSeq = "";
	next = NULL;
}

//Getters/setters
string protein::getDNA() {
	return DNAseq;
}

string protein::getName() {
	return pname;
}

string protein::getTemplate() {
	return templateSeq;
}

string protein::getCoding() {
	return codingSeq;
}

void protein::setDNA(string pName) {
	pname = pName;
}

void protein::setName(string DNASeq) {
	DNAseq = DNASeq;
}

void protein::setTemplate(string TemplateSeq) {
	templateSeq = TemplateSeq;
}

void protein::setCoding(string CodingSeq) {
	codingSeq = CodingSeq;
}
