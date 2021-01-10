	
	//Assignment 5
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
			//first temp regester
			//first w temp regester
			//second temporary regester
	
			//third temporary regester
			//third w temporary regester
	
	 			//the regester for storing x19
				//the regester for storing x20
				//the regester for storing the biggest number
				//the regester for storing the min
			//the regester for storing the index of the biggest num
				//the regester for storing the max
			//the regester for storing the size of the document
				//counter for the i dimension of the list
				//counter for the j dimension of the list
				//counter for holding the number of w21 Documents
			//storage regester, used for getting the index on the stack
			//stores x26
				//storing the result of an add on the frame pointer
			//stores the File Pointer 
			//stores x28
				//0th function regester
				//1st function regester
				//2nd funciton regester
				//1st function regester
				//2nd funciton regester



	//Define the format of the string you'll use to output the result
	PrintIndex:	.string "What index would you like to search? (between 0 and %d) "		//the get index string
	PrintAmmount:	.string "How many Top Documents do you want? (between 1 and %d) "		//the get ammount string 
	TopDocsAgain:	.string "Do you want to find more top documents? (1 for yes, 0 for no) "	//input for top doc loop
	TopDocPrint:	.string "Frequency of word %d is: %d\n"				//prints the freq and indexes of top doc
	
	IndexSearched:	.string "Index searched: "
	TopFound:	.string "Top Documents Found: "
	WWord:		.string "Word: "
	WFreq:		.string "Frequency: "		
	

	int:    	.string "%d "							//used for printf calls
	inputInt:	.string "%d"							//used for scanf calls

	nl:		.string "\n"							//newline
	aError:		.string "Need exactly two arguements inbetween 5 and 20\n"	//error handling string
	
	Occurances:	.string "occurances.txt"					//file path to occurances file 
	LogFile:	.string "log.txt"						//file path to log file

	s_s = 16			//start of the temp array
	i_s = 20*4 + s_s 		//start of the stack array
	alloc = -(16*16 + i_s) & -16	//allocates space on the stack
	dealloc = -alloc		//deallocates the space on the stack

 
	.balign 4                               // Instructions must be word aligned
	.global main                            // Make "main" visible to the OS and start the execution

	


	/*********************Begining of MAIN*****************/
main:								//saves system vars
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x28,		x0
	mov	x26,		x1

	//loads arguements
	cmp	x28,		4		//checks to see if there are enough arguements
	b.gt	neError				//if it isn't equal to 4 then it prints an error

	cmp	x28,		3		//checks to see if there are enough arguements
	b.lt	neError				//if it isn't equal to 3 then it prints an error

	ldr	x19,		[x26,8]	//loads the second arguement from x26
	ldr	x20,		[x26,16]	//loads the third arguement from x26

	mov	x0,		x19		//loads x19 into x0 
	bl 	atoi				//converts x0 from string into int
	mov	x19,		x0		//moves x0 into x19
	
	mov	x0,		x20		//loads x20 into x0
	bl 	atoi				//converts x0 from string into int
	mov	x20,		x0		//loads x0 into x20

	//input validation
	cmp 	x19,		5		//compares x19 and 5
	b.lt	neError				//if less than it throws an error
	cmp	x19,		20		//compares x19 and 20
	b.gt	neError				//if less than it throws an error
	cmp 	x20,		5		//compares x20 and 4
	b.lt	neError				//if less than it throws an error
	cmp	x20,		20		//compares x20 and 20
	b.gt	neError				//if less than it throws an error
	

	cmp	x28,		3			//compares 3 to x28
	b.eq	Init					//if it is equal then it jumps to Init

InitFile:
	mov	x0,		x19		        //loads x19 into the x0 regester
	mov	x1,		x20			//loads x20 into the x1 regester 
	add	x2,		x29,		i_s	//loads the stack array pointer into x2
	bl	InitializeFile                              //calls the display function
	b	Disp					//jumps to display

Init:
	mov	x0,		x19		        //loads x19 into the x0 regester
	mov	x1,		x20			//loads x20 into the x1 regester 
	add	x2,		x29,		i_s	//loads the stack array pointer into x2
	bl	Initialize                              //calls the display function


