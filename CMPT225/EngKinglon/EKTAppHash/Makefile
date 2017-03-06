all: EKTAppV2

EKTAppV2: main.o hashTable.o HNode.o array.o wordPair.o
	g++ -o EKTAppV2 main.o hashTable.o HNode.o array.o wordPair.o

#translator.o: translator.h
#	g++ -c translator.h

#treeNode.o: treeNode.h
#	g++ -c treeNode.h

main.o: main.cpp hashTable.h HNode.h wordPair.h array.h
	g++ -Wall -c main.cpp

hashTable.o: hashTable.cpp hashTable.h HNode.h
	g++ -Wall -c hashTable.cpp

HNode.o: HNode.cpp HNode.h
	g++ -Wall -c HNode.cpp

array.o: array.cpp array.h
	g++ -Wall -c array.cpp

wordPair.o: wordPair.cpp wordPair.h
	g++ -Wall -c wordPair.cpp

clean:
	rm -f EKTAppV2 *.o
