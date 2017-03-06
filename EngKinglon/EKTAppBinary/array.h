/*
array.h

Class description: Stores the user's input into an array.
Class invariant: none.

Date: July 5th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
using namespace std;

template <class Type>
class array {

private:
int elementCount;
int arrayCap;
Type* list;

public:

//Default constructor
array();

//Destructor
~array();

//Description: Gets the number of nodes in the tree
int getElementCount() const;

//Description: Prints in first to last order
//Post-Condition: Returns Information inserted from first to last
//Time complexity: O(N)
void printOrder();

//Description: Inserts an element to the latest index
//Time complexity: O(1)
void insert(Type& data);

//Description: Removes an element on the latest index
//Time complexity: O(1)
void remove();

//Description: retrieves the first element
Type* peek();

//Description: Searches the target in the tree, returning it upon finding.
//Time complexity: O(N)
Type* retrieve(Type& target);

};


//Implementations

template <class Type>
array<Type>::array() {
	elementCount = 0;
	arrayCap = 10;
	list = new Type[arrayCap];
}

template <class Type>
array<Type>::~array() {
	elementCount = 0;
}

template <class Type>
int array<Type>::getElementCount() const {
	return elementCount;
}

template <class Type>
void array<Type>::printOrder() {
	for (int i=0; i<elementCount; i++) cout << list[i] << endl;
}

template <class Type>
void array<Type>::insert(Type& data) {
	if (elementCount < arrayCap) {
		list[elementCount++] = data;
		return;
	}
	//Deep copy the array
	arrayCap *= 2;
	Type * newArray = new Type[arrayCap];
	for (int i=0; i<elementCount; i++)
		newArray[i] = list[i];
	//Insert new element, delete old array
	newArray[elementCount++] = data;
	delete [] list;
	list = newArray;
}

template <class Type>
void array<Type>::remove() {
	elementCount--;
}

template <class Type>
Type* array<Type>::peek() {
	return list[0];
}

template <class Type>
Type* array<Type>::retrieve(Type& target) {
	for (int i=0; i<elementCount; i++) {
		if (list[i] == target) return target;
	}
	return NULL;
}
