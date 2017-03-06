all: EKTApp

EKTApp: main.o
	g++ -o EKTApp main.o

#translator.o: translator.h
#	g++ -c translator.h

#treeNode.o: treeNode.h
#	g++ -c treeNode.h

main.o: main.cpp binaryTree.h treeNode.h wordPair.h array.h
	g++ -Wall -c main.cpp

clean:
	rm -f EKTApp *.o
