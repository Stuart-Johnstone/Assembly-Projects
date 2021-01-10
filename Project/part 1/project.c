//CPSC 355 Project
//Stuart Johnstone
//this program is a bomberman style game



#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>

/*
This function checks the commanline inputs 
returns: false if the inputs pass and true if they fail
*/
bool falseInputs(int argc, char **argv)
{
    //checks to see if the user gave enough inputs
    if(argc != 4){
        printf("Please input a name and two integers greater then 10");
        return(true);              //returns true if there aren't enough inputs
    }
    //checks to see if the inputs are smaller then 10
    if(atoi(argv[2]) < 10 || atoi(argv[3]) < 10){
        printf("Please input a name and two integers greater then 10");
        return(true);             //returns true if the inputs are too small
    }
    //the inputs are ok, it returns false to skip the test
    return(false);
}






/*
Function: randomNum , generates a random number between a min and max bound
Inputs: int min, the minimum bound for the random number
        int max, the maximum bound for the random number
        bool neg, if this is true then it will  output a negative numb, else it wont
Output: a random integer between the minimum and maximum bound

*/
float randomNum(int min, int max, bool neg)
{   
    //if the input neg is true then it generates a negative number
    if(neg){
        //calculates a random negative number between min and max
        return ((min + 1) + (((float) rand()) / (float) RAND_MAX) * (max - (min + 1))) * -1; 
    }else{
        //calculates a random positive number between min and max
        return ((min + 1) + (((float) rand()) / (float) RAND_MAX) * (max - (min + 1)));  //calculates a random number with a variable max
    }
}




/*
initializes the gameboard, takes the nXm dimension of both the visable and non-visable boards
populates the non-visable with X 
populates the visable with floats between -15 and 15, max 20%negative
*/
void initialize(int x, int y, char* vBoard[x][y], float nBoard[x][y]){
    
    //variables
    int i;                  //index variable
    int j;                  //index variable
    float total = 0;        //tracks the total number of numbers
    float negative = 0;     //tracks the number of negative numbers
    float special = 1;      //tracks the number of special numbers

    //makes sure that an instance of the game over character exists
    int gameOverIndexX = randomNum(0,x-1,false);    //creates the x value for the gameover character 
    int gameOverIndexY = randomNum(0,y-1,false);    //creates the y value for the gameover character

    //holds a random number for the special characters
    float tempRandom;


    //creates the visable board
    for(i = 0; i < x; i++){             //loops through the n dimension of the board
        for(j = 0; j < y; j++){         //loops through the m dimension of the board
            vBoard[i][j] = "X";         //sets the value of nBoard[i][j] to X
        }
    }

    //creates the non-visable float board
    for(i = 0; i < x; i++){             //loops through the n dimension of the board
        for(j = 0; j < y; j++){         //loops through the m dimension of the board
            if(i == gameOverIndexX && j == gameOverIndexY){
                nBoard[i][j] = 21;      //20 is the special number for the gameover character
                total += 1;             //increments the total by one
            //if the random number is less then 4 and the is more room for a negative number then it will print a negative number
            }else if(randomNum(0,15,false) < 8 && negative/total < 0.4){
                nBoard[i][j] = randomNum(0,15,true);    //makes the instance at nBoard[i][j] a negative float 
                total += 1;     //increments the total by one
                negative += 1;  //increments the ammount of negative numbers by one
                
            }else if(randomNum(0,15,false) < 4 && special/total < 0.2){
                //generates a random number betwee 0 and 15
                tempRandom = randomNum(0,15,false);

                //evenly distrobutes the special characters
                if(tempRandom < 5){
                    nBoard[i][j] = 22;  //22 is the codes for the add bombs character 
                }else if(tempRandom < 10){
                    nBoard[i][j] = 23;  //23 is the codes for the add lives 
                }else{
                    nBoard[i][j] = 25;  //25 is the codes for the double blast radius character 
                }

                total += 1;         //increments the total by one
                special += 1;      //increments the ammount of special characters by one
                
            }else{
                nBoard[i][j] = randomNum(0,15,false);   //makes the instance at nBoard[i][j] a positive float
                total += 1;     //increments the total by one
            }
            
        }
    }
    //displays the persentage of the board that is negative
    printf("Persentage of negative Numbers is: %f % \n", negative * 100 / total);
}




