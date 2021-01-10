
	//Assignment 3
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x24, x0-x2
	define(m1,x19)			//first number being multiplied
	define(m2,x20)			//second number being multiplied
	define(RES,x21)			//the regester used to save the result
	define(AND,x22)			//the regester used for storing the result of and operations
	define(COUNT,x23)		//the regester used for the counter
	define(s,x24)			//the regester to save a bit shifted version of m2
	define(m1REF,x25)		//Saves the original value of m1 before it gets shifted
	define(m2REF,x26)		//Saves the original value of m2 before it gets shifted
	define(arg0, x0)		//macro for function regestry 0
	define(arg1, x1)		//macro for function regestry 1
	define(arg2, x2)		//macro for function regestry 2
	define(arg3, x3)		//macro for function regestry 3


	//Define the format of the string you'll use to output the result
	str1:	   .string "%d * %d = %d \n"	//first print statement for user input
	str2:	   .string "%d "	//first print statement for user input
	

	.balign 4                               // Instructions must be word aligned
	.global main                            // Make "main" visible to the OS and start the execution

//saves system vars
main:
	stp     x29, 		x30,	[sp, -16]!          	// Save FP and LR to stack
	mov     x29, 		sp                         	// Update FP to the scurrent SP

// the start of the program
start:	
	mov		m1REF,		-15			//moves the starting number into m1

numLoop:							//start of the first while loop, runs untill m1REF == 15
	mov		m1,		m1REF

	bl		rand					//calls the rand function and saves the number in arg0
	and		arg0,		arg0,		0x0F	//does bitwise and on the random number, max of 15
	mov 		m2,		arg0			//moves the random number into m2
	mov		m2REF,		arg0			//moves the random number into m2REF to be printed later

	mov		AND,		0			//sets the value of AND to 0
	mov		s,		1			//sets the value of s to 1
	mov		RES,		0			//sets the value of RES to 0
	mov		COUNT,		0			//sets the counter to 0

	b 		bitLoopTest				//goes to the bit loop test

bitLoop:							//while loop for the bit loop, shifts the bits to do multiplication
	and		AND,		m1,		1	//ands m1 and 1 to see if the last bit of m1 is a 1
	cmp		AND,		#0x0001			//compares the result in AND to see if it is equal to 1
	b.ne		after					//if it isn't then it jumps to after
	add		RES,		RES,		m2	//adds m2 to RES if AND == 1

after:								
	lsr		m1,		m1,		1	//shifts m1 to the right 1 bit
	lsl		m2,		m2,		1	//shifts m2 to the left 1 bit
	add		s,		s,		s	//adds s to s (s^2)
	add		COUNT,		COUNT,		1	//adds 1 to COUNT
	
bitLoopTest:							//tests to see if the bit loop is done or not
	cmp		COUNT, 		64			//compares COUNT to 64
	b.lt		bitLoop					//if COUNT is less than then it loops again, else it prints the result of the multiplication

	ldr		arg0,		=str1			//loads the output string
	mov		arg1,		m1REF			//moves m1REF into arg1
	mov		arg2,		m2REF			//moves m2REF into arg2
	mov		arg3,		RES			//moves RES into arg3
	bl		printf					//Prints the string

		
numLoopTest:							//checks if m1REF has gone from -15 to 15
	add		m1REF,		m1REF,		1	//adds one to m1REF
	cmp		m1REF,		15			//compares m1REF to 15
	b.le		numLoop					//if it is lessthan or equal to it loops again, else the program moves onto done

done:
	ldp     x29, 	x30, 	[sp], 	16      	// Restore FP and LR from stack
	ret                                     	// Return to caller (OS)


	.data
input:	.word 0
	