Disp:
	mov	x0,		x19		        //loads x19 into the x0 regester
	mov	x1,		x20			//loads x20 into the x1 regester 
	add	x2,		x29,		i_s	//loads the stack array pointer into x2
	bl	display                                 //calls the display function

Write:
	mov	x0,		x19		        //loads x19 into the x0 regester
	mov	x1,		x20			//loads x20 into the x1 regester 
	add	x2,		x29,		i_s	//loads the stack array pointer into x2
	bl	WriteFile       			//calls the write file function

TopDocs:
	mov	x0,		x19		        //loads x19 into the x0 regester
	mov	x1,		x20			//loads x20 into the x1 regester 
	mov	x2,		x29			//loads the stack pointer into x2
	bl	TopReleventDocs				//calls the display function





	b	MainEnd					//jumps to done

neError:							//print error then quit
	ldr		x0,			=aError			//loads the error message
	bl		printf						//prints the error message
	
MainEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret                               	     				// Return to caller (OS)




/*********************************************************************************************/
/*********************Begining of Functions***************************************************/
/*********************************************************************************************/



/*
Funciton: InitializeFile
	Initializes the table from file occurances.txt
Input:	x0,	x19 dimension of the table
	x1,	x20 dimension of the table
	x2,	x27 for the stack table
 */

InitializeFile:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x19,		x0			//copies x19 from x0
	mov	x20,		x1			//compies x20 from x1
	mov	x27,		x2			//copies the array pointer from x2

	mov	w0,		-100			//1st arg
	ldr	x1,		=Occurances		//file name
	mov	w2,		0			//read only
	mov	w3,		0			//arg4 not used
	mov	x8,		56			//opennat x24/O request
	svc	0
	
	cmp	w0,		0			//error check
	b.gt	ok					//test
	ldr	x0,		=aError			//prints an error message
	bl	printf

ok:
	mov	w28,		w0			//moves w0 into w28
	//Start of the Generating loop 
	mov	x25,		0			//starting value for x25
GenFO:							//the outer loop for generating the numbers
	mov	x24,		0			//resets the value of x24
	
GenFI:		
	//does math to find the index				//the inner loop for reading numbs from file and storing them in array
	mul	x26,		x25,		x19	//x26 = x19 * x25
	add	x26,		x26,		x24	//x26 = (x19*x25) + x24
	lsl	x26,		x26,		2	//x26 = ((x19*x25) + x24)*4

	mov	x0,		0			//zeroing out the memory where the number is going to be stored
	str	x0,		[x27,x26]		//storing the zero in memory
	
	//file read
	mov	w0,		w28			//loads fd into w0
	add	x1,		x27,		x26	//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		63			//read code
	svc	0					//system call

	//adjusts number in
	ldr	x0,		[x27,x26]		//loads the number
	sub	x0,		x0,		48	//subtracts 48 from it
	str	x0,		[x27,x26]		//stores the number
	
	add 	x24,		x24,		1	//increments x24 by 1

	//inner loop test
	cmp	x19,		x24			//compares x24 to x19
	b.gt	GenFI					//if it is greater thean it loops to the inner loop
	add	x25,		x25,		1	//adds one to x25
	
	//the outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	GenFO					//if it is greater then it will loop to the outer loop

	//closes the file
	mov	w0,		w28			//moves w28 into w0
	mov	x8,		57			//close x24/O request
	svc	0					//system call


InitialzeFileEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   





/*
Function: RandomNumb
	Makes a random number between two values
Inputs: 
	x0, the Maximum of the random number
	x1, the minimum of the random number

Output:
	x0, the random number
 */

RandomNumb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	x21,		x0			//moves x0 into x21
	mov	x22,		x1			//moves x1 into min
	bl	rand					//calls rand

	add	x21,		x21,		1	// max + 1
	sub	x21,		x21,		x22	// max + 1 - x20
							// x % y = ( x - ( floor(x/y) ) * y )
	udiv	x9,		x0,		x21	// floor(x/y)
	mul	x9,		x9,		x21	// floor(x/y) * y
	sub	x9,		x0,		x9	// x - ( floor(x/y) ) * y

	sub	x0,		x9,		x22	// (rand() % (max + 1 - min)) - min

	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    




