/*
binaryTree.h

Class description: Implementation file where the program stores data into a chain-linked hash table.
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include "hashTable.h"

hashTable::hashTable() {
	TABLE_CAPACITY = 26; //Use letters as keys
	table = new hashNode*[TABLE_CAPACITY];

	//Initializes every index to null
	for (int index = 0; index < TABLE_CAPACITY; index++) {
		table[index] = NULL;
	}
}

int hashTable::hashFunction(string key) {
	//Compute the hash index by the first letter for alphabetical order.
	int theKey = key[0];

	return (theKey + 8) % TABLE_CAPACITY; //Adding 8 since ascii ranges from 97 to 123 and we divide by 26
}

int hashTable::getElementCount() {
	return elementCount;
}

bool hashTable::insert(string key, string translation) {
	int hashIndex = hashFunction(key); //Retrieve index for hash table
	hashNode* toBeInserted = new hashNode(key, translation);
	//cout << "Inserting..." << endl;

	//Insert
	if (table[hashIndex] == NULL) { //Unoccupied cell
		//cout << "Inserting at index: " << hashIndex << endl;
		table[hashIndex] = toBeInserted;
		elementCount++;
	} else { //Occupied cell

		while (table[hashIndex] != NULL) {
		//cout << "Travsering through linked list..." << endl;
			table[hashIndex] = table[hashIndex]->next;
		}

		table[hashIndex] = toBeInserted;
		elementCount++;
	}

	return true;
}

hashNode* hashTable::retrieve(string targetKey) {
	//cout << "Searching..." << endl;
	int hashIndex = hashFunction(targetKey);

	//Search the cell
	while (table[hashIndex] != NULL) {
	cout << table[hashIndex]->key << " and " << targetKey << endl; //debug
		//Item found, returns that node
		if (table[hashIndex]->key == targetKey) {
			cout << "Target found!" << endl; //debug
			return table[hashIndex];
		}
		table[hashIndex] = table[hashIndex]->next;
	}

	//Not found, return null
	return NULL;
}

void hashTable::display() {
	for (int index = 0; index < TABLE_CAPACITY; index++) { //The hash index
		for (; table[index] != NULL; table[index] = table[index]->next) { //The linked list in that hash index
			cout << "X" << endl; //Debug
			//cout << table[index]->key << ":" << table[index]->translation << endl;
		}
	}
}