/*
Displays the visable boards and the game variables
*/
void displayGame(int x, int y, char* vBoard[x][y],float nBoard[x][y],int playerValues[2],float score){
    //variables for looping
    int i;
    int j;
    
    for(i = 0; i < x; i++){                 //checks the outer list of the board
        for(j = 0; j < y; j++){             //checks the inner list of the board
            printf(" %s ", vBoard[i][j]);     //prints the item at the index vBoard[i][j]
        }
        printf("\n");                       //prints a newline after a row is done
    }
    //prints some information to the user
    printf("Lives: %d \nBombs: %d \nScore:%5.2f \n",playerValues[0],playerValues[1],score);
}



/*
This function gets valid user input for cordinates, the numbers must be between 0 and n or m
used before the bomb function
*/
void getCords(int x, int y, int cords[2]){
    //sets the values so that it will trigger the while loop
    cords[0] = x;
    cords[1] = y ;
    //loops until the two cords dont satisfy the bounds 
    while((cords[0] >= x || cords[0] < -1) || (cords[1] >= y || cords[1] < -1)){
        //prints ui to the user
        printf("Type -1 -1  to Quit\n");
        printf("What are the cordinates you want to bomb (x y)? ");
        //saves the value of the x into cords[0] and the value of y inot cords[1]
        scanf("%d %d", &cords[1], &cords[0]);      
    }
}



/*
Checks a cordinate to see if it is within bounds of an array
int x, the initial cordinate
int e, the bomb Randius being used
int l, the length of the array
*/
bool checkCords(int x, int e, int l){
    //checks to see if x + e is within the bounds of l
    if(x + e >= 0 && x + e - (l - 1) <= 0){
        return true;        //if it is then it returns true
    }else{
        return false;       //if it isnt then it reutrns false
    }
}



/*
Checks each item in the bomb radius to see if they exist within the bounds, 
if it is then depending on the score it will change the matching item in the visible board
it will then add the score value from the non-visable board to the score

*/
float bomb(int x, int y, char* vBoard[x][y], float nBoard[x][y], int cords[2],int playerValues[4])
{   
    //randomizes the seed based on the time
    srand(time(NULL)); 

    //temp score is used to keep track of the score this round
    float tempScore = 0;

    //saves the blast radius
    int radius = playerValues[2];

    //resets the blast radius to the default of 1
    if(playerValues[2] == 2){
      playerValues[2] = 1;      
    }


    // -radius <= (i,j) <= radius       this allows it to dinamically search through all of the relevent indexes
    for(int i = -radius; i <= radius; i++){             //loops through one collum at a time

        for(int j = -radius; j <= radius; j++){         //loops through one row at a time

            //checks to see if the indexes actually exist on the board
            if(checkCords(cords[0],i,x) && checkCords(cords[1],j,y)){\
                if(vBoard[cords[0]+i][cords[1]+j] == "X"){
                    //special characters
                    if(nBoard[cords[0]+i][cords[1]+j] == (float)21){     //checks the code for the exit variable
                        vBoard[cords[0]+i][cords[1]+j] = "*";       //sets the character for the end game
                        playerValues[3] = 0;                        //sets the game over variable to 0

                    }else if(nBoard[cords[0]+i][cords[1]+j] == (float)25){   //checks the code for the double range variable
                        vBoard[cords[0]+i][cords[1]+j] = "$";       //sets the character for the double bomb 
                        playerValues[2] = playerValues[2]*2;        //doubles the range of the bomb

                    }else if(nBoard[cords[0]+i][cords[1]+j] == (float)23){   //checks the code for the double range variable
                        vBoard[cords[0]+i][cords[1]+j] = "^";       //sets the character for the double bomb 
                        playerValues[1] = playerValues[1]+10;        //doubles the range of the bomb

                    }else if(nBoard[cords[0]+i][cords[1]+j] == (float)22){   //checks the code for the add lives variable
                        vBoard[cords[0]+i][cords[1]+j] = "@";       //sets the character for add lives
                        playerValues[0] = playerValues[0]+3;        //gives the player 3 more lives
                    
                    //normal characters
                    }else if(nBoard[cords[0]+i][cords[1]+j] > (float)0){
                        //if the value is positive then it sets the equivelent postion in the visable board to a +
                        vBoard[cords[0]+i][cords[1]+j] = "+";    
                        //adds the value of each tile to the score      
                        tempScore += nBoard[cords[0]+i][cords[1]+j];     

                    }else if(nBoard[cords[0]+i][cords[1]+j] < (float)0){
                        //if the value is negative then it sets the equivelent position in the visable board to a +
                        vBoard[cords[0]+i][cords[1]+j] = "-";    
                        //adds the value of each tile to the score      
                        tempScore += nBoard[cords[0]+i][cords[1]+j];     
                    }
                               
                }
            }
        }
        
    }

    //prints the score for that round
    printf("the score for this bomb was: %3.2f \n", tempScore);

    //if the round score was negative then the player would loose a life
    if(tempScore < 0) playerValues[0] = playerValues[0] - 1;    //decrements the life if the score is negative
    if(playerValues[0] == 0) playerValues[3] = 0;               //sets the game over variable

    //reduces the bomb count
    playerValues[1] -= 1;
    //if the player is out of bombs it sets the game over variable
    if(playerValues[1] == 0) playerValues[3] = 0;

    //returns the value of the score of that round
    return tempScore;
}


