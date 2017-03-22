/*
 * BankSimApp.cpp - Assignment 2
 * 
 * Description: It's a Bank Simulation App
 *
 * Created on: June 15, 2016
 * Author: Jeff Jeong and Rafael Pena
 */

//make bsApp => ./bsApp < simulation.in

#include <iostream>
#include <sstream>
#include <string>
#include <locale>
#include <cctype>
#include "Queue.h"
#include "PQueue.h"

using namespace std;


void processArrivalEvent(P_Queue* PQ, Queue* Q, Event* frontCustomer, bool* tellerAv, int currTime) {
	PQ->dequeue();
	if (Q->getElementCount() == 0 && *tellerAv) {
		unsigned int departTime = currTime + frontCustomer->getLength();
		PQ->enqueue(new Event('D',departTime,0));
		*tellerAv = false;
	} else	Q->enqueue(frontCustomer);
}


void processDepartureEvent(P_Queue* PQ, Queue* Q, Event* frontCustomer, bool* tellerAv, int currTime, float* waitSum) {
	int prevTime = frontCustomer->getTime();
	PQ->dequeue();
	if (Q->getElementCount() != 0) {
		Event* frontOfLine;
		try {
			frontOfLine = Q->peek();
		} catch (EmptyDataCollectionException& exception) {
			cout << exception.what() << endl;
		}

		Q->dequeue();
		int departTime = currTime + frontOfLine->getLength();

		cout << "Previous time is " << prevTime <<". Current time is " << frontOfLine->getTime() << endl;
		
		*waitSum += prevTime - frontOfLine->getTime();
		PQ->enqueue(new Event('D',departTime,0));
	} else *tellerAv = true;
}


int main() {
	int currentTime = 0;
	int totalPeople = 0;
	float sumOfWaitTime = 0;

	bool tellerAvailable = true;
	P_Queue* customers = new P_Queue();
	Queue* bankLine = new Queue();
	cout << "Simulation begins." << endl;

	// Acquire events from another file (possibly from simulation.in)
	string input;
	unsigned int arrivalTime;
	unsigned int transactionTime;
	while(getline(cin, input)) { 
		stringstream ss(input);
		ss >> arrivalTime >> transactionTime; 
		//cout << "Arrival time: " << arrivalTime << " Length of transaction: " << transactionTime << endl;//Debug
		customers->enqueue(new Event('A',arrivalTime,transactionTime));
	}

	//cout << "File successfully read. Element count in PQueue is " << customers->getElementCount() << ". Running event loop.." << endl; //Debug

	//Event loop for arrival/departures
	while (customers->getElementCount() != 0) {
		//Receive the arrival time
		Event* frontCustomer;

		//Catches exception
		try {
			frontCustomer = customers->peek();
		} catch (EmptyDataCollectionException& exception) {
			cout << exception.what() << endl;
		}
		currentTime = frontCustomer->getTime();

		//Process the time, according to the type of event
		if (frontCustomer->getType() == 'A') {
			cout << "Proccessing arrival at time: " << frontCustomer->getTime() << endl;
			totalPeople++;
			processArrivalEvent(customers,bankLine,frontCustomer,&tellerAvailable,currentTime);
		} else {
			cout << "Proccessing departure at time: " << frontCustomer->getTime() << endl;
			processDepartureEvent(customers,bankLine,frontCustomer,&tellerAvailable,currentTime,&sumOfWaitTime);
		}

		//Test exception
		/*if (customers->getElementCount() == 0) {
			frontCustomer = customers->peek();
		}*/
	}
	
	float averageWait = sumOfWaitTime/totalPeople;
	cout << endl << "Simulation ends." << endl;
	cout << "Final Statistics:" << endl;
	cout << "\tTotal number of people processed: " << totalPeople << endl;
	cout << "\tAverage amount of time spent waiting: " << averageWait << endl;
}
