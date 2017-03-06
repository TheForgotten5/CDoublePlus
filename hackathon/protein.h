/*Protein class
Made by: Jeff Jeong
*/

#include <iostream>
#include <string>

using namespace std;

class protein {
public:
string pname;
string DNAseq;
string templateSeq;
string codingSeq;

protein* next;
//Constructor
protein();

string relatedProtein;

//Getters/setters
string getDNA();
string getName();
string getTemplate();
string getCoding();
void setDNA(string DNASeq);
void setName(string pName);
void setTemplate(string TemplateSeq);
void setCoding(string CodingSeq);
};

