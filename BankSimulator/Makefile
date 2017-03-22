all: bsApp

bsApp: BankSimApp.o PQueue.o Node.o Queue.o Event.o EmptyDataCollectionException.o
	g++ -o bsApp BankSimApp.o PQueue.o Node.o Queue.o Event.o EmptyDataCollectionException.o

# Note, this makefile is very strong in terms of dependencies.
# It assumes most classes can depend on others, just to be safe.
# This results in much redundant compilation, and one could remove some of these dependencies.

BankSimApp.o: BankSimApp.cpp PQueue.h Node.h Queue.h Event.h EmptyDataCollectionException.h
	g++ -c BankSimApp.cpp

PQueue.o: PQueue.cpp PQueue.h Node.h Event.h EmptyDataCollectionException.h
	g++ -c PQueue.cpp

Node.o: Node.cpp Node.h Event.h
	g++ -c Node.cpp
	
Queue.o: Queue.cpp Queue.h Event.h EmptyDataCollectionException.h
	g++ -c Queue.cpp

Event.o: Event.cpp Event.h
	g++ -c Event.cpp

EmptyDataCollectionException.o: EmptyDataCollectionException.cpp EmptyDataCollectionException.h
	g++ -c EmptyDataCollectionException.cpp

clean:
	rm -f bsApp *.o
