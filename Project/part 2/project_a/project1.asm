	
	//Assignment 5
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
	//temp x regesters
	define(temp1,x9)		
	define(temp2,x10)		
	define(temp3,x11)		
	define(temp4,x12)
	//temp word regesters
	define(tempw1,w9)		
	define(tempw2,w10)		
	define(tempw3,w11)		
	define(tempw4,w12)
	//temp float regesters
	define(tempd1,d9)
	define(tempd2,d10)
	define(tempd3,d11)
	define(tempd4,d12)
	//regular regesters
	define(STORD,d19)		//used for storing floats
	define(M,x19) 			//the regester for storing M
	define(N,x20)			//the regester for storing N
	define(I,x21)			//counter for the i dimension of the list
	define(J,x22)			//counter for the j dimension of the list
	define(argv,x27)		//stores argv
	define(STOR,x27)		//storage regester, used for getting the index on the stack
	define(FPTR,w28)		//stores the File Pointer 
	define(PTR,x28)
	define(argc,x28)		//stores argc

	//x funcion regesters
	define(a0,x0)
	define(a1,x1)
	define(a2,x2)
	define(a3,x3)
	define(a4,x4)

	//Random Numb Only
	define(Max,x19)
	define(Min,x20)
	define(NEGATIVE,x23)
	//bomb only
	define(Radius,x23)
	define(X_Table,x24)
	define(Y_Table,x25)
	define(TScore,d19)



	//Define the format of the string you'll use to output the result

	X:		.string "X "
	Dollar:		.string "$ "
	Up:		.string "^ "
	Exc:		.string "! "
	Star:		.string "* "
	Plus:		.string "+ "
	Minus:		.string "- "


	int:    	.string "%d "							//used for printf calls
	inputInt:	.string "%d"							//used for scanf calls
	inputCords:	.string "%d %d"							//used for scanf calls
	float:		.string "%2.1f "

	LogFileOld:	.string "project.log"
	name:		.string "%s"
	ReadName:	.string "Name: "
	ReadRounds:	.string "Rounds: "
	ReadScore:	.string "Score: "

	nl:		.string "\n"							//newline
	PersentNegative:.string "The board is %d persent negative \n"			//negative persentage string
	GameString:	.string "Lives: %d \nScore: %3.2f \nBombs: %d \n"
	QuitString:	.string "Type 100 100 to Quit\n"				//printed before the cord string
	CordString:	.string "What are the cordinates you want to bomb (x y)? "	//used for getting the cordinates to bomb
	aError:		.string "Need exactly two arguements inbetween 10 and 30 and a name\n"	//error handling string
	highScores:	.string "How many high scores do you want to read? (0 for none) "
	
	LogFile:	.string "log.txt"						//file path to log file

	s_s = 16			//start of the temp array
	a_s = s_s			//array start
	alloc = -(a_s) & -16		//allocates space on the stack
	dealloc = -alloc		//deallocates the space on the stack

 
	.balign 4                               // Instructions must be word aligned
	.global main                            // Make "main" visible to the OS and start the execution
	/*********************Begining of MAIN*****************/
