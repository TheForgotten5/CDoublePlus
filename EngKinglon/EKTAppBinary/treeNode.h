/*
treeNode.h

Class description: A file that contains pointer operations for trees
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>

template <class Type>
class treeNode {

public:
Type data;
treeNode* leftChild;
treeNode* rightChild;

//Default contructor
treeNode();

//Contructors
treeNode(Type Data);

//Copy
void copy(treeNode* original);
};


//Default constructor
template <class Type>
treeNode<Type>::treeNode() {
	leftChild = NULL;
	rightChild = NULL;
}

//Constructor
template <class Type>
treeNode<Type>::treeNode(Type Data) {
	data = Data;
	leftChild = NULL;
	rightChild = NULL;
}

//Copy
template <class Type>
void treeNode<Type>::copy(treeNode* original) {
	data = original->data;
	leftChild = new treeNode<Type>(original->leftChild);
	rightChild = new treeNode<Type>(original->rightChild);
}