/*
Asks the user if they want to display the previous score
If they say yes then it will open the log file and read its contents
*/
void displayScore(){
    //variable for storing the user choice
    char choice[25];
    int num = 0;
    //prints the question then scans the console, the value is stored in choice
    printf("\nDo you want to see the previous scores? (y/n) ");
    scanf("%s",choice);

    //if the user said yes then it will continue, else the function ends
    if(choice[0] == 'y'){
        //opends the log file in read mode
        FILE *fPtr;
        fPtr = fopen("project.log", "r+");

        //gets a positive number of scores to see
        while(num <= 0){
            printf("How many scores do you want to see (>0)? ");
            scanf("%d",&num);
        }

        

        //variables for storing the data from the file
        char tempScore[25];
        char tempName[25];
        char tempRounds[25];
        
        //checks if there  is data to read
        while(fgets(tempScore, 25, fPtr) && num > 0) {
            //reads the last two bits of data
            fgets(tempName, 25, fPtr);
            fgets(tempRounds, 25, fPtr);
            //prints the name and other data
            printf("Name: %s Score: %s Rounds: %s",tempName,tempScore,tempRounds);
            num -= 1;
        }
        //closes the file
        fclose(fPtr);
    }
}



/*
Logs the data from the game, inputs name length, name , score and rounds
Updates the log file with the new data, it keeps it in order from greatest to least for easy printing
stores the data like:
score
name
rounds
*/
void logInfo(int x, char name[25],float score, int rounds){
    //file pointers 
    FILE *fPtrOld;
    FILE *fPtrNew;

    //opens the old log file if it is there, makes a new file
    fPtrOld = fopen("project.log", "r+");        //opens the file or makes one if there isn't a log file present
    fPtrNew = fopen("projectNew.log", "w+");     //makes a new log file
    
    //temporary variables
    //used to move items from one file to the new file
    char tempScore[25];
    char tempName[25];
    char tempRounds[25];

    //place keeps track of wether the current game has been loged yet
    bool place = false;
    

    //while there are still items left in the list it will compare them
    while(fgets(tempScore, 25, fPtrOld)) {
        //reads the last two bits of data
        fgets(tempName, 25, fPtrOld);
        fgets(tempRounds, 25, fPtrOld);

        //checks to see if the old score is less then the new score, this will only be done once
        if(atof(tempScore) < score && place == false){

            //writes the current game score before the old score
            fprintf(fPtrNew,"%5.2f\n%s\n%i\n",score,name,rounds);
            fprintf(fPtrNew,"%s%s%s",tempScore,tempName,tempRounds);

            //sets the variable telling the program that it placed the recent game to true
            place = true;

        }else{
            //if the tempScore is bigger then it writes the line to the file
            fprintf(fPtrNew,"%s%s%s",tempScore,tempName,tempRounds);
        }
    }

    //if the current game wasn't logged before then it logs it last
    //this will happen if it is the smallest or the file is empty
    if(place == false){
        fprintf(fPtrNew,"%5.2f\n%s\n%i\n",score,name,rounds);
    }

    //fprintf(fPtr,"%f\n%s\n%d",score,name,rounds);
    fclose(fPtrOld);
    fclose(fPtrNew);
    //removes the old log
    remove("project.log");
    //renames the new log
    rename("projectNew.log", "project.log"); 
}


