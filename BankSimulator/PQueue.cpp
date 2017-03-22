/*
PQueue.cpp

Class description: Implementation file of PQueue.h, via linked lists
Class Invariant: The elements stored in this Priority Queue are always sorted.

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

#include <iostream>
#include <string>
#include "PQueue.h"
using namespace std;

//Constructor
P_Queue::P_Queue() {
	head = NULL;
	P_elementCount = 0;
}

//Destructor
P_Queue::~P_Queue() {
	Node* current = head;
	//Remove each node as it traverses
	while (current != NULL) {
		head = head->next;
		delete current;
		current = head;
	}
	head = NULL;
}

// Description: Gets the total number of elements in the Priority Queue.
// Time Efficiency: O(1)
int P_Queue::getElementCount() const {
	return P_elementCount;
}

// Description: Inserts newElement in sort order.
//              It returns "true" if successful, otherwise "false".
// Precondition: This Priority Queue is sorted.   
// Postcondition: Once newElement is inserted, this Priority Queue remains sorted.           
bool P_Queue::enqueue(Event* newElement) {
	//Construct new node
	Node* newNode = new Node(newElement);
	int position = 0;

	//Check for an empty queue
	if (head == NULL || P_elementCount == 0) {
		head = newNode;
		P_elementCount++;
		return true;
	}
	
	Node* current = head;
	Node* previous = head;

	//Find specific index
	while (current != NULL) {
		if (current->data->getTime() > newElement->getTime()) {
			break;
		}
		position += 1;
		current = current->next;
	}
	
	//Check if it has to be inserted at beginning
	if (position == 0) {
		newNode->next = current;
		head = newNode;
		P_elementCount++;
		return true;
	}

	//Insert at specified position
	for (int i = 0; i < P_elementCount; i++) {
		if (i == position-1) {
			newNode->next = previous->next;
			previous->next = newNode;
		}

		//Check if it has to be inserted at the end
		if (previous->next == NULL) {
			previous->next = newNode;
		}

		previous = previous->next;
	}

	P_elementCount++;
	return true;
}

// Description: Removes the element with the "highest" priority.
//              It returns "true" if successful, otherwise "false".
// Precondition: This Priority Queue is not empty.
bool P_Queue::dequeue() {
	if (head == NULL) {
		return false;
	}

	//Save the old head, set new head to the next element, then remove
	Node* current = head;
	head = head->next;
	delete current;

	P_elementCount--;

	return true;
}

// Description: Retrieves (but does not remove) the element with the "highest" priority.
// Precondition: This Priority Queue is not empty.
// Postcondition: This Priority Queue is unchanged.
// Exceptions: Throws EmptyDataCollectionException if this Priority Queue is empty.
Event* P_Queue::peek() {
	if (head == NULL) {
		throw EmptyDataCollectionException("Priority Queue is empty!");
	}
	return head->data;
}