main:								//saves system vars
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	argc,		x0		//moves x0 into argc
	mov	argv,		x1		//moves x1 into argv

	bl	clock				//calls the clock function
	bl	srand				//calls srand to randomize the seed

	//loads arguements
	cmp	argc,		4		//checks to see if there are enough arguements
	b.ne	neError				//if it isn't equal to 4 then it prints an error


	ldr	M,		[argv,8]	//loads the second arguement from argv
	ldr	N,		[argv,16]	//loads the third arguement from argv

	mov	a0,		M		//loads M into a0 
	bl 	atoi				//converts a0 from string into int
	mov	M,		a0		//moves a0 into M
	
	mov	a0,		N		//loads N into a0
	bl 	atoi				//converts a0 from string into int
	mov	N,		a0		//loads a0 into N

	//input validation
	cmp 	M,		10		//compares M and 5
	b.lt	neError				//if less than it throws an error
	cmp	M,		30		//compares M and 20
	b.gt	neError				//if less than it throws an error
	cmp 	N,		10		//compares N and 4
	b.lt	neError				//if less than it throws an error
	cmp	N,		30		//compares N and 20
	b.gt	neError				//if less than it throws an error
	
	ldr	temp2,		[argv,24]	//loads the name string
	ldr	temp1,		=nameSave	//loads the location where its going to be saved
	str	temp2,		[temp1]		//saves the name string

	mul	temp1,		M,		N	//temp1 is the size of M x N
	mov	temp2,		256			//allocates enough memory for both arrays
	mul	temp1,		temp1,		temp2	//muls temp1 and temp2 and negates the result
	and	temp1,		temp1,		-16	//ands temp1 with -16
	sub	x29,		x29,		temp1	//adds temp1 to x29


	//stores M and N in data
	ldr	temp1,		=M_t		//loads the location of M_t into temp1	
	str	M,		[temp1]		//stores the value of M into M_t
	ldr	temp1,		=N_t		//loads the location of N_t into temp1	
	str	N,		[temp1]		//stores the value of N into N_t

	ldr	temp1,		=Bombs		//loads location for the bombs	
	ldr	temp2,		=Lives		//loads the location for the lives
	str	M,		[temp1]		//sets bombs = M
	str	N,		[temp2]		//sets lives = N

	bl 	ReadFromFile

	add	PTR,		x29,		256	//adds a buffer to the pointer
	mov	a0,		PTR			//moves the array pointer into a0
	bl	Initialize				//calls the initialize funtion

GameLoop:
	mov	a0,		PTR		//moves the pointer into a0
	bl	Display				//calls the display funciton

	//gets input
	mov	a0,		M		//loads M into a0
	mov	a1,		N		//loads N into a1
	bl	GetCords			//calls get cords
	//checks if the input is the quit code
	ldr	STOR,		=CordX		//loads locaiton of cordx
	ldr	STOR,		[STOR]		//loads value of cordx
	cmp	STOR,		100		//compares it to 100
	b.eq	RecScore			//it if it is equal it quits the program

	mov	a0,		M		//moves M into a0
	mov	a1,		N		//loads N into a1
	mov	a2,		PTR		//loads the pointer
	bl	Bomb				//calls bomb

	ldr	temp1,		=Bombs			//loads the adress of the bomb 
	ldr	temp2,		[temp1]			//loads the value of the bomb
	cmp	temp2,		0
	b.le	RecScore

	ldr	temp1,		=Lives			//loads the adress of the bomb 
	ldr	temp2,		[temp1]			//loads the value of the bomb
	cmp	temp2,		0
	b.le	RecScore

	ldr	temp1,		=Rounds			//loads the adress of the rounds 
	ldr	temp2,		[temp1]			//loads the value of the rounds
	add	temp2,		temp2,		1	//adds a round
	str	temp2,		[temp1]			//stores the rounds

	b	GameLoop			//loops

RecScore:
	mov	a0,		PTR		//moves the pointer into a0
	bl	Display				//calls the display funciton

	//bl	LogScore

	bl 	ReadFromFile

	b	MainEnd				//jumps to done

neError:					//print error then quit
	ldr	x0,		=aError		//loads the error message
	bl	printf				//prints the error message
	
MainEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     	// Restore FP and LR from stack
	ret                               	     				// Return to caller (OS)




/*********************************************************************************************/
/*********************Begining of Functions***************************************************/
/*********************************************************************************************/

Display:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	PTR,		a0	//moves the pointer into PTR
	mov 	J,		0	//starting index for i
DispTO:
	mov	I,		0	//starting index for i
DispTI:

	ldr	temp1,		=M_t			//loads the locaiton for m into temp1
	ldr	temp1,		[temp1]			//loads the value for m into temp1
	mul	STOR,		J,		temp1	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		4	//STOR = ((M*J) + I)*16

	ldr	tempd2,		[PTR,STOR]		//loads the value form the table

