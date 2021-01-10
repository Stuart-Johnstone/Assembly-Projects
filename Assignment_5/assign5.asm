	
	//Assignment 5
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
	define(temp1,x9)		//first temp regester
	define(tempw1,w9)		//first w temp regester
	define(temp2,x10)		//second temporary regester
	define(tempw2,w10)
	define(temp3,x11)		//third temporary regester
	define(tempw3,w11)		//third w temporary regester
	define(tempw4,w12)
	define(M,x19) 			//the regester for storing M
	define(N,x20)			//the regester for storing N
	define(TOP,w21)			//the regester for storing the biggest number
	define(Max,x21)			//the regester for storing the min
	define(TOP_Index,x22)		//the regester for storing the index of the biggest num
	define(Min,x22)			//the regester for storing the max
	define(SIZE,w23)		//the regester for storing the size of the document
	define(I,x24)			//counter for the i dimension of the list
	define(J,x25)			//counter for the j dimension of the list
	define(Y,x26)			//counter for holding the number of TOP Documents
	define(STOR,x26)		//storage regester, used for getting the index on the stack
	define(argv,x26)		//stores argv
	define(PTR,x27)			//storing the result of an add on the frame pointer
	define(FPTR,w28)		//stores the File Pointer 
	define(argc,x28)		//stores argc
	define(a0,x0)			//0th function regester
	define(a1,x1)			//1st function regester
	define(a2,x2)			//2nd funciton regester
	define(a3,x3)			//1st function regester
	define(a4,x4)			//2nd funciton regester



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

	mov	argc,		x0
	mov	argv,		x1

	//loads arguements
	cmp	argc,		4		//checks to see if there are enough arguements
	b.gt	neError				//if it isn't equal to 4 then it prints an error

	cmp	argc,		3		//checks to see if there are enough arguements
	b.lt	neError				//if it isn't equal to 3 then it prints an error

	ldr	M,		[argv,8]	//loads the second arguement from argv
	ldr	N,		[argv,16]	//loads the third arguement from argv

	mov	a0,		M		//loads M into a0 
	bl 	atoi				//converts a0 from string into int
	mov	M,		a0		//moves a0 into M
	
	mov	a0,		N		//loads N into a0
	bl 	atoi				//converts a0 from string into int
	mov	N,		a0		//loads a0 into N

	//input validation
	cmp 	M,		5		//compares M and 5
	b.lt	neError				//if less than it throws an error
	cmp	M,		20		//compares M and 20
	b.gt	neError				//if less than it throws an error
	cmp 	N,		5		//compares N and 4
	b.lt	neError				//if less than it throws an error
	cmp	N,		20		//compares N and 20
	b.gt	neError				//if less than it throws an error
	

	cmp	argc,		3			//compares 3 to argc
	b.eq	Init					//if it is equal then it jumps to Init

InitFile:
	mov	a0,		M		        //loads M into the a0 regester
	mov	a1,		N			//loads N into the a1 regester 
	add	a2,		x29,		i_s	//loads the stack array pointer into a2
	bl	InitializeFile                              //calls the display function
	b	Disp					//jumps to display

Init:
	mov	a0,		M		        //loads M into the a0 regester
	mov	a1,		N			//loads N into the a1 regester 
	add	a2,		x29,		i_s	//loads the stack array pointer into a2
	bl	Initialize                              //calls the display function


Disp:
	mov	a0,		M		        //loads M into the a0 regester
	mov	a1,		N			//loads N into the a1 regester 
	add	a2,		x29,		i_s	//loads the stack array pointer into a2
	bl	display                                 //calls the display function

Write:
	mov	a0,		M		        //loads M into the a0 regester
	mov	a1,		N			//loads N into the a1 regester 
	add	a2,		x29,		i_s	//loads the stack array pointer into a2
	bl	WriteFile       			//calls the write file function

