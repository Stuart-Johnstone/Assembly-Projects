	
	//Assignment 5
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
	//temp x regesters
			
			
			
	
	//temp word regesters
			
			
			
	
	//temp float regesters
	
	
	
	
	//regular regesters
			//used for storing floats
	 			//the regester for storing x19
				//the regester for storing x20
				//counter for the i dimension of the list
				//counter for the j dimension of the list
			//stores x27
			//storage regester, used for getting the index on the stack
			//stores the File Pointer 
	
			//stores x28

	//x funcion regesters
	
	
	
	
	

	//Random Numb Only
	
	
	
	//bomb only
	
	
	
	



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

	mov	x28,		x0		//moves x0 into x28
	mov	x27,		x1		//moves x1 into x27

	bl	clock				//calls the clock function
	bl	srand				//calls srand to randomize the seed

	//loads arguements
	cmp	x28,		4		//checks to see if there are enough arguements
	b.ne	neError				//if it isn't equal to 4 then it prints an error


	ldr	x19,		[x27,8]	//loads the second arguement from x27
	ldr	x20,		[x27,16]	//loads the third arguement from x27

	mov	x0,		x19		//loads x19 into x0 
	bl 	atoi				//converts x0 from string into int
	mov	x19,		x0		//moves x0 into x19
	
	mov	x0,		x20		//loads x20 into x0
	bl 	atoi				//converts x0 from string into int
	mov	x20,		x0		//loads x0 into x20

	//input validation
	cmp 	x19,		10		//compares x19 and 5
	b.lt	neError				//if less than it throws an error
	cmp	x19,		30		//compares x19 and 20
	b.gt	neError				//if less than it throws an error
	cmp 	x20,		10		//compares x20 and 4
	b.lt	neError				//if less than it throws an error
	cmp	x20,		30		//compares x20 and 20
	b.gt	neError				//if less than it throws an error
	
	ldr	x10,		[x27,24]	//loads the name string
	ldr	x9,		=nameSave	//loads the location where its going to be saved
	str	x10,		[x9]		//saves the name string

	mul	x9,		x19,		x20	//x9 is the size of x19 x x20
	mov	x10,		256			//allocates enough memory for both arrays
	mul	x9,		x9,		x10	//muls x9 and x10 and negates the result
	and	x9,		x9,		-16	//ands x9 with -16
	sub	x29,		x29,		x9	//adds x9 to x29


	//stores x19 and x20 in data
	ldr	x9,		=M_t		//loads the location of M_t into x9	
	str	x19,		[x9]		//stores the value of x19 into M_t
	ldr	x9,		=N_t		//loads the location of N_t into x9	
	str	x20,		[x9]		//stores the value of x20 into N_t

	ldr	x9,		=Bombs		//loads location for the bombs	
	ldr	x10,		=Lives		//loads the location for the lives
	str	x19,		[x9]		//sets bombs = x19
	str	x20,		[x10]		//sets lives = x20

	bl 	ReadFromFile

	add	x28,		x29,		256	//adds a buffer to the pointer
	mov	x0,		x28			//moves the array pointer into x0
	bl	Initialize				//calls the initialize funtion

GameLoop:
	mov	x0,		x28		//moves the pointer into x0
	bl	Display				//calls the display funciton

	//gets input
	mov	x0,		x19		//loads x19 into x0
	mov	x1,		x20		//loads x20 into x1
	bl	GetCords			//calls get cords
	//checks if the input is the quit code
	ldr	x27,		=CordX		//loads locaiton of cordx
	ldr	x27,		[x27]		//loads value of cordx
	cmp	x27,		100		//compares it to 100
	b.eq	RecScore			//it if it is equal it quits the program

	mov	x0,		x19		//moves x19 into x0
	mov	x1,		x20		//loads x20 into x1
	mov	x2,		x28		//loads the pointer
	bl	Bomb				//calls bomb

	ldr	x9,		=Bombs			//loads the adress of the bomb 
	ldr	x10,		[x9]			//loads the value of the bomb
	cmp	x10,		0
	b.le	RecScore

	ldr	x9,		=Lives			//loads the adress of the bomb 
	ldr	x10,		[x9]			//loads the value of the bomb
	cmp	x10,		0
	b.le	RecScore

	ldr	x9,		=Rounds			//loads the adress of the rounds 
	ldr	x10,		[x9]			//loads the value of the rounds
	add	x10,		x10,		1	//adds a round
	str	x10,		[x9]			//stores the rounds

	b	GameLoop			//loops

