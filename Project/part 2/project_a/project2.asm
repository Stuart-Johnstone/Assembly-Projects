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
		
	alloc = -16		//allocates space on the stack
	dealloc = -alloc		//deallocates the space on the stack
/*
Function: Check Cords
	Checks to see if a given cordinate is valid or not
Inputs: a0,	the cordinate
	a1,	the bomb radius being checked
	a2,	the array length in the same
Outputs:
	a0,	1 if the cordinate is valid, 0 if it isnt
*/
	.balign 4
	.global CheckCords
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
	