//sorts the values baseed on encoded value
 
	ldr	temp1,		=eighty			//loads the location of the eighty float
	ldr	tempd1,		[temp1]			//loads the value of 100.0
	fcmp	tempd2,		tempd1			//compares tempd2 to 100
	b.lt	Disp1					//if it is less then it moves onto disp1
	ldr	a0,		=X			//loads the X string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp1:
	fmov	tempd1,		20.0
	fcmp	tempd2,		tempd1			//compares tempd2 to twenty
	b.ne	Disp2					//if it is less then it moves on
	ldr	a0,		=Dollar			//loads the star string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp2:
	fcmp	tempd2,		0.0			//compares tempd2 to 0.0
	b.gt	Disp3					//if it is greater then it moves on
	ldr	a0,		=Minus			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd


Disp3:
	fmov	tempd1,		21.0			//moves 21 into tempd1
	fcmp	tempd2,		tempd1			//compares tempd2 to 0.0
	b.ne	Disp4				//if it is greater then it moves on
	ldr	a0,		=Star			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp4:
	fmov	tempd1,		22.0			//moves 21 into tempd1
	fcmp	tempd2,		tempd1			//compares tempd2 to 0.0
	b.ne	DispPlus				//if it is greater then it moves on
	ldr	a0,		=Up			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd
Disp5:
	fmov	tempd1,		23.0			//moves 21 into tempd1
	fcmp	tempd2,		tempd1			//compares tempd2 to 0.0
	b.ne	DispPlus				//if it is greater then it moves on
	ldr	a0,		=Exc			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

DispPlus:
	ldr	a0,		=Plus			//loads the plus string
	bl	printf					//print

DispEnd:

	//fmov	d0,		tempd2
	//ldr	a0,		=float
	//bl	printf

	add	I,		I,		1	//increments I by 1
DisplayTestI:
	ldr	temp1,		=M_t		//loads the location for the M dimension of the list into temp1
	ldr	temp1,		[temp1]		//loads the value of M into temp1
	cmp	I,		temp1		//compares I to temp1
	b.lt	DispTI				//if it is less then it loops again

	add	J,		J,		1	//increments J by one
	ldr	a0,		=nl			//prints a new line
	bl	printf					//prints

DisplayTestO:
	ldr	temp1,		=N_t		//loads the location of the N dimension of the lsit into temp1
	ldr	temp1,		[temp1]		//loads the value of N into temp1
	cmp	J,		temp1		//compares J to temp1
	b.lt	DispTO				//if it is less then it loops again

DisplayText:
	//displays game text
	ldr	temp1,		=Lives		//loads lives
	ldr	temp2,		=Score		//loads score
	ldr	temp3,		=Bombs		//loads bombs
	ldr	a0,		=GameString	//loads the print string
	ldr	a1,		[temp1]
	ldr	d0,		[temp2]
	ldr	a2,		[temp3]
	bl	printf				//prints

DisplayEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    



/*
Funciotn: Initialize
	Initializes and encodes the game board with floats

Inputs:	a0,	the pointer to the stack array

Outputs: none
*/


Initialize:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	PTR,		a0			//saves the array pointer


	//generates cordinates for the exit tile
	ldr	temp1,		=M_t			//loads the location
	ldr	temp1,		[temp1]			//loads the value of M
	sub 	temp1,		temp1,		1	//subtracts 1 from it
	mov	a0,		temp1			//moves the value into a0
	mov	a1,		0			//moves 0 into a1
	mov	a2,		0			//moves 0 into a2
	bl	RandomNumb				//calls random numb
	mov	X_Table,	a0			//stores the returned value into X_Table

	ldr	temp1,		=M_t			//loads the location
	ldr	temp1,		[temp1]			//loads the value of M
	sub 	temp1,		temp1,		1	//subtracts 1 from it
	mov	a0,		temp1			//moves the value into a0
	mov	a1,		0			//moves 0 into a1
	mov	a2,		0			//moves 0 into a2
	bl	RandomNumb				//calls random numb
	mov	Y_Table,	a0			//stores the returned value into Y_Table


	mov 	J,		0			//starting index for i
InitTO:
	mov	I,		0			//starting index for i
