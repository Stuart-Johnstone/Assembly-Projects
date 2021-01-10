	
	//Assignment 4
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
	 		//the regester for storing x19
			//the regester for storing x20
			//the regester for storing the biggest number
		//the regester for storing the index of the biggest num
		//the regester for storing the size of the document
			//counter for the i dimension of the list
			//counter for the j dimension of the list
		//storage regester, used for getting the index on the stack
			//storing the result of an add on the frame pointer
		//stores the frequency 
			//0th function regester
			//1st function regester
			//2nd funciton regester

	//Define the format of the string you'll use to output the result
	str1:   	.string "%d "					//int print
	str2:		.string "Frequency: %d Index %d \n"	//prints the frequency related values
	aError:	   	.string "Need exactly two arguements inbetween 4 and 16\n"
	
	s_s = 16					//start of the struct
	i_s = 16*8 + s_s			//start of the stack array
	alloc = -(16*16 + i_s) & -16		//allocates space on the stack
	dealloc = -alloc			//deallocates the space on the stack

 
	.balign 4                               // Instructions must be word aligned
	.global main                            // Make "main" visible to the OS and start the execution

	//saves system vars
main:
	stp     x29, 		x30,		[sp, alloc]!          	// Save FP and LR to stack
	mov     x29, 		sp                         		// Update FP to the scurrent SP

	//loads arguements
	cmp	x0,		3			//checks to see if there are enough arguements
	b.ne	neError					//if it isn't equal to 3 then it prints an error
	
	ldr	x19,		[x1,8]			//loads the second arguement from argv
	ldr	x20,		[x1,16]			//loads the third arguement from argv

	mov	x0,		x19			//loads x19 into x0 
	bl 	atoi					//converts x0 from string into int
	mov	x19,		x0			//moves x0 into x19
	
	mov	x0,		x20			//loads x20 into x0
	bl 	atoi					//converts x0 from string into int
	mov	x20,		x0			//loads x0 into x20

	//input validation
	cmp 	x19,		4			//compares x19 and 4
	b.lt	neError					//if less than it throws an error
	
	cmp	x19,		16			//compares x19 and 16
	b.gt	neError					//if less than it throws an error

	cmp 	x20,		4			//compares x20 and 4
	b.lt	neError					//if less than it throws an error

	cmp	x20,		16			//compares x20 and 16
	b.gt	neError					//if less than it throws an error
	


	//Start of the Generating loop 
	b	GenLoopTestO				//moves to the GenLoopTest for the inner loop

GenLoopO:						//the outer loop for generating the numbers
	mov	x24,		0			//resets the value of x24
	mov	x21,		0			//0 is the starting value for x21
	mov	x22,	0			//0 is the starting value for TOP_INDEX
	mov	x23,		0			//0 is the starting value for x23
	mov	x28,		100			//100 is the starting value of x28

	
GenLoopI:						//the inner loop for generating the numbers
	bl	rand					//calls the rand function
	and	x0,		x0,		#0xF	//gets the last 4 bits of the random num and stores it in a1
	
	mul	x26,		x25,		x19	//x26 = x19 * x25
	add	x26,		x26,		x24	//x26 = (x19*x25) + x24
	lsl	x26,		x26,		2	//x26 = ((x19*x25) + x24)*4

	add	x27,		x29,		i_s	//adds the buffer to the stack pointer
	str	x0,		[x27,x26]		//stores the value of x0 in x27 + x26
	
	cmp	x0,		x21			//compeares the stored value to the current bigggest value
	b.lt	LessThen				//if it is less than it will skip to LessThan
	
	mov	x21,		x0			//Moves the stored value into x21
	mov	x22,	x24			//Sets the index to the current x24 value

LessThen:
	add 	x23,		x23,		x0	//add x0 to x23
	add	x24,		x24,		1	//adds one to x24

GenLoopTestI:						//inner GenLoop test
	
	cmp	x19,		x24			//compares x24 to x19
	b.gt	GenLoopI				//if it is greater thean it loops to the inner loop
	
	mul	x28,		x21,		x28	//x21 * 100
	sdiv	x28,		x28,		x23	//(x21*100)/x23

	add	x27,		x29,		s_s
	mov	x0,		8
	mul	x26,		x25,		x0
	str	x28,		[x27,x26]		//stores the freqpency at x1
	add	x26,		x26,		4	//adds 4 to the pointer
	str	x22,	[x27,x26]		//stores the index at x2

	add	x25,		x25,		1	//adds one to x25
	
GenLoopTestO:						//the outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	GenLoopO				//if it is greater then it will loop to the outer loop


	

	//start of the reading loop
	mov	x25,		0			//0 is the starting value for x25
	mov	x24,		0			//0 is the starting value for x24
	
	b	ReadLoopTestO				//jumps to the outer Read Loop Test

ReadLoopO:						//outer loop for Reading
	mov	x24,		0			//resets the value of x24 to 0
	mov	x21,		0			//0 is the starting value for x21
	mov	x22,	0			//0 is the starting value for TOP_INDEX
	mov	x23,		0			//0 is the starting value for x23
	mov	x28,		100			//100 is the starting value of x28

	
ReadLoopI:						//inner loop for Reading
	mul	x26,		x25,		x19	//x26 = x25 * x19
	add	x26,		x26,		x24	//x26 = (x25*x19) + x24
	lsl	x26,		x26,		2	//x26 = ((x25*x19) + x24)*4

	add	x27,		x29,		i_s	//adds the buffer to the stack pointer
	ldr	x1,		[x27,x26]		//loads the value of x1 in x27 + x26

	ldr	x0,		=str1			//loads the new number print string into x0
	bl	printf					//calls the printf function

	add	x24,		x24,		1	//increments x24 by 1

ReadLoopTestI:	

	cmp	x19,		x24			//Test for the inner loop
	b.gt	ReadLoopI				//if it is greater then it will jump to The inner loop

	add	x27,		x29,		s_s	//adds the struct buffer
	mov	x0,		8			//moves 8 into a temp spot
	mul	x26,		x25,		x0	//muls x25 by 8 to get the right row of the struct

	ldr	x1,		[x27,x26]		//stores the freqpency at x1
	add	x26,		x26,		4	//adds 4 to the pointer
	ldr	x2,		[x27,x26]		//stores the index at x2
		
	ldr	x0,		=str2			//Loads the newline string
	bl	printf					//calls printf

	add	x25,		x25,		1	//Adds 1 to x25
	
ReadLoopTestO:						//Outer loop test
	cmp	x20,		x25			//compares x20 to x25
	b.gt	ReadLoopO				//if it is greater than it will jump to the outer read loop

	b	done					//jumps to done

neError:						//print error then quit
	ldr	x0,		=aError			//loads the error message
	bl	printf					//prints the error message
	
done:
	ldp     x29, 		x30, 		[sp], 		dealloc      	// Restore FP and LR from stack
	ret                                     				// Return to caller (OS)


	.data
input:	.word 0
	
