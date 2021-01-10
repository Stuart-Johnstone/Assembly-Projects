	
	//Assignment 4
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x25, x0-x2
	define(M,x19) 		//the regester for storing M
	define(N,x20)		//the regester for storing N
	define(TOP,x21)		//the regester for storing the biggest number
	define(TOP_Index,x22)	//the regester for storing the index of the biggest num
	define(SIZE,x23)	//the regester for storing the size of the document
	define(I,x24)		//counter for the i dimension of the list
	define(J,x25)		//counter for the j dimension of the list
	define(STOR,x26)	//storage regester, used for getting the index on the stack
	define(PTR,x27)		//storing the result of an add on the frame pointer
	define(FREQ,x28)	//stores the frequency 
	define(a0,x0)		//0th function regester
	define(a1,x1)		//1st function regester
	define(a2,x2)		//2nd funciton regester

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
	
	ldr	M,		[x1,8]			//loads the second arguement from argv
	ldr	N,		[x1,16]			//loads the third arguement from argv

	mov	a0,		M			//loads M into a0 
	bl 	atoi					//converts a0 from string into int
	mov	M,		a0			//moves a0 into M
	
	mov	a0,		N			//loads N into a0
	bl 	atoi					//converts a0 from string into int
	mov	N,		a0			//loads a0 into N

	//input validation
	cmp 	M,		4			//compares M and 4
	b.lt	neError					//if less than it throws an error
	
	cmp	M,		16			//compares M and 16
	b.gt	neError					//if less than it throws an error

	cmp 	N,		4			//compares N and 4
	b.lt	neError					//if less than it throws an error

	cmp	N,		16			//compares N and 16
	b.gt	neError					//if less than it throws an error
	


	//Start of the Generating loop 
	b	GenLoopTestO				//moves to the GenLoopTest for the inner loop

GenLoopO:						//the outer loop for generating the numbers
	mov	I,		0			//resets the value of I
	mov	TOP,		0			//0 is the starting value for TOP
	mov	TOP_Index,	0			//0 is the starting value for TOP_INDEX
	mov	SIZE,		0			//0 is the starting value for SIZE
	mov	FREQ,		100			//100 is the starting value of FREQ

	
GenLoopI:						//the inner loop for generating the numbers
	bl	rand					//calls the rand function
	and	a0,		a0,		#0xF	//gets the last 4 bits of the random num and stores it in a1
	
	mul	STOR,		J,		M	//STOR = M * J
	add	STOR,		STOR,		I	//STOR = (M*J) + I
	lsl	STOR,		STOR,		2	//STOR = ((M*J) + I)*4

	add	PTR,		x29,		i_s	//adds the buffer to the stack pointer
	str	a0,		[PTR,STOR]		//stores the value of a0 in PTR + STOR
	
	cmp	a0,		TOP			//compeares the stored value to the current bigggest value
	b.lt	LessThen				//if it is less than it will skip to LessThan
	
	mov	TOP,		a0			//Moves the stored value into TOP
	mov	TOP_Index,	I			//Sets the index to the current I value

LessThen:
	add 	SIZE,		SIZE,		a0	//add a0 to SIZE
	add	I,		I,		1	//adds one to I

GenLoopTestI:						//inner GenLoop test
	
	cmp	M,		I			//compares I to M
	b.gt	GenLoopI				//if it is greater thean it loops to the inner loop
	
	mul	FREQ,		TOP,		FREQ	//TOP * 100
	sdiv	FREQ,		FREQ,		SIZE	//(TOP*100)/SIZE

	add	PTR,		x29,		s_s
	mov	a0,		8
	mul	STOR,		J,		a0
	str	FREQ,		[PTR,STOR]		//stores the freqpency at a1
	add	STOR,		STOR,		4	//adds 4 to the pointer
	str	TOP_Index,	[PTR,STOR]		//stores the index at a2

	add	J,		J,		1	//adds one to J
	
GenLoopTestO:						//the outer loop test
	cmp	N,		J			//compares N to J
	b.gt	GenLoopO				//if it is greater then it will loop to the outer loop


	

	//start of the reading loop
	mov	J,		0			//0 is the starting value for J
	mov	I,		0			//0 is the starting value for I
	
	b	ReadLoopTestO				//jumps to the outer Read Loop Test

ReadLoopO:						//outer loop for Reading
	mov	I,		0			//resets the value of I to 0
	mov	TOP,		0			//0 is the starting value for TOP
	mov	TOP_Index,	0			//0 is the starting value for TOP_INDEX
	mov	SIZE,		0			//0 is the starting value for SIZE
	mov	FREQ,		100			//100 is the starting value of FREQ

	
ReadLoopI:						//inner loop for Reading
	mul	STOR,		J,		M	//STOR = J * M
	add	STOR,		STOR,		I	//STOR = (J*M) + I
	lsl	STOR,		STOR,		2	//STOR = ((J*M) + I)*4

	add	PTR,		x29,		i_s	//adds the buffer to the stack pointer
	ldr	a1,		[PTR,STOR]		//loads the value of a1 in PTR + STOR

	ldr	a0,		=str1			//loads the new number print string into a0
	bl	printf					//calls the printf function

	add	I,		I,		1	//increments I by 1

ReadLoopTestI:	

	cmp	M,		I			//Test for the inner loop
	b.gt	ReadLoopI				//if it is greater then it will jump to The inner loop

	add	PTR,		x29,		s_s	//adds the struct buffer
	mov	a0,		8			//moves 8 into a temp spot
	mul	STOR,		J,		a0	//muls J by 8 to get the right row of the struct

	ldr	a1,		[PTR,STOR]		//stores the freqpency at a1
	add	STOR,		STOR,		4	//adds 4 to the pointer
	ldr	a2,		[PTR,STOR]		//stores the index at a2
		
	ldr	a0,		=str2			//Loads the newline string
	bl	printf					//calls printf

	add	J,		J,		1	//Adds 1 to J
	
ReadLoopTestO:						//Outer loop test
	cmp	N,		J			//compares N to J
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
	