InitTI:	
	ldr	temp1,		=M_t 			//loads the location of M
	ldr	temp1,		[temp1]			//loads M into temp1
	mul	STOR,		J,		temp1	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		4	//STOR = ((M*J) + I)*8

	//generates a random number between 0 and 5
	mov	a0,		4	//moves 5 into a0		
	mov	a1,		0	//moves 0 into a1
	mov	a2,		0	//moves 0 into a2
	bl	RandomNumb		//calls random numb

	//checks for the exit tile
	cmp	I,		X_Table	//checks to see if the x value matches
	b.ne	Init0
	cmp	J,		Y_Table	//checks to see if the y value matches
	b.ne	Init0
	fmov	d0,		21.0	//moves code for exit into d0
	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=Star		//loads the float string
	bl	printf				//prints the generated number
	b	InitPrint

Init0:
	cmp	a0,		0	//if a0 is equal to 0 it will make the number special
	b.ne	Init1			//if not equal it moves on

	mov	a0,		3	//moves 3 into a0		
	mov	a1,		0	//moves 0 into a1
	mov	a2,		0	//moves 0 into a2
	bl	RandomNumb		//calls random numb

	cmp	a0,		0	//if a0 is equal to 0 it will set d0 to 0
	b.ne	InitSpecial1		//if not equal it moves on

	fmov	d0,		23.0
	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=Exc		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

InitSpecial1:
	cmp	a0,		1	//if a0 is equal to 0 it will set d0 to 0
	b.ne	InitSpecial2		//if not equal it moves on

	fmov	d0,		22.0
	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=Up		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

InitSpecial2:

	fmov	d0,		20.0
	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=Dollar		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

Init1:					
	cmp	a0,		1	//compares the random numb to 1
	b.ne	Init2			//if it isn't equal it moves on

	//adds one to the negative counter
	ldr	temp1,		=Neg_t			//loads the negative counter
	ldr	temp2,		[temp1]			//loads the value
	add 	temp2,		temp2,		1	//adds one to it
	str	temp2,		[temp1]			//saves the new negative value

	mov	a0,		150			//moves 150 itno a0, max value 15.0
	mov	a1,		1			//loads 1 into a1, min value 0.1
	mov	a2,		1			//loads 1 into a2 making it negative
	bl	RandomNumb				//calls random numb

	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=float		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint
Init2:
	cmp	a0,		2	//compares the random numb to 2
	b.ne	Init3			//if it isn't equal it moves on

	ldr	temp1,		=Neg_t			//loads the negative counter
	ldr	temp2,		[temp1]			//loads the value
	add 	temp2,		temp2,		1	//adds one to it
	str	temp2,		[temp1]			//saves the new negative value

	mov	a0,		150			//moves 150 itno a0, max value 15.0
	mov	a1,		1			//loads 1 into a1, min value 0.1
	mov	a2,		1			//loads 1 into a2 making it negative
	bl	RandomNumb				//calls random numb

	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=float		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint
Init3:
	mov	a0,		150			//moves 150 itno a0, max value 15.0
	mov	a1,		1			//loads 1 into a1, min value 0.1
	mov	a2,		0			//loads 0 into a2 making it posative
	bl	RandomNumb				//calls random numb

	str	d0,		[PTR,STOR]	//stores the value
	ldr	a0,		=float		//loads the float string
	bl	printf				//prints the generated number

	
	
InitPrint:

	//encodes the float with 100 to signal that it is covered
	
	ldr	temp1,		=Hundred		//loads the location of the hundred float
	ldr	tempd1,		[temp1]			//loads the value of 100.0
	ldr	d1,		[PTR,STOR]		//loads the random numb from the stack
	fadd	d1,		d1,		tempd1	//adds 100 to random number, this encodes it for later, the 100 will be subtracted as a way to say its unhidden
	str	d1,		[PTR,STOR]		//stores the adjusted number
	
	add	I,		I,		1	//increments I by one

InitLoopTestI:
	ldr	temp1,		=M_t		//loads the location for the M dimension of the list into temp1
	ldr	temp1,		[temp1]		//loads the value of M into temp1
	cmp	I,		temp1		//compares I to temp1
	b.lt	InitTI				//if it is less then it loops again

	add	J,		J,		1	//increments J by one
	ldr	a0,		=nl			//prints a new line
	bl	printf					//prints

