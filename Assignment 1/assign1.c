#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>

/*
Function: randomNum , generates a random number between a min and max bound
Inputs: int min, the minimum bound for the random number
        int max, the maximum bound for the random number
Output: a random integer between the minimum and maximum bound

*/
int randomNum(int min, int max)
    {
        int random = (rand() % (max + 1 - min)) - min;
        return random;
    }


/*
Funciton: getIndexNum, gets the Index number from the user and returns it

Input: int m, the m dimension of the list
Output: an integer between 0 and m-1
*/
int getIndexNum(int m)
{
    int numb;
    printf("What is the index that you want to search for? (between 0 and %d) ", m-1);
    scanf("%d", &numb);
    while(numb >= m || numb < 0)
    {
        printf("Input a number between then 0 and %d: ", m-1);
        scanf("%d", &numb);
    }
    return numb;
}



/*
Funciton: getAmmount, gets the ammount of top docs from the user and returns it

Input: int m, the m dimension of the list

Output: an integer between 0 and m-1
*/
int getAmmount(int m)
{
    int numb;
    printf("How many top words would you like to find? (between 1 and %d) ", m);
    scanf("%d", &numb);
    while(numb > m || numb < 1)
    {
        printf("Input a number between 1 and %d: ", m);
        scanf("%d", &numb);
    }
    return numb;
}


/*
Function: initialze, populates a table with random integers

Input:  int n, variable for the y of the table
        int m, variable for the x of the table
        int table[n][m], the list going to be populated

Execution:  traverses through a 2d list and populates it with random numbers  
*/

void initalize(int n, int m ,int table[n][m])
{
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {

            table[i][j] = randomNum(0,9);
        }
    }    
}


/*
Function: initialzeFile, populates a table with integers form a file

Input:  char temp[], file data 
        int n, variable for the y of the table
        int m, variable for the x of the table
        int table[n][m], the list going to be populated

Execution:  traverses through a 2d list and populates it with numbers from a file  
*/

void initalizeFile(char input[], int n, int m ,int table[n][m])
{
    
    int counter = 0;
    char tempInt[1];
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {
            tempInt[0] = input[counter];        //copies the string character
            table[i][j] = atoi(tempInt);        //converts the tempString to an int that is stored in the table
            counter += 1;
        }
    }    
}



/*
Function: initialze, populates a table with random integers

Input:  int n, variable for the y of the table
        int m, variable for the x of the table
        int table[n][m], the list going to be populated

Execution:  traverses through a 2d list and prints its values  
*/
void display(int n, int m ,int table[n][m]) 
{   
    for(int i = 0; i < n; i++)
    {   
        printf("%d: ", i);
        for(int j = 0; j < m; j++)
        {
            printf("%d", table[i][j]);
        }
        printf("\n");
    }    
}





/*
Function:   logInfo, logs the user inputs
Input:      int n, variable for the y of the table
            int m, variable for the x of the table
            int table[n][m], the 2d array of values
Output:     This program outputs a *file without closing the file to be used elsewhere
*/
FILE * logInfo(int m, int n, int table[n][m],int Index, int Ammount){
    FILE *fPtr;                                 
    fPtr = fopen("assign1.log", "w+");          //opens the file or makes one if there isn't a log file present
    for(int i = 0; i < n; i++)                  //loops throught the 2d array and stores its values
    {
        for(int j = 0; j < m; j++)
        {
            fprintf(fPtr,"%d",table[i][j]);     //writes the individual items to the log file
        }
    }
    fprintf(fPtr,"\nIndex: %d", Index);         //writes the chosen index
    fprintf(fPtr,"\nAmmount: %d", Ammount);     //writes the chosen ammount
    return fPtr;
}

/*
Function: topRelevantDocs, gets the pointer of the start of the document spicified in numb

Input:  int n, variable for the y of the table
        int m, variable for the x of the table
        int table[n][m], the 2d array
        int index, the index for the word
Output: pointer to the start of the spicified document
*/
void topRelevantDocs(int n, int m, int table[n][m], int index, int times, FILE *fPtr)
{
    int tempSum;        //used to temporarly store the sum of a row
    float sumList[n];   //list of the total sums of each document


    float freqList[n];  //list of the word frequency of each document
    int tempIndex;      //used to temporarly store the highest index in the frequency list
    


    //gets the sum of all of the rows
    for(int i = 0; i < n; i++)
    {   
        tempSum = 0;
        for(int y = 0; y < m; y++){     //loops through each row and adds up the values
            tempSum += table[i][y];
        }
        sumList[i] = tempSum;           //storest the sum of each row as an item in the list sumList
    }

    //gets the frequency of the word for every document  
    for(int i = 0; i < n; i++)                          //loops through the table and the sumList, and stores the frequencies 
    {
        freqList[i] = table[i][index] / sumList[i];     //frequency is the word ammount divided by the sum of the row
    }

    //prints the top (times) frequencies in order from highest to lowest
    for(int i = 0; i < times; i++){                     //loops for the ammount to times the user wants
        tempIndex = 0;                                  
        for(int x = 0; x < n; x++){                     //loops for the length of the frequency list
            if(freqList[x] > freqList[tempIndex]){      //if the number is greater then the tempIndex then it will save that index as the new tempIndex
                tempIndex = x;
            }
        }
        printf("Top Document #%d: %d\n", i + 1, tempIndex);           //prints the current execution number and the current highest frequency
        fprintf(fPtr,"\n%d: %d", i + 1, tempIndex);
        freqList[tempIndex] = 0.0;                      //sets the current highest frequency to 0 so that is can't be counted
    }
}




int main(int argc, char **argv)
{   
    srand(time(NULL)); 
    if(argc >= 3){
    //variables for the table
    int n = atoi(argv[1]);      //turns an arguement into a int
    int m = atoi(argv[2]);
    int table[n][m];

    //variables for dealing with the file
    bool fileExists = false;
    FILE *fPtr;
    char tempString[n*m];
    
    

    

    if(argc == 4){
        fileExists = true;
    }
    
    //variables for finding the document
    int row[m];
    int *ptr;
    int index;
    int ammount;

    //populates and displays the table
    if(fileExists){
        
        fPtr = fopen(argv[3], "r");                  //opens the file
        fgets(tempString, n*m, fPtr);           //scans the first line of the file
        initalizeFile(tempString,n,m,table);          //populates the table with numbers from the first line of the file
        
        fclose(fPtr);

    }else{
        initalize(n,m,table);                   //populates the array with random numbers
    }
    
    
   

    display(n,m,table);
    
    //gets information from the user
    index = getIndexNum(m);                     //gets the index number from the user
    ammount = getAmmount(m);                    //gets the ammount of top documents from the user
    bool getDocs = true;
    char inputStore[100];
    
    fPtr = logInfo(m,n,table,index,ammount);
    //Logs the user inputs and the 2d array
    while(getDocs){
        
        topRelevantDocs(n,m,table,index,ammount,fPtr);\
        printf("Do you want to get more documents? (yes/no)");
        scanf("%s", &inputStore);
        if(inputStore[0] == 'y'){
            ammount = getAmmount(m); 
        }else{
            getDocs = false;
        }
        
    }

    
    fclose(fPtr);    

    }else{
        printf("you must start the program with two integers between 5 and 20 as input(ie: <program_out>.exe 5 5");
    }

    return(0);
}