RecScore:
	mov	x0,		x28		//moves the pointer into x0
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

	mov	x28,		x0	//moves the pointer into x28
	mov 	x22,		0	//starting index for i
DispTO:
	mov	x21,		0	//starting index for i
DispTI:

	ldr	x9,		=M_t			//loads the locaiton for m into x9
	ldr	x9,		[x9]			//loads the value for m into x9
	mul	x27,		x22,		x9	//x27 = x19 * x22
	add	x27,		x27,		x21	//x27 = (x19*x22) + x21
	lsl	x27,		x27,		4	//x27 = ((x19*x22) + x21)*16

	ldr	d10,		[x28,x27]		//loads the value form the table

//sorts the values baseed on encoded value
 
	ldr	x9,		=eighty			//loads the location of the eighty float
	ldr	d9,		[x9]			//loads the value of 100.0
	fcmp	d10,		d9			//compares d10 to 100
	b.lt	Disp1					//if it is less then it moves onto disp1
	ldr	x0,		=X			//loads the X string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp1:
	fmov	d9,		20.0
	fcmp	d10,		d9			//compares d10 to twenty
	b.ne	Disp2					//if it is less then it moves on
	ldr	x0,		=Dollar			//loads the star string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp2:
	fcmp	d10,		0.0			//compares d10 to 0.0
	b.gt	Disp3					//if it is greater then it moves on
	ldr	x0,		=Minus			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd


Disp3:
	fmov	d9,		21.0			//moves 21 into d9
	fcmp	d10,		d9			//compares d10 to 0.0
	b.ne	Disp4				//if it is greater then it moves on
	ldr	x0,		=Star			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

Disp4:
	fmov	d9,		22.0			//moves 21 into d9
	fcmp	d10,		d9			//compares d10 to 0.0
	b.ne	DispPlus				//if it is greater then it moves on
	ldr	x0,		=Up			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd
Disp5:
	fmov	d9,		23.0			//moves 21 into d9
	fcmp	d10,		d9			//compares d10 to 0.0
	b.ne	DispPlus				//if it is greater then it moves on
	ldr	x0,		=Exc			//loads minus string
	bl	printf					//print
	b	DispEnd					//moves to DispEnd

DispPlus:
	ldr	x0,		=Plus			//loads the plus string
	bl	printf					//print

DispEnd:

	//fmov	d0,		d10
	//ldr	x0,		=float
	//bl	printf

	add	x21,		x21,		1	//increments x21 by 1
DisplayTestI:
	ldr	x9,		=M_t		//loads the location for the x19 dimension of the list into x9
	ldr	x9,		[x9]		//loads the value of x19 into x9
	cmp	x21,		x9		//compares x21 to x9
	b.lt	DispTI				//if it is less then it loops again

	add	x22,		x22,		1	//increments x22 by one
	ldr	x0,		=nl			//prints a new line
	bl	printf					//prints

DisplayTestO:
	ldr	x9,		=N_t		//loads the location of the x20 dimension of the lsit into x9
	ldr	x9,		[x9]		//loads the value of x20 into x9
	cmp	x22,		x9		//compares x22 to x9
	b.lt	DispTO				//if it is less then it loops again

DisplayText:
	//displays game text
	ldr	x9,		=Lives		//loads lives
	ldr	x10,		=Score		//loads score
	ldr	x11,		=Bombs		//loads bombs
	ldr	x0,		=GameString	//loads the print string
	ldr	x1,		[x9]
	ldr	d0,		[x10]
	ldr	x2,		[x11]
	bl	printf				//prints

DisplayEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    



/*
Funciotn: Initialize
	Initializes and encodes the game board with floats

Inputs:	x0,	the pointer to the stack array

Outputs: none
*/