InitLoopTestO:
	ldr	temp1,		=N_t		//loads the location of the N dimension of the lsit into temp1
	ldr	temp1,		[temp1]		//loads the value of N into temp1
	cmp	J,		temp1		//compares J to temp1
	b.lt	InitTO				//if it is less then it loops again

	ldr	temp1,		=Neg_t		//loads the location of the total negative in the board
	ldr	temp1,		[temp1]		//loads the value of Neg_t into temp1

	ldr	temp2,		=N_t		//loads the location of the N dimension of the lsit into temp2
	ldr	temp2,		[temp2]		//loads the value of N into temp2

	ldr	temp3,		=M_t		//loads the location of the M dimension of the lsit into temp3
	ldr	temp3,		[temp3]		//loads the value of M into temp3


	mul	temp2,		temp2,		temp3	//multiplies N by M
	mov	temp3,		100			//moves 100 into temp3
	mul	temp1,		temp1,		temp3	//negative * 100
	sdiv	temp1,		temp1,		temp2	//negative * 100 / (N*M)

	ldr	a0,		=PersentNegative	//persent negative string
	mov	a1,		temp1			//loads the persent negaitve value
	bl	printf					//prints

	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    
/*
Function: RandomNumb
	Makes a random number between two values
Inputs: 
	a0, the Maximum of the random number
	a1, the minimum of the random number
	a2, 1 if the number is negative, otherwise the number will be positive

Output:
	d0, the random float
	a0, a coresponding random numb
 */

RandomNumb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	Max,		a0			//moves a0 into Max
	mov	Min,		a1			//moves a1 into min
	mov	NEGATIVE,	a2
	
	bl	rand					//calls rand

							// x % y = ( x - ( floor(x/y) ) * y )
	add	Max,		Max,		1	// max + 1
	sub	Max,		Max,		Min	// max + 1 - N
	udiv	temp1,		a0,		Max	// floor(x/y)
	mul	temp1,		temp1,		Max	// floor(x/y) * y
	sub	temp1,		a0,		temp1	// x - ( floor(x/y) ) * y
	sub	a0,		temp1,		Min	// (rand() % (max + 1 - min)) - min

	scvtf	d0,		a0
	fmov	tempd1,		10.0
	fdiv	d0,		d0,		tempd1

	cmp	NEGATIVE,		1		//check if the thrid arg is 1
	b.ne	RandomNumbEnd				//if it is then it negates the numb
	fmov	d1,		1.0			//moves 1 into temp1
	fnmul	d0,		d0,		d1	//mnegs a0 and temp1


RandomNumbEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    

/*
Funciton: Bomb
	bombs the tile selected before with get Cords
Inputs: a0,	the m dimension of the list
	a1,	the N dimension of the list
	a2,	the array pointer
Outputs: none
 */

Bomb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	//loads funciton arguements
	mov	M,		a0		//loads a0 into M
	mov	N,		a1		//loads a1 into N
	mov	PTR,		a2		//loads a2 into PTR

	//loads and resets the bomb radius
	ldr	temp1,		=Bomb_radius	//loads the location of Bomb_Radius into temp1
	ldr	Radius,		[temp1]		//loads the bomb radius into radius
	mov	temp2,		1		//moves 1 into temp1 
	str	temp2,		[temp1]		//saves 1 to the bomb radius

	//loads the cordinates from user input
	ldr	X_Table,	=CordX		//loads the x cordinates
	ldr	Y_Table,	=CordY		//loads the y cordinate 
	ldr	X_Table,	[X_Table]	//loads the value
	ldr	Y_Table,	[Y_Table]	//loads the value

	//starting values for the table
	fmov	TScore,		1.0			//temporary temp score value
	mov	temp1,		1			//moves 1 into temp1 to negate radius
	mneg	J,		temp1,		Radius	//J = -radius
BombLoopO:
	mov	temp1,		1			//moves 1 into temp1 to negate radius
	mneg	I,		temp1,		Radius	//I = -radius

