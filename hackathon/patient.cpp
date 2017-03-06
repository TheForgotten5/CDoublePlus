#include "patient.h"
#include <string>
#include <iostream>

using namespace std;

patient::patient() {
	head = NULL;
	proteinCount = 0;
}

//Inserts a new element into linked list
bool patient::insert(string pName, string DNAseq, string templateSeq, string codingSeq) {
	//New node
	protein* newNode = new protein();
	
	//Check for any changes
	if (pName != "") {
		newNode->setName(pName);
	} 
	if (DNAseq != "") {
		newNode->setDNA(DNAseq);
	}
	if (templateSeq != "") {
		newNode->setTemplate(templateSeq);
	}
	if (codingSeq != "") {
		newNode->setCoding(codingSeq);
	}

	//Empty linked list?
	if (head == NULL) {
		head = newNode;
		proteinCount++;
	} else { //Non-empty linked list. Inserts at end
		protein* current = head;
		while (current->next != NULL) {
			current = current->next;
		}
		current->next = newNode;
		proteinCount++;
	}

	return true;
}

//Deletes an element from linked list
bool patient::removeTargetProtein(string targetProtein) {
	protein* current = head->next;
	protein* previous = head;
	while (current->next != NULL) {
		if (current->pname == targetProtein) {
			previous->next = current->next;
			delete current;
			proteinCount--;
			return true;
		}
	current = current->next;
	}
	return false;
}

//Retrieves a node by the name
protein* patient::retrieveName(string targetName) {
	protein* current = head;
	while (current->next != NULL) {
		if (current->pname == targetName) {
			return current;
		}
		current = current->next;
	}
	return NULL;
}

//Retrieves a node by its DNA seq
protein* patient::retrieveDNA(string targetDNA) {
	protein* current = head;
	while (current->next != NULL) {
		if (current->DNAseq == targetDNA) {
			return current;
		}
		current = current->next;
	}
	return NULL;
}

void patient::modProtein(protein* current, string pName, string DNASeq, string TemplateSeq, string CodingSeq) {
	current->pname += pName;
	current->DNAseq += DNASeq;
	current->templateSeq += TemplateSeq;
	current->codingSeq += CodingSeq;
}

void patient::print() {
	protein* current = head;
	while (current->next != NULL) {
		cout << current->pname;
		cout << " ";
		cout << current->DNAseq;
		cout << " ";
		cout << current->templateSeq;
		cout << " ";
		cout << current->codingSeq;
		cout << endl;
		current = current->next;
	}
}