TopDocs:
	mov	a0,		M		        //loads M into the a0 regester
	mov	a1,		N			//loads N into the a1 regester 
	mov	a2,		x29			//loads the stack pointer into a2
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
Input:	a0,	M dimension of the table
	a1,	N dimension of the table
	a2,	PTR for the stack table
 */

InitializeFile:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	M,		a0			//copies M from a0
	mov	N,		a1			//compies N from a1
	mov	PTR,		a2			//copies the array pointer from a2

	mov	w0,		-100			//1st arg
	ldr	x1,		=Occurances		//file name
	mov	w2,		0			//read only
	mov	w3,		0			//arg4 not used
	mov	x8,		56			//opennat I/O request
	svc	0
	
	cmp	w0,		0			//error check
	b.gt	ok					//test
	ldr	a0,		=aError			//prints an error message
	bl	printf

ok:
	mov	FPTR,		w0			//moves w0 into FPTR
	//Start of the Generating loop 
	mov	J,		0			//starting value for J
GenFO:							//the outer loop for generating the numbers
	mov	I,		0			//resets the value of I
	
GenFI:		
	//does math to find the index				//the inner loop for reading numbs from file and storing them in array
	mul	STOR,		J,		M	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		2	//STOR = ((M*J) + I)*4

	mov	a0,		0			//zeroing out the memory where the number is going to be stored
	str	a0,		[PTR,STOR]		//storing the zero in memory
	
	//file read
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		PTR,		STOR	//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		63			//read code
	svc	0					//system call

	//adjusts number in
	ldr	a0,		[PTR,STOR]		//loads the number
	sub	a0,		a0,		48	//subtracts 48 from it
	str	a0,		[PTR,STOR]		//stores the number
	
	add 	I,		I,		1	//increments I by 1

	//inner loop test
	cmp	M,		I			//compares I to M
	b.gt	GenFI					//if it is greater thean it loops to the inner loop
	add	J,		J,		1	//adds one to J
	
	//the outer loop test
	cmp	N,		J			//compares N to J
	b.gt	GenFO					//if it is greater then it will loop to the outer loop

	//closes the file
	mov	w0,		FPTR			//moves FPTR into w0
	mov	x8,		57			//close I/O request
	svc	0					//system call


InitialzeFileEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   





/*
Function: RandomNumb
	Makes a random number between two values
Inputs: 
	a0, the Maximum of the random number
	a1, the minimum of the random number

Output:
	a0, the random number
 */

RandomNumb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	Max,		a0			//moves a0 into Max
	mov	Min,		a1			//moves a1 into min
	bl	rand					//calls rand

	add	Max,		Max,		1	// max + 1
	sub	Max,		Max,		Min	// max + 1 - N
							// x % y = ( x - ( floor(x/y) ) * y )
	udiv	temp1,		a0,		Max	// floor(x/y)
	mul	temp1,		temp1,		Max	// floor(x/y) * y
	sub	temp1,		a0,		temp1	// x - ( floor(x/y) ) * y

	sub	a0,		temp1,		Min	// (rand() % (max + 1 - min)) - min

	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    




/*
Function: Initialize
	generates the table
inputs:
	a0,	the M dimension of the list
	a1,	the N dimension of the list
	a2,	the pointer to the stack array
*/
Initialize:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	M,		a0			//copies M from a0
	mov	N,		a1			//compies N from a1
	mov	PTR,		a2			//copies the array pointer from a2

	//Start of the Generating loop 
	mov	J,		0	
GenO:							//the outer loop for generating the numbers
	mov	I,		0			//resets the value of I
	