/*
Function: Initialize
	generates the table
inputs:
	x0,	the x19 dimension of the list
	x1,	the x20 dimension of the list
	x2,	the pointer to the stack array
*/
Initialize:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x19,		x0			//copies x19 from x0
	mov	x20,		x1			//compies x20 from x1
	mov	x27,		x2			//copies the array pointer from x2

	//Start of the Generating loop 
	mov	x25,		0	
GenO:							//the outer loop for generating the numbers
	mov	x24,		0			//resets the value of x24
	
GenI:							//the inner loop for generating the numbers
	
	mov	x0,		9			//moves 9 into x0
	mov	x1,		0			//moves 0 into x1
	bl 	RandomNumb				//calls RadomNumb

	
	//does math to find the index
	mul	x26,		x25,		x19	//x26 = x19 * x25
	add	x26,		x26,		x24	//x26 = (x19*x25) + x24
	lsl	x26,		x26,		2	//x26 = ((x19*x25) + x24)*4

	str	x0,		[x27,x26]		//stores the value of x0 in x27 + x26

	add 	x24,		x24,		1	//increments x24 by 1

	//inner loop test
	cmp	x19,		x24			//compares x24 to x19
	b.gt	GenI					//if it is greater thean it loops to the inner loop
	add	x25,		x25,		1	//adds one to x25
	
	//the outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	GenO					//if it is greater then it will loop to the outer loop


InitialzeEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   




/*
Function: display
	prints the Table
inputs:
	x0,	the x19 dimension of the list
	x1,	the x20 dimension of the list
	x2,	the pointer to the stack array
*/

//display subroutine
display:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	x19,		x0		//copies x19 from x0
	mov	x20,		x1		//compies x20 from x1
	mov	x27,		x2		//copies the array pointer from x2

	//start of the reading loop
	mov	x25,		0		//0 is the starting value for x25
ReadO:						//outer loop for Reading
	mov	x24,		0		//resets the value of x24 to 0
ReadI:						//inner loop for Reading
	mul	x26,		x25,		x19	//x26 = x25 * x19
	add	x26,		x26,		x24	//x26 = (x25*x19) + x24
	lsl	x26,		x26,		2	//x26 = ((x25*x19) + x24)*4

	ldr	x1,		[x27,x26]		//loads the value of x1 in x27 + x26

	ldr	x0,		=int			//loads the new number print string into x0
	bl	printf					//calls the printf function

	add	x24,		x24,		1	//increments x24 by 1

	//test for the inner read loop
	cmp	x19,		x24			//Test for the inner loop
	b.gt	ReadI					//if it is greater then it will jump to The inner loop

	add	x25,		x25,		1	//Adds 1 to x25

	ldr	x0,		=nl			//loads the newline string
	bl	printf					//prints a newline

	//test for the outer read loop						//Outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	ReadO					//if it is greater than it will jump to the outer read loop

DisplayEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret      





/*
Function: TopReleventDocs
	gets user input to print a row of top document in decending order
Inputs:	x0,	the x19 dimension of the list
	x1,	the x20 dimension of the list
	x2, 	the stack pointer to the array
 */

TopReleventDocs:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x19,		x0			//copies x19 from x0
	mov	x20,		x1			//compies x20 from x1
	mov	x27,		x2			//copies the array pointer from x2

	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov	w2,		01 | 02000		//write/append only
	mov	w3,		0666			//arg4 not used
	mov	x8,		56			//opennat x24/O request
	svc	0					//system call

	cmp	w0,		0			//error check
	b.gt	TOPok					//test
	ldr	x0,		=aError			//prints an error message
	bl	printf


TOPok:
	mov	w28,		w0			//moves w0 into w28