Initialize:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	mov	x28,		x0			//saves the array pointer


	//generates cordinates for the exit tile
	ldr	x9,		=M_t			//loads the location
	ldr	x9,		[x9]			//loads the value of x19
	sub 	x9,		x9,		1	//subtracts 1 from it
	mov	x0,		x9			//moves the value into x0
	mov	x1,		0			//moves 0 into x1
	mov	x2,		0			//moves 0 into x2
	bl	RandomNumb				//calls random numb
	mov	x24,	x0			//stores the returned value into x24

	ldr	x9,		=M_t			//loads the location
	ldr	x9,		[x9]			//loads the value of x19
	sub 	x9,		x9,		1	//subtracts 1 from it
	mov	x0,		x9			//moves the value into x0
	mov	x1,		0			//moves 0 into x1
	mov	x2,		0			//moves 0 into x2
	bl	RandomNumb				//calls random numb
	mov	x25,	x0			//stores the returned value into x25


	mov 	x22,		0			//starting index for i
InitTO:
	mov	x21,		0			//starting index for i
InitTI:	
	ldr	x9,		=M_t 			//loads the location of x19
	ldr	x9,		[x9]			//loads x19 into x9
	mul	x27,		x22,		x9	//x27 = x19 * x22
	add	x27,		x27,		x21	//x27 = (x19*x22) + x21
	lsl	x27,		x27,		4	//x27 = ((x19*x22) + x21)*8

	//generates a random number between 0 and 5
	mov	x0,		4	//moves 5 into x0		
	mov	x1,		0	//moves 0 into x1
	mov	x2,		0	//moves 0 into x2
	bl	RandomNumb		//calls random numb

	//checks for the exit tile
	cmp	x21,		x24	//checks to see if the x value matches
	b.ne	Init0
	cmp	x22,		x25	//checks to see if the y value matches
	b.ne	Init0
	fmov	d0,		21.0	//moves code for exit into d0
	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=Star		//loads the float string
	bl	printf				//prints the generated number
	b	InitPrint

Init0:
	cmp	x0,		0	//if x0 is equal to 0 it will make the number special
	b.ne	Init1			//if not equal it moves on

	mov	x0,		3	//moves 3 into x0		
	mov	x1,		0	//moves 0 into x1
	mov	x2,		0	//moves 0 into x2
	bl	RandomNumb		//calls random numb

	cmp	x0,		0	//if x0 is equal to 0 it will set d0 to 0
	b.ne	InitSpecial1		//if not equal it moves on

	fmov	d0,		23.0
	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=Exc		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

InitSpecial1:
	cmp	x0,		1	//if x0 is equal to 0 it will set d0 to 0
	b.ne	InitSpecial2		//if not equal it moves on

	fmov	d0,		22.0
	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=Up		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

InitSpecial2:

	fmov	d0,		20.0
	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=Dollar		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint

Init1:					
	cmp	x0,		1	//compares the random numb to 1
	b.ne	Init2			//if it isn't equal it moves on

	//adds one to the negative counter
	ldr	x9,		=Neg_t			//loads the negative counter
	ldr	x10,		[x9]			//loads the value
	add 	x10,		x10,		1	//adds one to it
	str	x10,		[x9]			//saves the new negative value

	mov	x0,		150			//moves 150 itno x0, max value 15.0
	mov	x1,		1			//loads 1 into x1, min value 0.1
	mov	x2,		1			//loads 1 into x2 making it negative
	bl	RandomNumb				//calls random numb

	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=float		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint
Init2:
	cmp	x0,		2	//compares the random numb to 2
	b.ne	Init3			//if it isn't equal it moves on

	ldr	x9,		=Neg_t			//loads the negative counter
	ldr	x10,		[x9]			//loads the value
	add 	x10,		x10,		1	//adds one to it
	str	x10,		[x9]			//saves the new negative value

	mov	x0,		150			//moves 150 itno x0, max value 15.0
	mov	x1,		1			//loads 1 into x1, min value 0.1
	mov	x2,		1			//loads 1 into x2 making it negative
	bl	RandomNumb				//calls random numb

	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=float		//loads the float string
	bl	printf				//prints the generated number

	b	InitPrint
