Assignment1
Stuart Johnstone
To run the program, first compile useing gcc, 

then execute using ether ./<program_out>.out # # for linux where # is a number greater then 5 and less than 20
or ./<program_out>.exe # # for windows with the same restriction on #

if occurances.txt is added like: ./a.out 5 5 occurances.txt
then the numbers will be pulled from the text file occurances.txt
this file supports a 5X5 up to a 20X20 matrix

All information from the exection of the program is stored in a file assign1.log
 - This includes the numeber of documents accessed

The way my program selects the order of top documents is by using a few for loops
    - The first compiles a list of all of the sums of the rows
    - The second uses this sumList and the value at the selected index to create a list of fewquencies
    - The thrid is a nested for loop that: for the ammount to documents selected, 
        loops through the list asd saves the index of the greatest freq, 
        it then print that index then sets the index to 0 so it isn't counted again.

My program also has two initialize functions, one for if the program is reading from a file and one to randomly generate numbers

The log file works by using the same file pointer as if the occurances.txt in input, 
    -the function logInfo logs all of the user input up to that point, it reutrns a file pointer that is later used in the topRelevandDocs file
    -to log the input for the tRD when the program prints to the console it also writes to the file, the file is closed at the end of the program.


I could not get the script file to work on my computer or the arm server so i did the steps asked for but i dont know if it rund properly.