BombLoopI:
	mov	a0,		X_Table		//moves the x cord into x0
	mov	a1,		I		//moves I into a1
	mov	a2,		M		//moves the M dimension into a2
	bl	CheckCords			//calls check cords

	cmp	a0,		1		//if it is equal to 1 it continues
	b.ne	BombLoopTestI			//else it moves to the loop test

	mov	a0,		Y_Table		//moves the y cord into x0
	mov	a1,		J		//moves J into a1
	mov	a2,		N		//moves the N dimension into a2
	bl	CheckCords			//calls check cords

	cmp	a0,		1		//if it is equal to 1 it continues
	b.ne	BombLoopTestI			//else it moves to the loop test

	add	temp1,		X_Table,	I	//gets the index for the m dimension
	add	temp2,		Y_Table,	J	//gets the index for the n dimension

	mul	STOR,		temp2,		M	//STOR = M * J
	add	STOR,		STOR,		temp1	//STOR = (M*J) + I
	lsl	STOR,		STOR,		4	//STOR = ((M*J) + I)*16

	ldr	tempd1,		[PTR,STOR]		//loads the value form the table

	//filters based on value
	ldr	temp2,		=eighty			//loads the location of eighty
	ldr	tempd2,		[temp2]			//loads 80.0
	fcmp	tempd1,		tempd2			//compares the read number to 80.0
	b.lt	BombLoopTestI				//if it is less then it moves on as it has already been found

	//if the number hasn't been counted yet it subtracts 100 from it to get its true value
	ldr	temp2,		=Hundred		//loads the location to 100
	ldr	tempd2,		[temp2]			//loads the value of 100.0
	fsub	tempd1,		tempd1,		tempd2	//subtracts 100 from the unfound value to discover the real value of it
	str	tempd1,		[PTR,STOR]		//stors the newly found value

	//handling for the exit tile
	fmov	tempd2,		21.0			//loads 21.0 into tempd2
	fcmp	tempd1,		tempd2			//compares the loaded number to 21.0
	b.ne 	Bomb1					//when not equal it moves on

	ldr	temp1,		=Lives			//loads the adress of the lives
	ldr	temp2,		[temp1]			//loads the value of the lives
	mov	temp2,		-100			//kills the player
	str	temp2,		[temp1]			//stores the new value
	b	BombLoopTestI				//jumps to the end of the loop

Bomb1:	//handling for bomb radius
	fmov	tempd2,		20.0			//loads 21.0 into tempd2
	fcmp	tempd1,		tempd2			//compares the loaded number to 21.0
	b.ne 	Bomb2					//when not equal it moves on

	ldr	temp1,		=Bomb_radius		//loads the adress of the lives
	ldr	temp2,		[temp1]			//loads the value of the lives
	mov	temp2,		2			//doubles the bomb radius
	str	temp2,		[temp1]			//stores the new value

Bomb2:	//handling for live subtractor
	fmov	tempd2,		22.0			//loads 21.0 into tempd2
	fcmp	tempd1,		tempd2			//compares the loaded number to 21.0
	b.ne 	Bomb3					//when not equal it moves on

	ldr	temp1,		=Lives			//loads the adress of the lives
	ldr	temp2,		[temp1]			//loads the value of the lives
	add	temp2,		temp2,		1	//doubles the bomb radius
	str	temp2,		[temp1]			//stores the new value
Bomb3:	//handling for live subtractor
	fmov	tempd2,		23.0			//loads 21.0 into tempd2
	fcmp	tempd1,		tempd2			//compares the loaded number to 21.0
	b.ne 	Bomb4					//when not equal it moves on

	ldr	temp1,		=Lives			//loads the adress of the lives
	ldr	temp2,		[temp1]			//loads the value of the lives
	sub	temp2,		temp2,		1	//doubles the bomb radius
	str	temp2,		[temp1]			//stores the new value
Bomb4:
	fmov	tempd2,		16.0			//loads 16 into tempd2
	fcmp	tempd1,		tempd2			//checks to see if the loaded number is greater then 16
	b.gt	BombLoopTestI				//if it is then it doesn't add it to the score

	fadd	TScore,		TScore,		tempd1	//adds the tile score to the temp score


