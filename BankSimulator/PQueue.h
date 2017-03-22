/*PQueue.h

Class description: Implementation file of PQueue.h, via linked lists
Class Invariant: The elements stored in this Priority Queue are always sorted.

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

#pragma once
#include "Node.h"
#include "EmptyDataCollectionException.h"

using namespace std;

//LINKED LIST BASED
class P_Queue {

private:
	Node* head;
	int P_elementCount; //Keeps track of how many elements are in queue

public:
	 //Constructor
	 P_Queue();
		
	 //Destructor
	 ~P_Queue();

   // Description: Gets the total number of elements in the Priority Queue.
   // Time Efficiency: O(1)
   int getElementCount() const;
  
   // Description: Inserts newElement in sort order.
   //              It returns "true" if successful, otherwise "false".
   // Precondition: This Priority Queue is sorted.   
   // Postcondition: Once newElement is inserted, this Priority Queue remains sorted.           
   bool enqueue(Event* newElement);
   
   // Description: Removes the element with the "highest" priority.
   //              It returns "true" if successful, otherwise "false".
   // Precondition: This Priority Queue is not empty.
   bool dequeue();

   // Description: Retrieves (but does not remove) the element with the "highest" priority.
   // Precondition: This Priority Queue is not empty.
   // Postcondition: This Priority Queue is unchanged.
   // Exceptions: Throws EmptyDataCollectionException if this Priority Queue is empty.
   Event* peek();   

   // Description: Retrieves (but does not remove) the element with the "highest" priority.
   // Precondition: This Priority Queue is not empty.
   // Postcondition: This Priority Queue is unchanged.
   // Exceptions: Throws EmptyDataCollectionException if this Priority Queue is empty.
   Event peek() const throw(EmptyDataCollectionException);  

};