GenI:							//the inner loop for generating the numbers
	
	mov	a0,		9			//moves 9 into a0
	mov	a1,		0			//moves 0 into a1
	bl 	RandomNumb				//calls RadomNumb

	
	//does math to find the index
	mul	STOR,		J,		M	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		2	//STOR = ((M*J) + I)*4

	str	a0,		[PTR,STOR]		//stores the value of a0 in PTR + STOR

	add 	I,		I,		1	//increments I by 1

	//inner loop test
	cmp	M,		I			//compares I to M
	b.gt	GenI					//if it is greater thean it loops to the inner loop
	add	J,		J,		1	//adds one to J
	
	//the outer loop test
	cmp	N,		J			//compares N to J
	b.gt	GenO					//if it is greater then it will loop to the outer loop


InitialzeEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   




/*
Function: display
	prints the Table
inputs:
	a0,	the M dimension of the list
	a1,	the N dimension of the list
	a2,	the pointer to the stack array
*/

//display subroutine
display:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	M,		a0		//copies M from a0
	mov	N,		a1		//compies N from a1
	mov	PTR,		a2		//copies the array pointer from a2

	//start of the reading loop
	mov	J,		0		//0 is the starting value for J
ReadO:						//outer loop for Reading
	mov	I,		0		//resets the value of I to 0
ReadI:						//inner loop for Reading
	mul	STOR,		J,		M	//STOR = J * M
	add	STOR,		STOR,		I	//STOR = (J*M) + I
	lsl	STOR,		STOR,		2	//STOR = ((J*M) + I)*4

	ldr	a1,		[PTR,STOR]		//loads the value of a1 in PTR + STOR

	ldr	a0,		=int			//loads the new number print string into a0
	bl	printf					//calls the printf function

	add	I,		I,		1	//increments I by 1

	//test for the inner read loop
	cmp	M,		I			//Test for the inner loop
	b.gt	ReadI					//if it is greater then it will jump to The inner loop

	add	J,		J,		1	//Adds 1 to J

	ldr	a0,		=nl			//loads the newline string
	bl	printf					//prints a newline

	//test for the outer read loop						//Outer loop test
	cmp	N,		J			//compares N to J
	b.gt	ReadO					//if it is greater than it will jump to the outer read loop

DisplayEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret      





/*
Function: TopReleventDocs
	gets user input to print a row of top document in decending order
Inputs:	a0,	the M dimension of the list
	a1,	the N dimension of the list
	a2, 	the stack pointer to the array
 */

TopReleventDocs:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	M,		a0			//copies M from a0
	mov	N,		a1			//compies N from a1
	mov	PTR,		a2			//copies the array pointer from a2

	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov	w2,		01 | 02000		//write/append only
	mov	w3,		0666			//arg4 not used
	mov	x8,		56			//opennat I/O request
	svc	0					//system call

	cmp	w0,		0			//error check
	b.gt	TOPok					//test
	ldr	a0,		=aError			//prints an error message
	bl	printf


TOPok:
	mov	FPTR,		w0			//moves w0 into FPTR


GetIndex:


	ldr	a0,		=PrintIndex		//loads the print string
	sub	a1,		N,		1	//loads N-1 into a1
	bl	printf					//prints

	ldr	a0,		=inputInt		//loads the inputInt string into a0
	ldr	a1,		=input			//loads the input destination into a1
	bl	scanf					//callls scanf
	ldr	J,		=input			//loads the input location into J
	ldr	J,		[J]			//loads the value of the input into J

	//Input validation
	cmp	J,		N			//compares J to N
	b.ge	GetIndex				//if J is greater or equal then it Loops

	cmp	J,		0			//compares J and 0
	b.lt	GetIndex				//if it is less then it loops again

	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=IndexSearched		//Writes PrintIndex into the file
	mov	x2,		16			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	temp1,		J,	48		//adds 48 to J and stores it in temp1
	str	temp1,		[x29,s_s]		//stores temp1 on the stack


	//writes the number to the file
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		x29,	s_s		//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call


	mov	I,		0			//starting value for I
	mov	SIZE,		0			//starting value for SIZE
	add	temp1,		PTR,		i_s	//the full stack array location
	add	temp2,		PTR,		s_s	//the temp stack location