BombLoopTestI:

	add	I,		I,		1	//increments I by 1
	cmp	I,		Radius			//compares I to Radius
	b.le	BombLoopI				//if it is less it loops

BombLoopTestO:
	add	J,		J,		1	//increments J by 1
 	cmp	J,		Radius			//compares J to Radius
	b.le	BombLoopO				//if it is le then it loops

	//if the temp score is less then 0 it subtracts a life
	fcmp	TScore,		0.0
	b.gt	BombPlus
	//loads and subtracts a life
	ldr	temp1,		=Lives			//loads the adress of the lives
	ldr	temp2,		[temp1]			//loads the value of the lives
	sub	temp2,		temp2,		1	//decrements the life counter
	str	temp2,		[temp1]			//stores the new value

BombPlus:
	//adds the temp score to the game score
	ldr	temp1,		=Score			//loads the location of the score
	ldr	tempd1,		[temp1]			//loads the value of the score into tempd1
	fadd	tempd1,		tempd1,		TScore	//adds the temp score to the score
	str	tempd1,		[temp1]			//stors the new score

	//decrements the bomb by 1
	ldr	temp1,		=Bombs			//loads the adress of the bomb 
	ldr	temp2,		[temp1]			//loads the value of the bomb
	sub	temp2,		temp2,		1	//decrements the bomb counter
	str	temp2,		[temp1]			//saves the new value


BombEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    


/*
Function: GetCords 
	Gets valid cordinates
Inputs: none
Output: CordX, data, the chosen X cordinate
	CordY, data, the chosen Y cordinate
*/

GetCords:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
GetLoop:
	ldr	a0,		=QuitString	//loads the string informing the user how to quit
	bl	printf				//prints
	ldr 	a0,		=CordString	//loads the string about the cordinatess they can bomb
	bl	printf				//prints

	ldr	a0,		=inputCords	//loads the input string
	ldr	a1,		=CordX		//loads the cordX locaiton
	ldr	a2,		=CordY		//loads the CordY locaiton
	bl	scanf

	ldr	a1,		=CordX		//loads the locaiton in to a1
	ldr	a2,		=CordY		//loads the locaiton into a2
	ldr	temp1,		[a1]		//loads the X value into temp1
	ldr	temp2,		[a2]		//loads the Y value into temp2

	cmp	temp1,		100		//compares temp1 to -1
	b.eq	GetCordsEnd				//loops if it is less
	cmp	temp2,		100		//compares temp2 to -1
	b.eq	GetCordsEnd				//loops if it is less

	cmp	temp1,		0		//compares temp1 to -1
	b.lt	GetLoop				//loops if it is less
	cmp	temp2,		0		//compares temp2 to -1
	b.lt	GetLoop				//loops if it is less

	//loads M and N from data
	ldr	temp3,		=M_t		//loads the location of M_t into temp1	
	ldr	M,		[temp3]		//loads the value of M from M_t
	ldr	temp3,		=N_t		//loads the location of N_t into temp1	
	ldr	N,		[temp3]		//loads the value of N from N_t

	cmp	temp1,		M		//compares temp1 to M
	b.ge	GetLoop				//loops if it is greater then or equal to 

	cmp	temp2,		N		//compares temp2 to N
	b.ge	GetLoop				//loops if it is greater then or equal to

GetCordsEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    

/*
Function: Check Cords
	Checks to see if a given cordinate is valid or not
Inputs: a0,	the cordinate
	a1,	the bomb radius being checked
	a2,	the array length in the same
Outputs:
	a0,	1 if the cordinate is valid, 0 if it isnt
*/
CheckCords:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	add	temp1,		a0,		a1		// x + e
	cmp	temp1,		0				// compares x + e to 0
	b.lt	CheckFail					// if it is less it will return 0 

	sub	temp1,		temp1,		a2		// x + e - l
	add	temp1,		temp1,		1		// x + e - l + 1

	cmp	temp1,		0				// compares x + e - l - 1 to 0
	b.gt	CheckFail					// if it is greater then it will return 0

	mov	a0,		1				// returns 1
	b	CheckCordsEnd					// jumps to end

