/*
binaryTree.h

Class description: Stores data into a binary tree.
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include "treeNode.h"

using namespace std;

template <class Type>
class binaryTree {

private:
int elementCount;
treeNode<Type>* root;

public:

//Default constructor
binaryTree();

//Destructor
~binaryTree();

//Description: Gets the number of nodes in the tree
int getElementCount() const;

//Description: Inserts an element into the tree, maintaining the structure
//Time complexity: O(log N)
void insert(Type data, treeNode<Type>* root);

//Description: Searches the target in the tree, returning it upon finding.
//Time complexity: O(log N)
treeNode<Type>* retrieve(Type target, treeNode<Type>* root);

//Description: Traverses the tree from left, to middle, then right.
//Pre-Condition: Tree is non-empty.
//Post-Condition: Returns the information in order
//Time complexity: O(N)
void printSortedOrder(treeNode<Type>* root);

//friend ostream & operator<<(ostream & os, binaryTree<Type>& rhs, treeNode<Type>* root);

};


//Implementations

template <class Type>
binaryTree<Type>::binaryTree() {
	elementCount = 0;
	root = NULL;
}

template <class Type>
binaryTree<Type>::~binaryTree() {
	elementCount = 0;
	destroy(root);
}

template <class Type>
void destroy(treeNode<Type>* root) {
	//base case
	if (root == NULL) return;
	//Check all nodes, delete them upon finding
	if (root->leftChild) destroy(root->leftChild);
	if (root->rightChild) destroy(root->rightChild);
	delete root;
}

template <class Type>
int binaryTree<Type>::getElementCount() const {
	return elementCount;
}

template <class Type>
void binaryTree<Type>::insert(Type data, treeNode<Type>* root) {
	//Base case for empty tree
	if (root == NULL) {
		root = new treeNode<Type>(data);
		elementCount++;
		return;
	} else if (data < root->data) { //Check if letter is less than root
		//Check if the left isn't NULL so that it traverses
		if (root->leftChild != NULL) {
			insert(data, root->leftChild);
		} else {
			root->leftChild = new treeNode<Type>(data);
			elementCount++;
		}
	} else { //Check if letter is greater than root
		//Check if the right isn't NULL so that it traverses
		if (root->rightChild != NULL) {
			insert(data, root->rightChild);
		} else {
			root->rightChild = new treeNode<Type>(data);
			elementCount++;
		}
	}
	return;
}

template <class Type>
treeNode<Type>* binaryTree<Type>::retrieve(Type target, treeNode<Type>* root) {
	//Check for empty tree
	if (root == NULL) {
		return NULL;
	} else if (root->data == target) {
		return root;
	//Traverse left
	} else if (target < root->data) {
		return retrieve(target, root->leftChild);
	} else { //Traverse right
		return retrieve(target, root->rightChild);
	}
}

template <class Type>
void binaryTree<Type>::printSortedOrder(treeNode<Type>* root) {
	if (root == NULL) return;
	printSortedOrder(root->leftChild);
	cout << root->data << endl;
	printSortedOrder(root->rightChild);
}

/*template <class Type>
ostream & operator<<(ostream & os, binaryTree<Type>& rhs, treeNode<Type>* root) {
	//Traverse left, the middle, then right
	if (root == NULL) return;
	return (os,binaryTree,root->leftChild);
	os << root->data << endl;
	return (os,binaryTree,root->rightChild);
}*/