TempStorageLoop:
	//index math
	mul	STOR,		J,		M	//STOR = J * M
	add	STOR,		STOR,		I	//STOR = (J*M) + I
	lsl	STOR,		STOR,		2	//STOR = ((J*M) + I)*4

	ldrh	tempw3,		[temp1,STOR]		//loads the indexed variable into temp3
	add	SIZE,		SIZE,		tempw3	//calculates size before any changes are made
	strh	tempw3,		[temp2]			//stores temp 3 into the temp array

	add	temp2,		temp2,		4	//increments temp2 by 2
	add	I,		I,		1	//increments I by 1

	//loop test
	cmp	I,		M			//compares I ot M
	b.lt	TempStorageLoop				//if it is less then it will loop again



GetAmmount:						//gets input for the ammount of docs
	ldr	a0,		=PrintAmmount		//loads the print string
	mov	a1,		M			//loads M into a1
	bl	printf					//prints

	ldr	a0,		=inputInt		//loads the inputInt string into a0
	ldr	a1,		=input			//loads the input destination into a1
	bl	scanf					//callls scanf
	ldr	Y,		=input			//loads the input location into Y
	ldr	Y,		[Y]			//loads the value of the input into Y

	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=TopFound		//Writes  into the file
	mov	x2,		21			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	temp1,		Y,		48	//adds 48 to Y
	str	temp1,		[x29,s_s]		//stores the adjusted number on the stack

	//writes the number to the file
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		x29,		s_s	//Writes PrintIndex into the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=nl			//Writes PrintIndex into the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//input validataion
	cmp	Y,		M			//compares Y and M	
	b.gt	GetAmmount				//if it is greater then it loops

	cmp	Y,		1			//compares Y and 1
	b.lt	GetAmmount				//if it is less then it loops

SelectLoopO:
	mov	I,		0			//starting value for I
	add	J,		PTR,		s_s	//moves the location of the temparray into J
	mov	TOP,		0			//starting value for TOP

SelectLoopI:						//the inner loop for the select loop
	ldrh	w0,		[J]			//loads the value for J into w0

	cmp	TOP,		w0			//compares w0 to the current biggest
	b.gt	SelectLT				//if TOP is greater then it moves to SelectLT

	mov	TOP,		w0			//moves w0 into top
	mov	TOP_Index,	I			//changes the TOP_Index to I
SelectLT:						
	//incrementing values
	add	I,		I,		1	//increments I by one
	add	J,		J,		4	//increments J by the size of an int
	

	//inner loop test
	cmp	I,		M			//compares I to M
	b.lt	SelectLoopI				//loops back to the top

	//removes the previous TOP from the temp list
	mov	temp2,		4					//moves the size of a word into temp2
	mov	temp3,		0					//moves zero into temp3
	add	J,		PTR,		s_s			//moves the location of the temparray into J
	madd	J,		TOP_Index,	temp2,		J	//(I*4)+J
	str	temp3,		[J]					//stores 0 in the location of the previous highest freq

	//calculates frequency for the TOP
	mov	tempw1,		100			//loads 100 into tempw1
	mul	TOP,		TOP,		tempw1	//multiplies TOP by tempw1
	udiv	TOP,		TOP,		SIZE	//divides TOP by SIZE

	ldr	x0,		=TopDocPrint		//loads the int string		
	mov	x1,		TOP_Index
	mov	w2,		TOP			//loads TOP into w1
	bl	printf					//calls printf

	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=WWord			//Writes the word into the file
	mov	x2,		6			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//adjusts the number to askii
	add	temp1,		TOP_Index,	48	//adds 48 to J and stores it in temp1
	str	temp1,		[x29,s_s]		//stores temp1 on the stack


	//writes the number to the file
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		x29,	s_s		//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//new line written to file
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call


	//adjusts the number to askii
	mov	tempw3,		10
	udiv	tempw1,		TOP,		tempw3	
	mul	tempw4,		tempw3,		tempw1
	sub	tempw2,		TOP,		tempw4
	
	add	tempw1,		tempw1,		48
	add	tempw2,		tempw2,		48

	

	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=WFreq			//Writes the word into the file
	mov	x2,		11			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call
	//writes the number to the file
	str	tempw1,		[x29,s_s]		//stores temp1 on the stack
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		x29,		s_s	//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	str	tempw2,		[x29,s_s]		//stores temp1 on the stack
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		x29,		s_s	//writes the stack numb ot the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	
	//new line written to file
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=nl			//wirites a newline to the file
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	sub	Y,		Y,		1	//subtracts Y by one
	//outer loop test
	cmp	Y,		0			//compares Y to 0	
	b.gt	SelectLoopO				//if it is greater then it loops again

