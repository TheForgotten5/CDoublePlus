/*
HNode.h

Class description: A file that contains pointers for chain-linked hash table
Class invariant: The data must be in string format

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>

using namespace std;

class hashNode {

public:
string key;
string translation;

hashNode* next;

//Default constructor
hashNode();

//Constructor
hashNode(string Key, string Translation);
};