CheckFail:
	mov	a0,		0				// return 0

CheckCordsEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    


/*
Function: ReadFromFile
	Reads the number of highscores the user wants from the log file in order
Input: none

Output: none
 */
ReadFromFile:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	ldr	a0,		=highScores		//highscore string
	bl	printf					//calls printf

	ldr	a0,		=inputInt		//input int string
	ldr 	a1,		=readTimes		//data var to store the amount of scores ot read
	bl	scanf

	ldr	temp1,		=readTimes		//loads the ammount of scores to read
	ldr	temp1,		[temp1]			//gets value

	cmp	temp1,		0			//compares 0 to temp1
	b.le	ReadEnd					//jumps to end of function


	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov	w2,		0 			//read only
	mov	w3,		0666			//arg4 not used
	mov	x8,		56			//opennat I/O request
	svc	0					//system call

	mov	FPTR,		w0			//moves w0 into FPTR

	cmp	w0,		0			//checks to see if the file exists
	b.lt	ReadEnd

ReadLoop:

	ldr	a0,		=ReadName
	bl	printf

NameLoop:
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	a0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	a0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	a1,		=storeString		//loads the string
	ldr	w1,		[a1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	NameLoop				//loops if not the newline

	ldr	a0,		=ReadRounds
	bl	printf

RoundLoop:
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	a0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	a0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	a1,		=storeString		//loads the string
	ldr	w1,		[a1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	RoundLoop				//loops if not the newline

	ldr	a0,		=ReadScore
	bl	printf

ScoreLoop:
	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	a0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	a0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	a1,		=storeString		//loads the string
	ldr	w1,		[a1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	ScoreLoop				//loops if not the newline

	ldr	temp1,		=readTimes		//loads the amount of times read
	ldr	temp2,		[temp1]			//loads the value

	sub	temp2,		temp2,		1	//subtracts 1
	str	temp2,		[temp1]			//stores the adjusted value

	cmp	temp2,		0			//compares to 0
	b.le	ReadEnd					//if it is le it quits out
	b	ReadLoop				//else it loops again

ReadEnd:
	ldr	a0,		=nl			//prints a newline
	bl	printf					//

	//closes the file
	mov	w0,		FPTR			//moves FPTR into w0
	mov	x8,		57			//close I/O request
	svc	0	

	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    



/*
LogScore:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov	w2,		02101			//write and append only
	mov	w3,		0666			//arg4 not used
	mov	x8,		56			//opennat I/O request
	svc	0					//system call

	mov	FPTR,		w0			//moves the file pointer into FPTR

	cmp	temp1,		0			//compares 0 to temp1
	b.le	LogEnd					//jumps to end of function

	ldr 	temp1,		=nameSave
	ldr	temp2,		=temp
nameLoop:
	ldrb	tempw3,		[temp1]
	and	tempw3,		tempw3,		0xf
	add	tempw3,		tempw3,		48		
	str	tempw3,		[temp2]

	mov	w0,		FPTR			//loads fd into w0
	ldr	x1,		=temp			//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		64			//write code
	svc	0					//system call



	//closes the file
	mov	w0,		FPTR			//moves FPTR into w0
	mov	x8,		57			//close I/O request
	svc	0
LogEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    
 */

	.data
input:	.word 0
//float values
Hundred:.double 100.0
eighty:	.double	80.0
twentyOne: .double 21.0
twenty: .double 20.0
//used for counting the number of negatives in the table
Neg_t:	.word 0
//table dimensions
M_t:	.dword 0
N_t:	.dword 0
//Player Values
Bomb_radius: .dword 1
Bombs:	     .dword 5
Lives:	     .dword 5
TempScore:   .double 0.0
Score:	     .double 0.0
Rounds:	     .dword 0
//cordinates
CordX: 	.dword 0
CordY:	.dword 0
//file stuff
temp:	.word 0
readTimes: .dword 0
nameSave: 	.string ""
storeString: 	.string ""


	