GetIndex:


	ldr	x0,		=PrintIndex		//loads the print string
	sub	x1,		x20,		1	//loads x20-1 into x1
	bl	printf					//prints

	ldr	x0,		=inputInt		//loads the inputInt string into x0
	ldr	x1,		=input			//loads the input destination into x1
	bl	scanf					//callls scanf
	ldr	x25,		=input			//loads the input location into x25
	ldr	x25,		[x25]			//loads the value of the input into x25

	//Input validation
	cmp	x25,		x20			//compares x25 to x20
	b.ge	GetIndex				//if x25 is greater or equal then it Loops

	cmp	x25,		0			//compares x25 and 0
	b.lt	GetIndex				//if it is less then it loops again

	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=IndexSearched		//Writes PrintIndex into the file
	mov	x2,		16			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	x9,		x25,	48		//adds 48 to x25 and stores it in x9
	str	x9,		[x29,s_s]		//stores x9 on the stack


	//writes the number to the file
	mov	w0,		w28			//loads fd into w0
	add	x1,		x29,	s_s		//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call


	mov	x24,		0			//starting value for x24
	mov	w23,		0			//starting value for w23
	add	x9,		x27,		i_s	//the full stack array location
	add	x10,		x27,		s_s	//the temp stack location

TempStorageLoop:
	//index math
	mul	x26,		x25,		x19	//x26 = x25 * x19
	add	x26,		x26,		x24	//x26 = (x25*x19) + x24
	lsl	x26,		x26,		2	//x26 = ((x25*x19) + x24)*4

	ldrh	w11,		[x9,x26]		//loads the indexed variable into x11
	add	w23,		w23,		w11	//calculates size before any changes are made
	strh	w11,		[x10]			//stores temp 3 into the temp array

	add	x10,		x10,		4	//increments x10 by 2
	add	x24,		x24,		1	//increments x24 by 1

	//loop test
	cmp	x24,		x19			//compares x24 ot x19
	b.lt	TempStorageLoop				//if it is less then it will loop again



GetAmmount:						//gets input for the ammount of docs
	ldr	x0,		=PrintAmmount		//loads the print string
	mov	x1,		x19			//loads x19 into x1
	bl	printf					//prints

	ldr	x0,		=inputInt		//loads the inputInt string into x0
	ldr	x1,		=input			//loads the input destination into x1
	bl	scanf					//callls scanf
	ldr	x26,		=input			//loads the input location into x26
	ldr	x26,		[x26]			//loads the value of the input into x26

	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=TopFound		//Writes  into the file
	mov	x2,		21			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	x9,		x26,		48	//adds 48 to x26
	str	x9,		[x29,s_s]		//stores the adjusted number on the stack

	//writes the number to the file
	mov	w0,		w28			//loads fd into w0
	add	x1,		x29,		s_s	//Writes PrintIndex into the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=nl			//Writes PrintIndex into the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//input validataion
	cmp	x26,		x19			//compares x26 and x19	
	b.gt	GetAmmount				//if it is greater then it loops

	cmp	x26,		1			//compares x26 and 1
	b.lt	GetAmmount				//if it is less then it loops

SelectLoopO:
	mov	x24,		0			//starting value for x24
	add	x25,		x27,		s_s	//moves the location of the temparray into x25
	mov	w21,		0			//starting value for w21

SelectLoopI:						//the inner loop for the select loop
	ldrh	w0,		[x25]			//loads the value for x25 into w0

	cmp	w21,		w0			//compares w0 to the current biggest
	b.gt	SelectLT				//if w21 is greater then it moves to SelectLT

	mov	w21,		w0			//moves w0 into top
	mov	x22,	x24			//changes the x22 to x24
SelectLT:						
	//incrementing values
	add	x24,		x24,		1	//increments x24 by one
	add	x25,		x25,		4	//increments x25 by the size of an int
	

	//inner loop test
	cmp	x24,		x19			//compares x24 to x19
	b.lt	SelectLoopI				//loops back to the top

	//removes the previous w21 from the temp list
	mov	x10,		4					//moves the size of a word into x10
	mov	x11,		0					//moves zero into x11
	add	x25,		x27,		s_s			//moves the location of the temparray into x25
	madd	x25,		x22,	x10,		x25	//(x24*4)+x25
	str	x11,		[x25]					//stores 0 in the location of the previous highest freq

	//calculates frequency for the w21
	mov	w9,		100			//loads 100 into w9
	mul	w21,		w21,		w9	//multiplies w21 by w9
	udiv	w21,		w21,		w23	//divides w21 by w23

	ldr	x0,		=TopDocPrint		//loads the int string		
	mov	x1,		x22
	mov	w2,		w21			//loads w21 into w1
	bl	printf					//calls printf

	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=WWord			//Writes the word into the file
	mov	x2,		6			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	x9,		x22,	48	//adds 48 to x25 and stores it in x9
	str	x9,		[x29,s_s]		//stores x9 on the stack


	//writes the number to the file
	mov	w0,		w28			//loads fd into w0
	add	x1,		x29,	s_s		//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call


	//adjusts the number to askii
	mov	w11,		10
	udiv	w9,		w21,		w11	
	mul	w12,		w11,		w9
	sub	w10,		w21,		w12
	
	add	w9,		w9,		48
	add	w10,		w10,		48

	

	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=WFreq			//Writes the word into the file
	mov	x2,		11			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call
	//writes the number to the file
	str	w9,		[x29,s_s]		//stores x9 on the stack
	mov	w0,		w28			//loads fd into w0
	add	x1,		x29,		s_s	//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	str	w10,		[x29,s_s]		//stores x9 on the stack
	mov	w0,		w28			//loads fd into w0
	add	x1,		x29,		s_s	//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	
	//new line written to file
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	sub	x26,		x26,		1	//subtracts x26 by one
	//outer loop test
	cmp	x26,		0			//compares x26 to 0	
	b.gt	SelectLoopO				//if it is greater then it loops again

