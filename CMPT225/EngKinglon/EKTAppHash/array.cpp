/*
array.h

Class description: Stores the user's input into an array.
Class invariant: none.

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>
#include "array.h"

using namespace std;


array::array() {
	elementCount = 0;
	arrayCap = 10;
	list = new string[arrayCap];
}

array::~array() {
	elementCount = 0;
}

int array::getElementCount() const {
	return elementCount;
}

void array::printOrder() {
	for (int i=0; i<elementCount; i++) cout << list[i] << endl;
}

void array::insert(string data) {
	if (elementCount < arrayCap) {
		list[elementCount++] = data;
		return;
	}
	//Deep copy the array
	arrayCap *= 2;
	string * newArray = new string[arrayCap];
	for (int i=0; i<elementCount; i++)
		newArray[i] = list[i];
	//Insert new element, delete old array
	newArray[elementCount++] = data;
	delete [] list;
	list = newArray;
}

void array::remove() {
	elementCount--;
}

string* array::peek() {
	return &list[0];
}

string* array::retrieve(string target) {
	for (int i=0; i<elementCount; i++) {
		if (list[i] == target) return &list[i];
	}
	return NULL;
}
