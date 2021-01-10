
	//Assignment 2 with macros
	//Stuart Johnsotne
	//CPSC 355 

	//macros for defining the regesters between x19 and and x24, x0-x2
	define(largest, x19)		//used for storing the largest frequency
	define(smallest, x20)		//used for storing the smallest frequency
	define(sum, x21)		//used for storing the sum
	define(counter, x22)		//used for tracking the current exection of the while loop
	define(stor, x23)		//used for storing the random number
	define(N, x24)			//used for storing the user input
	define(arg0, x0)		//macro for function regestry 0
	define(arg1, x1)		//macro for function regestry 1
	define(arg2, x2)		//macro for function regestry 2


	//Define the format of the string you'll use to output the result
str1:	   .string "\nplease input a number between 5 and 20 \n"	//first print statement for user input
str2:	   .string "LARGEST frequency %d\n"				//Largest frequency string
str3:	   .string "SMALLEST frequency %d\n"				//Smallest frequency string
str4:	   .string "%d"							//number printing string
str5:	   .string "The SUM of the list is %d\n"			//Total Sum string
nl:	   .string "\n"							//new line string

	.balign 4                               // Instructions must be word aligned
	.global main                            // Make "main" visible to the OS and start the execution
//saves system vars
main:
	stp     x29, 	x30,	[sp, -16]!            // Save FP and LR to stack
	mov     x29, 		sp                         // Update FP to the scurrent SP
// the start of the program
start:	
	mov	counter,	1			//starts the counter with 1 already in it
	mov	sum,		0			//starts the sum at 0
	mov	smallest,	10			//starts the smallest with 10 so that it will be imidiately reset on first comparison
	mov	largest,	0			//starts the largest with 0 so that it will be imidiately reset on first comparison
	//prints the first string for the program
	ldr	arg0,	 	=str1			//loads the register for the first string
	bl	printf					//prints the loaded funciton regs


	//takes input
	ldr     arg0,	 	=str4			// Load format string for input
	ldr	arg1, 		=input			// Load the address of the variable input as the 2nd
	bl      scanf					// scanf() argument
	ldr	N,		=input			// loads the adress of the input as a var
	ldr	N,		[N]			// saves the value of the input as a var

	//checks to see if the input is less than or greater then 5 or 29
	//if it is then it goes back to start to take input again
	cmp	N,		4			// checks to see if input is less then 5
	b.le	start					// if it is then it jumps to the start
	cmp	N,		21			// checks to see if input is greater than 20
	b.ge	start					// if it is then it jumps to the start

	//jumps to the test after the loop
	b	preTest					//goto the pretest

//the body of the loop
loop:
	bl	rand					//calls the rand function and saves the number in x0
	and	arg1,		arg0,	0x0F		//does bitwise and on the random number, max of 15

	cmp	arg1,		10			//checks to see if the numebr is greater then 10. loops if it is
	b.ge	loop 					//if the number is greater then 10 then it restarts the loop

	mov	stor,		arg1			//moves the value of function variable 1 into the stor variable
	
	cmp	largest,	stor			//checks to see if stor is larger then largest
	b.gt	elif					//uses complementary logic to check if it is greater than
	mov	largest,	stor			//if it is then stor becomes the new largest
elif:	
	cmp	smallest,	stor			//checks to see if stor is smaller then smallest
	b.lt	else					//uses complementary logic ot check if it is less than
	mov	smallest,	stor			//if it is then it moves the value of stor into smallest
	
else:
	ldr	arg0,		=str4			//prints the number	
	add	sum,		sum,		stor	//adds the random number to the sum
	bl	printf					//prints the number
	
	add	counter, 	counter, 	1	//increments the counter


//the pretest for the while loop
preTest:
	cmp	counter, 	N			// checks to see if the counter is equal to the inputed numb
	b.le	loop					// jumps to the top of the loop body

	ldr	arg0,		=nl			// loads the newline string into x0
	bl	printf					// prints the new line

	ldr	arg0,		=str5			// loads the string for printing the sum in x0
	mov	arg1,		sum			// loads the sum into x1
	bl	printf					// prints the string

	mov	stor,		100			// moves 100 into stor to be used in multiplication
	mul	largest,	largest,	stor	// multiplies largest by 100
	mul	smallest,	smallest,	stor	// multiplies smallest by 100
	udiv	largest,	largest,	sum	// divides largest by sum
	udiv	smallest,	smallest,	sum	// divides smallest by sum
	
	ldr	arg0,		=str2			// loads the string for the largest num
	mov	arg1,		largest			// loads largest into arg1
	bl	printf					// prints

	ldr	arg0,		=str3			// loads the string for the smallest num
	mov	arg1,		smallest		// loads smallest into arg1
	bl	printf					// prints 

	b	done					// jumps to done

done:	
	ldp     x29, 	x30, 	[sp], 	16              // Restore FP and LR from stack
	ret                                     // Return to caller (OS)


	.data
input:	.word 0
	
