	//Assignment 2 no macros
	//Stuart Johnsotne
	//CPSC 355

	
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
	mov	x22,	1				//moves 1 into the counter regester
	mov	x21,	0				//moves 0 into the sum regester
	mov	x20,	10				//moves 10 into the smallest number regester
	mov	x19,	0				//moves 0 into the largest number regester
	//prints the first string for the program
	ldr	x0,	 	=str1			//loads the register with first string
	bl	printf					//prints the first string


	//takes input
	ldr     x0,	 	=str4			// Load format string for input
	ldr	x1, 		=input			// Load the address of the variable input
	bl      scanf					// scanf() argument
	ldr	x24,		=input			// loads the adress of the input in x24
	ldr	x24,		[x24]			// saves the value of the input in x24

	//checks to see if the input is less than or greater then 5 or 29
	//if it is then it goes back to start to take input again
	cmp	x24,		4			// checks to see if input is less then 5
	b.le	start					// if it is then it jumps to the top again and resets
	cmp	x24,		21			// checks to see if input is greater than 20
	b.ge	start					// if it is then it jumps to the top again and resets

//jumps to the test after the loop

preTest:
	cmp	x22,	x24				// compares the counter to n
	b.le	loop					// jumps to the loop if it is smaller than or equal
	b	after					// jumps to after if it is greater


//the body of the loop
loop:
	bl	rand					//calls the rand function and saves the number in x0
	and	x1,		x0,	0x0F		//does bitwise and on the random number, max of 15

	cmp	x1,		10			//checks to see if the number is greater then 10
	b.ge	loop 					//if the number is greater then 10 then it restarts the loop

	mov	x23,		x1			//stores the value of x1 in the temp regester
	
	cmp	x19,		x23			//compares the largest to temp
	b.gt	elif					//if temp is smaller then the largest it skips to elif
	mov	x19,		x23			//else it moves the value of temp into largest
elif:	
	cmp	x20,		x23			//compares the smallest to temp
	b.lt	else					//if it is bigger then it skips to else
	mov	x20,		x23			//else it moves the value of temp into smallest
	
else:
	ldr	x0,		=str4			//loads the number print string
	add	x21,		x21,	x23		//adds temp to the sum
	bl	printf					//prints the number
	
	add	x22, 		x22, 	1		//increments the counter
	b	preTest

//the pretest for the while loop
after:
	ldr	x0,		=nl
	bl	printf

	ldr	x0,		=str5			// loads the string for printing the sum in x0
	mov	x1,		x21			// loads the sum into x1
	bl	printf					// prints the string

	mov	x23,		100			// moves 100 into the temp
	mul	x19,	x19,	x23			// multiplies the largest by temp
	mul	x20,	x20,	x23			// multiplies the smallest by temp
	udiv	x19,	x19,	x21			// divides the largest by the sum
	udiv	x20,	x20,	x21			// divides the smallest by the sum
	
	ldr	x0,		=str2			// loads the string for the largest num
	mov	x1,		x19			// loads largest into the x1
	bl	printf					// prints

	ldr	x0,		=str3			// loads the string for the smallest num
	mov	x1,		x20			// loads smallest into x1
	bl	printf					// prints

	b	done					// jumps to done

done:	
	ldp     x29, 	x30, 	[sp], 	16              // Restore FP and LR from stack
	ret                                     // Return to caller (OS)


	.data
input:	.word 0					// global variable for input
	
