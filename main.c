#include "main.h"
#include "led.h"

int gu;
int gi0 = 0;
int gi = 0xff;
static int gsi = 0x5;
static int gsu;
const int gci = 0x05;
const int gcu;

int add(int a, int b);

int main() {
   int tryAdd;              // stack no section
   static int lsu;          //.bss
   static int lsi = 0x05;   //.data
   const int lci = 0x06;    // stack no section
   const int lcu;           // stack no section
   tryAdd = add(5,6);
   int ledStatus = 0;
   ledStatus = ledOn(tryAdd);
   tryAdd = ledStatus + 5;
   printf("hello world\n");
   return 0;
}

int add(int a, int b)
{
    int c = a + b;
    return c;
}

void NMI_Handler(void)
{

}