TopReleventLoop:
	ldr	x0,		=TopDocsAgain
	bl	printf

	ldr	x0,		=inputInt		//loads the inputInt string into x0
	ldr	x1,		=input			//loads the input destination into x1
	bl	scanf					//callls scanf
	ldr	x26,		=input			//loads the input location into x26
	ldr	x26,		[x26]			//loads the value of the input into x26

	cmp	x26,		0
	b.ne	GetIndex

TopReleventDocsEnd:

	//closes the file
	mov	w0,		w28			//moves w28 into w0
	mov	x8,		57			//close x24/O request
	svc	0	

	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   



/*
Funciton: WriteFile
	Updates the log file with the selected matrix 
Input:
	x0,	x19 dimension of the table
	x1,	x20 dimension of the table
	x2,	Pointer to the stack matrix
 */

WriteFile:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x19,		x0			//copies x19 from x0
	mov	x20,		x1			//compies x20 from x1
	mov	x27,		x2			//copies the array pointer from x2

	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov 	w2, 		01 | 0100 | 01000	//write-only, create if it doesnt exist, truncate existing
	mov 	w3, 		0666			//rw for all
	mov	x8,		56			//opennat x24/O request
	svc	0					//system call

	cmp	w0,		0			//error check
	b.gt	writeok					//test
	ldr	x0,		=aError			//prints an error message
	bl	printf
	b	WriteFileEnd

writeok:
	mov	w28,		w0			//moves w0 into w28
	//Start of the Generating loop 
	mov	x25,		0			//starting value for x25
WriteFO:							//the outer loop for generating the numbers
	mov	x24,		0			//resets the value of x24
	
WriteFI:		
	//does math to find the index				//the inner loop for reading numbs from file and storing them in array
	mul	x26,		x25,		x19	//x26 = x19 * x25
	add	x26,		x26,		x24	//x26 = (x19*x25) + x24
	lsl	x26,		x26,		2	//x26 = ((x19*x25) + x24)*4

	//accounting for difference in file type
	ldr	x0,		[x27,x26]		//loads the number
	add	x0,		x0,		48	//subtracts 48 from it, accounts for difference in character type
	str	x0,		[x27,x26]		//stores the number

	//file write
	mov	w0,		w28			//loads fd into w0
	add	x1,		x27,		x26	//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	add 	x24,		x24,		1	//increments x24 by 1

	ldr	x0,		[x27,x26]		//loads the number
	sub	x0,		x0,		48	//subtracts 48 from it, accounts for difference in character type
	str	x0,		[x27,x26]		//stores the number

	//inner loop test
	cmp	x19,		x24			//compares x24 to x19
	b.gt	WriteFI					//if it is greater thean it loops to the inner loop
	add	x25,		x25,		1	//adds one to x25
	
	//file write
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=nl			//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//the outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	WriteFO					//if it is greater then it will loop to the outer loop

	//closes the file
	mov	w0,		w28			//moves w28 into w0
	mov	x8,		57			//close x24/O request
	svc	0	

WriteFileEnd:	
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   

	.data
input:	.word 0
	
