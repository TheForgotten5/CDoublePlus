/*
array.h

Class description: Stores the user's input into an array.
Class invariant: none.

Date: July 26th, 2016
Author: Jeffrey Jeong and Rafael Pena
*/

#include <iostream>
#include <string>
using namespace std;

class array {

private:
int elementCount;
int arrayCap;
string* list;

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
void insert(string data);

//Description: Removes an element on the latest index
//Time complexity: O(1)
void remove();

//Description: retrieves the first element
string* peek();

//Description: Searches the target in the tree, returning it upon finding.
//Time complexity: O(N)
string* retrieve(string target);

};

