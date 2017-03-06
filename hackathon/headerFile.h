/*Protein class
Made by: Jeff Jeong
*/

#include <iostream>

class protein {
private:
string pname;
string DNAseq;
string templateSeq;
string codingSeq;

public:
//Constructor
protein();

string relatedProtein;

//Getters/setters
string getDNA();
string getName();
void setTemplate();
void setCoding();

//Methods
void addProtein();
};
