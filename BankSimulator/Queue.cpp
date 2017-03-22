/*
Queue.cpp

Class description: Implementation file of Queue.h
Class invariants: FIFO or LILO

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

#include <iostream>
#include <string>
#include "Queue.h"
using namespace std;

//Constructor
Queue::Queue() {
	elementCount = 0;
	front = 0;
	back = 0;
	arrayCap = 100;
	bankQueue = new Event[arrayCap]; //Array of size arrayCap
}

//Destructor
Queue::~Queue() {
	elementCount = 0;
}

// Description: Gets the total number of elements in the Queue.
// Time Efficiency: O(1)
int Queue::getElementCount() const {
	return elementCount;
}
   
// Description: Adds newElement to the "back" of this queue and 
//              returns "true" if successful, otherwise "false".
// Time Efficiency: O(1)
bool Queue::enqueue(Event* newElement) {
	//Check if queue is full
	if (elementCount == arrayCap) {
		return false;
	}
	if (back == arrayCap-1) {
		back = 0;
	}

	//Adds to the back of queue
	bankQueue[back] = *newElement;
	elementCount++;
	back++;
	return true;
}
   
// Description: Removes the element at the "front" of this queue and 
//              returns "true" if successful, otherwise "false".
// Precondition: This queue is not empty.
// Time Efficiency: O(1)
bool Queue::dequeue() {

	//Check for empty queue
	if (elementCount == 0) {
		return false;
	}
	//Full queue check
	if (front == arrayCap-1) {
		front = 0;
	}

	//Slide elements back by 1 index
	front++;
	elementCount--;
	return true;

}

// Description: Retrieves (but does not remove) the element at the  
//              "front" of this queue and returns it.
// Precondition: This queue is not empty.
// Postcondition: This queue is unchanged.
// Exceptions: Throws EmptyDataCollectionException if this queue is empty.
// Time Efficiency: O(1)
Event* Queue::peek() {
	if (elementCount == 0) {
		throw EmptyDataCollectionException("Queue is empty!");
	}
	return &bankQueue[front];
}


