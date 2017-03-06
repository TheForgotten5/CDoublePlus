/*
HNode.cpp

Class description: A file that contains pointers for chain-linked hash table
Class invariant: The data must be in string format

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>
#include "HNode.h"

hashNode::hashNode() {
	key = "";
	translation = "";
	next = NULL;
}

hashNode::hashNode(string Key, string Translation) {
	key = Key;
	translation = Translation;
	next = NULL;
}
