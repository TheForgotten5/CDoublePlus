/*
Event.cpp

Class description: Implementation file of Event.h

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

#include "Event.h"
using namespace std;

//Default constructor
Event::Event() {
type = 'A';
time = 0;
length = 0;
}

//Constructor
Event::Event(char Type, int Time, int Length) {
type = Type;
time = Time;
length = Length;
}

//Description: Returns the type of event
char Event::getType() const {
	return type;
}

//Description: Returns the length of transaction
int Event::getLength() const {
	return length;
}

//Description: Returns the time of event
int Event::getTime() const {
	return time;
}

//Description: Sets the type of event
void Event::setType(char newType) {
	type = newType;
}

//Description: Sets the length of transaction
void Event::setLength(unsigned int newLength) {
	length = newLength;
}

//Description: Sets the time of event
void Event::setTime(unsigned int newTime) {
	time = newTime;
}