Init3:
	mov	x0,		150			//moves 150 itno x0, max value 15.0
	mov	x1,		1			//loads 1 into x1, min value 0.1
	mov	x2,		0			//loads 0 into x2 making it posative
	bl	RandomNumb				//calls random numb

	str	d0,		[x28,x27]	//stores the value
	ldr	x0,		=float		//loads the float string
	bl	printf				//prints the generated number

	
	
InitPrint:

	//encodes the float with 100 to signal that it is covered
	
	ldr	x9,		=Hundred		//loads the location of the hundred float
	ldr	d9,		[x9]			//loads the value of 100.0
	ldr	d1,		[x28,x27]		//loads the random numb from the stack
	fadd	d1,		d1,		d9	//adds 100 to random number, this encodes it for later, the 100 will be subtracted as a way to say its unhidden
	str	d1,		[x28,x27]		//stores the adjusted number
	
	add	x21,		x21,		1	//increments x21 by one

InitLoopTestI:
	ldr	x9,		=M_t		//loads the location for the x19 dimension of the list into x9
	ldr	x9,		[x9]		//loads the value of x19 into x9
	cmp	x21,		x9		//compares x21 to x9
	b.lt	InitTI				//if it is less then it loops again

	add	x22,		x22,		1	//increments x22 by one
	ldr	x0,		=nl			//prints a new line
	bl	printf					//prints

InitLoopTestO:
	ldr	x9,		=N_t		//loads the location of the x20 dimension of the lsit into x9
	ldr	x9,		[x9]		//loads the value of x20 into x9
	cmp	x22,		x9		//compares x22 to x9
	b.lt	InitTO				//if it is less then it loops again

	ldr	x9,		=Neg_t		//loads the location of the total negative in the board
	ldr	x9,		[x9]		//loads the value of Neg_t into x9

	ldr	x10,		=N_t		//loads the location of the x20 dimension of the lsit into x10
	ldr	x10,		[x10]		//loads the value of x20 into x10

	ldr	x11,		=M_t		//loads the location of the x19 dimension of the lsit into x11
	ldr	x11,		[x11]		//loads the value of x19 into x11


	mul	x10,		x10,		x11	//multiplies x20 by x19
	mov	x11,		100			//moves 100 into x11
	mul	x9,		x9,		x11	//negative * 100
	sdiv	x9,		x9,		x10	//negative * 100 / (x20*x19)

	ldr	x0,		=PersentNegative	//persent negative string
	mov	x1,		x9			//loads the persent negaitve value
	bl	printf					//prints

	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    
/*
Function: RandomNumb
	Makes a random number between two values
Inputs: 
	x0, the Maximum of the random number
	x1, the minimum of the random number
	x2, 1 if the number is negative, otherwise the number will be positive

Output:
	d0, the random float
	x0, a coresponding random numb
 */

RandomNumb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP
	
	mov	x19,		x0			//moves x0 into x19
	mov	x20,		x1			//moves x1 into min
	mov	x23,	x2
	
	bl	rand					//calls rand

							// x % y = ( x - ( floor(x/y) ) * y )
	add	x19,		x19,		1	// max + 1
	sub	x19,		x19,		x20	// max + 1 - x20
	udiv	x9,		x0,		x19	// floor(x/y)
	mul	x9,		x9,		x19	// floor(x/y) * y
	sub	x9,		x0,		x9	// x - ( floor(x/y) ) * y
	sub	x0,		x9,		x20	// (rand() % (max + 1 - min)) - min

	scvtf	d0,		x0
	fmov	d9,		10.0
	fdiv	d0,		d0,		d9

	cmp	x23,		1		//check if the thrid arg is 1
	b.ne	RandomNumbEnd				//if it is then it negates the numb
	fmov	d1,		1.0			//moves 1 into x9
	fnmul	d0,		d0,		d1	//mnegs x0 and x9


RandomNumbEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    

/*
Funciton: Bomb
	bombs the tile selected before with get Cords
Inputs: x0,	the m dimension of the list
	x1,	the x20 dimension of the list
	x2,	the array pointer
Outputs: none
 */

