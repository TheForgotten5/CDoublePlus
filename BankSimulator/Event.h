/*
Event.h

Class description: Header file that contains type, time, length

Author: Jeff Jeong and Rafael Pena
Date: June 15th, 2016
*/

#pragma once
using namespace std;

class Event {

private:
char type;
int time;
int length;

public:
//Default constructor
Event();

//Constructor
Event(char Type, int Time, int Length);

//Description: Returns the type of event
char getType() const;

//Description: Returns the length of transaction
int getLength() const;

//Description: Returns the time of event
int getTime() const;

//Description: Sets the type of event
void setType(char newType);

//Description: Sets the length of transaction
void setLength(unsigned int newLength);

//Description: Sets the time of event
void setTime(unsigned int newTime);

};
