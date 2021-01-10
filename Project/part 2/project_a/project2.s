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
	
	
	
	
		
	alloc = -16		//allocates space on the stack
	dealloc = -alloc		//deallocates the space on the stack
/*
Function: Check Cords
	Checks to see if a given cordinate is valid or not
Inputs: x0,	the cordinate
	x1,	the bomb radius being checked
	x2,	the array length in the same
Outputs:
	x0,	1 if the cordinate is valid, 0 if it isnt
*/
	.balign 4
	.global CheckCords
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
	