Bomb:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	//loads funciton arguements
	mov	x19,		x0		//loads x0 into x19
	mov	x20,		x1		//loads x1 into x20
	mov	x28,		x2		//loads x2 into x28

	//loads and resets the bomb radius
	ldr	x9,		=Bomb_radius	//loads the location of Bomb_Radius into x9
	ldr	x23,		[x9]		//loads the bomb radius into radius
	mov	x10,		1		//moves 1 into x9 
	str	x10,		[x9]		//saves 1 to the bomb radius

	//loads the cordinates from user input
	ldr	x24,	=CordX		//loads the x cordinates
	ldr	x25,	=CordY		//loads the y cordinate 
	ldr	x24,	[x24]	//loads the value
	ldr	x25,	[x25]	//loads the value

	//starting values for the table
	fmov	d19,		1.0			//temporary temp score value
	mov	x9,		1			//moves 1 into x9 to negate radius
	mneg	x22,		x9,		x23	//x22 = -radius
BombLoopO:
	mov	x9,		1			//moves 1 into x9 to negate radius
	mneg	x21,		x9,		x23	//x21 = -radius

BombLoopI:
	mov	x0,		x24		//moves the x cord into x0
	mov	x1,		x21		//moves x21 into x1
	mov	x2,		x19		//moves the x19 dimension into x2
	bl	CheckCords			//calls check cords

	cmp	x0,		1		//if it is equal to 1 it continues
	b.ne	BombLoopTestI			//else it moves to the loop test

	mov	x0,		x25		//moves the y cord into x0
	mov	x1,		x22		//moves x22 into x1
	mov	x2,		x20		//moves the x20 dimension into x2
	bl	CheckCords			//calls check cords

	cmp	x0,		1		//if it is equal to 1 it continues
	b.ne	BombLoopTestI			//else it moves to the loop test

	add	x9,		x24,	x21	//gets the index for the m dimension
	add	x10,		x25,	x22	//gets the index for the n dimension

	mul	x27,		x10,		x19	//x27 = x19 * x22
	add	x27,		x27,		x9	//x27 = (x19*x22) + x21
	lsl	x27,		x27,		4	//x27 = ((x19*x22) + x21)*16

	ldr	d9,		[x28,x27]		//loads the value form the table

	//filters based on value
	ldr	x10,		=eighty			//loads the location of eighty
	ldr	d10,		[x10]			//loads 80.0
	fcmp	d9,		d10			//compares the read number to 80.0
	b.lt	BombLoopTestI				//if it is less then it moves on as it has already been found

	//if the number hasn't been counted yet it subtracts 100 from it to get its true value
	ldr	x10,		=Hundred		//loads the location to 100
	ldr	d10,		[x10]			//loads the value of 100.0
	fsub	d9,		d9,		d10	//subtracts 100 from the unfound value to discover the real value of it
	str	d9,		[x28,x27]		//stors the newly found value

	//handling for the exit tile
	fmov	d10,		21.0			//loads 21.0 into d10
	fcmp	d9,		d10			//compares the loaded number to 21.0
	b.ne 	Bomb1					//when not equal it moves on

	ldr	x9,		=Lives			//loads the adress of the lives
	ldr	x10,		[x9]			//loads the value of the lives
	mov	x10,		-100			//kills the player
	str	x10,		[x9]			//stores the new value
	b	BombLoopTestI				//jumps to the end of the loop

Bomb1:	//handling for bomb radius
	fmov	d10,		20.0			//loads 21.0 into d10
	fcmp	d9,		d10			//compares the loaded number to 21.0
	b.ne 	Bomb2					//when not equal it moves on

	ldr	x9,		=Bomb_radius		//loads the adress of the lives
	ldr	x10,		[x9]			//loads the value of the lives
	mov	x10,		2			//doubles the bomb radius
	str	x10,		[x9]			//stores the new value

Bomb2:	//handling for live subtractor
	fmov	d10,		22.0			//loads 21.0 into d10
	fcmp	d9,		d10			//compares the loaded number to 21.0
	b.ne 	Bomb3					//when not equal it moves on

	ldr	x9,		=Lives			//loads the adress of the lives
	ldr	x10,		[x9]			//loads the value of the lives
	add	x10,		x10,		1	//doubles the bomb radius
	str	x10,		[x9]			//stores the new value