int main(int argc, char** argv)
{      
    srand(time(NULL)); 
    //validates the inputs
    if(falseInputs(argc,argv)){     //returns false if the arguements are correct
        return(0);                  //stops the program if checkInputs returns true
    }

    //sets all of the inputs as variables
    char* name = argv[1];       //name of the user
    int x = atoi(argv[2]);      //x dimenstion of the grid
    int y = atoi(argv[3]);      //y dimension of the grid

    float nBoard[x][y];         //variable for the non visable board
    char* vBoard[x][y];      //variable for the visible board

    //stores the player values to easily pass them around 
    int playerValues[] = {3,(x+y)/4,1,1};     //order is: lives, bombs, Bomb Range, gameOver
    float score = 0.0;                  //score variable
    int rounds = 0;                     //tracker for the ammount of rounds

    //continuous user input variables
    int cords[2];               //the int list used to store the user cordinates, cords[0] = x, cords[1] = y



    //First time Run function
    initialize(x,y,vBoard,nBoard);  //initializes the game board


    //loops through the non-visable board and displays all of its values
    for(int i = 0; i < x; i++){                         //checks the outer list of the board
        for(int j = 0; j < y; j++){                     //checks the inner list of the board
            if(nBoard[i][j] == 25) printf(" $  ");
            else if(nBoard[i][j] == 21) printf(" *  ");
            else if(nBoard[i][j] == 22) printf(" ^  ");
            else if(nBoard[i][j] == 23) printf(" @  ");
            else printf(" %2.f ", nBoard[i][j]);        //prints the item at the index nBoard[i][j]
            
        }
        printf("\n");                       //prints a newline after a row is done
    }


    displayScore();

    //while the game over value is 1
    while(playerValues[3] == 1){
        displayGame(x,y,vBoard,nBoard,playerValues,score);        //displays everything on the board
        getCords(x,y,cords);                                      //gets the cordinates from the user
        
        //if the user input -1 it breaks the while loop and quits out of the program 
        if(cords[0] == -1){
            break;
        }

        //bombs the cordinates and saves the score achieved into score        
        score = score + bomb(x,y,vBoard,nBoard,cords,playerValues);      

        //informs the player about what has happened after the last bomb
        if(playerValues[2] > 1) printf("your Bomb has been powered up! (radius of %d)\n",playerValues[2]);
        //if the player hits the exit tile or runs out of bombs then they win the game
        if(playerValues[3] == 0 || playerValues[1] == 0 ) printf("You Won with a score of: %5.2f", score);
        
        //checks to see if the player has lives left
        if(playerValues[0] == 0) printf("You Lost with a score of: %5.2f",score); 

        //after the round has finished 1 is added to the round tracker
        rounds += 1;

    }
    //logs the current game stats
    logInfo(strlen(name),name,score,rounds);
    displayScore();

    return(0);
}
