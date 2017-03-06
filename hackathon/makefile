all: Genome

Genome: main.o protein.o patient.o
	g++ -o Genome main.o protein.o patient.o

#translator.o: translator.h
#	g++ -c translator.h

#treeNode.o: treeNode.h
#	g++ -c treeNode.h

main.o: main.cpp patient.h protein.h
	g++ -Wall -c main.cpp

protein.o: protein.h protein.cpp
	g++ -Wall -c protein.cpp

patient.o: patient.h patient.cpp
	g++ -Wall -c patient.cpp

clean:
	rm -f Genome *.o