Bomb3:	//handling for live subtractor
	fmov	d10,		23.0			//loads 21.0 into d10
	fcmp	d9,		d10			//compares the loaded number to 21.0
	b.ne 	Bomb4					//when not equal it moves on

	ldr	x9,		=Lives			//loads the adress of the lives
	ldr	x10,		[x9]			//loads the value of the lives
	sub	x10,		x10,		1	//doubles the bomb radius
	str	x10,		[x9]			//stores the new value
Bomb4:
	fmov	d10,		16.0			//loads 16 into d10
	fcmp	d9,		d10			//checks to see if the loaded number is greater then 16
	b.gt	BombLoopTestI				//if it is then it doesn't add it to the score

	fadd	d19,		d19,		d9	//adds the tile score to the temp score


BombLoopTestI:

	add	x21,		x21,		1	//increments x21 by 1
	cmp	x21,		x23			//compares x21 to x23
	b.le	BombLoopI				//if it is less it loops

BombLoopTestO:
	add	x22,		x22,		1	//increments x22 by 1
 	cmp	x22,		x23			//compares x22 to x23
	b.le	BombLoopO				//if it is le then it loops

	//if the temp score is less then 0 it subtracts a life
	fcmp	d19,		0.0
	b.gt	BombPlus
	//loads and subtracts a life
	ldr	x9,		=Lives			//loads the adress of the lives
	ldr	x10,		[x9]			//loads the value of the lives
	sub	x10,		x10,		1	//decrements the life counter
	str	x10,		[x9]			//stores the new value

BombPlus:
	//adds the temp score to the game score
	ldr	x9,		=Score			//loads the location of the score
	ldr	d9,		[x9]			//loads the value of the score into d9
	fadd	d9,		d9,		d19	//adds the temp score to the score
	str	d9,		[x9]			//stors the new score

	//decrements the bomb by 1
	ldr	x9,		=Bombs			//loads the adress of the bomb 
	ldr	x10,		[x9]			//loads the value of the bomb
	sub	x10,		x10,		1	//decrements the bomb counter
	str	x10,		[x9]			//saves the new value


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
	ldr	x0,		=QuitString	//loads the string informing the user how to quit
	bl	printf				//prints
	ldr 	x0,		=CordString	//loads the string about the cordinatess they can bomb
	bl	printf				//prints

	ldr	x0,		=inputCords	//loads the input string
	ldr	x1,		=CordX		//loads the cordX locaiton
	ldr	x2,		=CordY		//loads the CordY locaiton
	bl	scanf

	ldr	x1,		=CordX		//loads the locaiton in to x1
	ldr	x2,		=CordY		//loads the locaiton into x2
	ldr	x9,		[x1]		//loads the X value into x9
	ldr	x10,		[x2]		//loads the Y value into x10

	cmp	x9,		100		//compares x9 to -1
	b.eq	GetCordsEnd				//loops if it is less
	cmp	x10,		100		//compares x10 to -1
	b.eq	GetCordsEnd				//loops if it is less

	cmp	x9,		0		//compares x9 to -1
	b.lt	GetLoop				//loops if it is less
	cmp	x10,		0		//compares x10 to -1
	b.lt	GetLoop				//loops if it is less

	//loads x19 and x20 from data
	ldr	x11,		=M_t		//loads the location of M_t into x9	
	ldr	x19,		[x11]		//loads the value of x19 from M_t
	ldr	x11,		=N_t		//loads the location of N_t into x9	
	ldr	x20,		[x11]		//loads the value of x20 from N_t

	cmp	x9,		x19		//compares x9 to x19
	b.ge	GetLoop				//loops if it is greater then or equal to 

	cmp	x10,		x20		//compares x10 to x20
	b.ge	GetLoop				//loops if it is greater then or equal to

GetCordsEnd:
	ldp     x29, 		x30, 		[sp], 		dealloc     // Restore FP and LR from stack
	ret    

