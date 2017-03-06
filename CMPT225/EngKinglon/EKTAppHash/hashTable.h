/*
hashTable.h

Class description: Header file where the program stores data into a chain-linked hash table.
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include "HNode.h"

using namespace std;

class hashTable {

private:
int elementCount;
int TABLE_CAPACITY;
hashNode** table;

public:
//Constructor
hashTable();

//Destructor
~hashTable();

//Description: Returns the index by getting the quotient from key and table size
int hashFunction(string key);

//Description: Returns element count
int getElementCount();

//Description: Inserts an element into the hash table by its key
//Time complexity: O(1) (At most log(n))
bool insert(string key, string translation);

//Description: Searches for the element by its key value
//Time complexity: O(1)
hashNode* retrieve(string key);

//Description: Displays all the words in order.
void display();

};
