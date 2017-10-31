.data
	getLower: .asciiz "Input the start of the range: "
	getUpper: .asciiz "Input the end of the range: "
	swapValues: .asciiz "End of range < start of range -- swapping values"
	
.text
	li $v0, 4		#Specify that we are printing a string
	la $a0, getLower	#Load the string
	syscall			
	li $v0, 5		#Load the starting bound to $v0
	syscall
	move $s0, $v0		#Move starting bound to $s0
	li $v0, 4		#Speify that we are printing a string
	la $a0, getUpper	#Load the string
	syscall			
	li $v0, 5		#Load the ending bound to $v0
	syscall
	move $s1, $v0		#Move the ending bound to $s1
	
	slt $t0, $s0, $s1	#If lower bound is less than upper bound
	bne $t0, $zero, calc	#We can go to the calculations now
	
	li $v0, 4		#Specify that we are printing a string
	la $a0, swapValues	#Load the string
	syscall			
	
	xor $s0, $s0, $s1		#Quick swapping...
	xor $s1, $s0, $s1		#...
	xor $s0, $s0, $s1		#...
	
	
calc:	li $v0, 1
	add $a0, $s0, $zero
	syscall
	
	li $v0, 1
	add $a0, $s1, $zero
	syscall
	

	li $v0, 10		#Exit the program
	syscall