/*
Function: Check Cords
	Checks to see if a given cordinate is valid or not
Inputs: x0,	the cordinate
	x1,	the bomb radius being checked
	x2,	the array length in the same
Outputs:
	x0,	1 if the cordinate is valid, 0 if it isnt
*/
CheckCords:
	stp     x29, 		x30,		[sp, alloc]!	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

	add	x9,		x0,		x1		// x + e
	cmp	x9,		0				// compares x + e to 0
	b.lt	CheckFail					// if it is less it will return 0 

	sub	x9,		x9,		x2		// x + e - l
	add	x9,		x9,		1		// x + e - l + 1

	cmp	x9,		0				// compares x + e - l - 1 to 0
	b.gt	CheckFail					// if it is greater then it will return 0

	mov	x0,		1				// returns 1
	b	CheckCordsEnd					// jumps to end

CheckFail:
	mov	x0,		0				// return 0

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

	ldr	x0,		=highScores		//highscore string
	bl	printf					//calls printf

	ldr	x0,		=inputInt		//input int string
	ldr 	x1,		=readTimes		//data var to store the amount of scores ot read
	bl	scanf

	ldr	x9,		=readTimes		//loads the ammount of scores to read
	ldr	x9,		[x9]			//gets value

	cmp	x9,		0			//compares 0 to x9
	b.le	ReadEnd					//jumps to end of function


	mov	w0,		-100			//1st arg
	ldr	x1,		=LogFile		//file name
	mov	w2,		0 			//read only
	mov	w3,		0666			//arg4 not used
	mov	x8,		56			//opennat x21/O request
	svc	0					//system call

	mov	w28,		w0			//moves w0 into w28

	cmp	w0,		0			//checks to see if the file exists
	b.lt	ReadEnd

ReadLoop:

	ldr	x0,		=ReadName
	bl	printf

NameLoop:
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	x0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	x0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	x1,		=storeString		//loads the string
	ldr	w1,		[x1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	NameLoop				//loops if not the newline

	ldr	x0,		=ReadRounds
	bl	printf

RoundLoop:
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	x0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	x0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	x1,		=storeString		//loads the string
	ldr	w1,		[x1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	RoundLoop				//loops if not the newline

	ldr	x0,		=ReadScore
	bl	printf

ScoreLoop:
	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=storeString		//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		63			//read code
	svc	0					//system call

	cmp	x0,		0			//checks to see if it read anything
	b.eq	ReadEnd					

	ldr	x0,		=storeString		//loads the read bit
	bl	printf					//prints it
	
	ldr	x1,		=storeString		//loads the string
	ldr	w1,		[x1]			//gets the individual bit into w1
	and	w1,		w1,		0xFF	//ands it with 0xff

	cmp	w1,		10			//checks to see if it is the newline character
	b.ne 	ScoreLoop				//loops if not the newline

	ldr	x9,		=readTimes		//loads the amount of times read
	ldr	x10,		[x9]			//loads the value

	sub	x10,		x10,		1	//subtracts 1
	str	x10,		[x9]			//stores the adjusted value

	cmp	x10,		0			//compares to 0
	b.le	ReadEnd					//if it is le it quits out
	b	ReadLoop				//else it loops again

ReadEnd:
	ldr	x0,		=nl			//prints a newline
	bl	printf					//

	//closes the file
	mov	w0,		w28			//moves w28 into w0
	mov	x8,		57			//close x21/O request
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
	mov	x8,		56			//opennat x21/O request
	svc	0					//system call

	mov	w28,		w0			//moves the file pointer into w28

	cmp	x9,		0			//compares 0 to x9
	b.le	LogEnd					//jumps to end of function

	ldr 	x9,		=nameSave
	ldr	x10,		=temp
nameLoop:
	ldrb	w11,		[x9]
	and	w11,		w11,		0xf
	add	w11,		w11,		48		
	str	w11,		[x10]

	mov	w0,		w28			//loads fd into w0
	ldr	x1,		=temp			//pointer to buffer in memory
	mov	x2,		1			//the number of bytes to read
	mov	x8,		64			//write code
	svc	0					//system call



	//closes the file
	mov	w0,		w28			//moves w28 into w0
	mov	x8,		57			//close x21/O request
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


	
