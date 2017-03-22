/*
Queue.cpp

Class description: Implementation file of Queue.h
Class invariants: FIFO or LILO

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

//ARRAY-BASED

#pragma once
#include "Event.h"
#include "EmptyDataCollectionException.h"

using namespace std;

class Queue {

private:
	 int elementCount;
	 int front;
	 int back;
	 int arrayCap;
	 Event* bankQueue;

public:
	 //Constructor
	 Queue();
		
	 //Destructor
	 ~Queue();

   // Description: Gets the total number of elements in the Queue.
   // Time Efficiency: O(1)
   int getElementCount() const;
   
   // Description: Adds newElement to the "back" of this queue and 
   //              returns "true" if successful, otherwise "false".
   // Time Efficiency: O(1)
   bool enqueue(Event* newElement);
   
   // Description: Removes the element at the "front" of this queue and 
   //              returns "true" if successful, otherwise "false".
   // Precondition: This queue is not empty.
   // Time Efficiency: O(1)
   bool dequeue();

   // Description: Retrieves (but does not remove) the element at the  
   //              "front" of this queue and returns it.
   // Precondition: This queue is not empty.
   // Postcondition: This queue is unchanged.
   // Exceptions: Throws EmptyDataCollectionException if this queue is empty.
   // Time Efficiency: O(1)
   Event* peek();

   // Description: Retrieves (but does not remove) the element at the  
   //              "front" of this queue and returns it.
   // Precondition: This queue is not empty.
   // Postcondition: This queue is unchanged.
   // Exceptions: Throws EmptyDataCollectionException if this queue is empty.
   // Time Efficiency: O(1)
   Event peek() const throw(EmptyDataCollectionException); 
};