TopReleventLoop:
	ldr	a0,		=TopDocsAgain
	bl	printf

	ldr	a0,		=inputInt		//loads the inputInt string into a0
	ldr	a1,		=input			//loads the input destination into a1
	bl	scanf					//callls scanf
	ldr	Y,		=input			//loads the input location into Y
	ldr	Y,		[Y]			//loads the value of the input into Y

	cmp	Y,		0
	b.ne	GetIndex

TopReleventDocsEnd:

	//closes the file
	mov	w0,		FPTR			//moves FPTR into w0
	mov	x8,		57			//close I/O request
	svc	0	

	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   



/*
Funciton: WriteFile
	Updates the log file with the selected matrix 
Input:
	a0,	M dimension of the table
	a1,	N dimension of the table
	a2,	Pointer to the stack matrix
 */

WriteFile:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	M,		a0			//copies M from a0
	mov	N,		a1			//compies N from a1
	mov	PTR,		a2			//copies the array pointer from a2

	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov 	w2, 		01 | 0100 | 01000	//write-only, create if it doesnt exist, truncate existing
	mov 	w3, 		0666			//rw for all
	mov	x8,		56			//opennat I/O request
	svc	0					//system call

	cmp	w0,		0			//error check
	b.gt	writeok					//test
	ldr	a0,		=aError			//prints an error message
	bl	printf
	b	WriteFileEnd

writeok:
	mov	FPTR,		w0			//moves w0 into FPTR
	//Start of the Generating loop 
	mov	J,		0			//starting value for J
WriteFO:							//the outer loop for generating the numbers
	mov	I,		0			//resets the value of I
	
WriteFI:		
	//does math to find the index				//the inner loop for reading numbs from file and storing them in array
	mul	STOR,		J,		M	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		2	//STOR = ((M*J) + I)*4

	//accounting for difference in file type
	ldr	a0,		[PTR,STOR]		//loads the number
	add	a0,		a0,		48	//subtracts 48 from it, accounts for difference in character type
	str	a0,		[PTR,STOR]		//stores the number

	//file write
	mov	w0,		FPTR			//loads fd into w0
	add	x1,		PTR,		STOR	//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	add 	I,		I,		1	//increments I by 1

	ldr	a0,		[PTR,STOR]		//loads the number
	sub	a0,		a0,		48	//subtracts 48 from it, accounts for difference in character type
	str	a0,		[PTR,STOR]		//stores the number

	//inner loop test
	cmp	M,		I			//compares I to M
	b.gt	WriteFI					//if it is greater thean it loops to the inner loop
	add	J,		J,		1	//adds one to J
	
	//file write
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=nl			//the location where the number is going ot be stored
	mov	x2,		1			//the number of bytes to write
	mov	x8,		64			//write code
	svc	0					//system call

	//the outer loop test
	cmp	N,		J			//compares N to J
	b.gt	WriteFO					//if it is greater then it will loop to the outer loop

	//closes the file
	mov	w0,		FPTR			//moves FPTR into w0
	mov	x8,		57			//close I/O request
	svc	0	

WriteFileEnd:	
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret   

	.data
input:	.word 0
	
