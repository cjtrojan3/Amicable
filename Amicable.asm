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
	
	xor $s0, $s0, $s1	#Quick swapping...
	xor $s1, $s0, $s1	#...
	xor $s0, $s0, $s1	#...
	
	
calc:	#li $v0, 1
	#add $a0, $s0, $zero
	#syscall
	
	#li $v0, 1
	#add $a0, $s1, $zero
	#syscall
	
	sub $s2, $s1, $s0	#How many times we are looping

loop:	beq $s2, $zero, exit	#If we reached our max value...
	add $a0, $s0 $zero	#Move our number to function argument
	jal sumDiv		#Calculate its total divisors	
	add $s3, $v0, $zero	#$s3 holds $s0's divisor sum
	
	add $a0, $s3, $zero	#Move result sumDivisors($s0) to function argument
	jal sumDiv
	
	add $s4, $v0 $zero	#$s4 holds the total of the divisors of $s0's sumDivisor total
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	j exit
	
sumDiv:	add $t0, $a0, $zero	#Move argument to temp address
	addi $t1, $zero, 2	#$t1 = 2
	div $t0, $t1		#Divide our number by two...
	mflo $t1		#...
	addi $t1, $t1, 1	#...and add 1
	addi $t3, $zero, 1	#Start looking for divisors at 1
	add $v0, $zero, $zero	#Total sum starts at 0
loopy: 	beq $t1, $zero, donSum	#Once our counter reaches 0, we have found all divisors from 1 to (number/2)+1
	div $t0, $t3		#Divide number by divisor
	mfhi $t4		#Take the remainder
	beq $t4, $zero, addDat	#If remainder is zero, $t3 divides our number
	j reset			#Adjust counter variables
reset:	addi $t3, $t3, 1	#Add one to the divisor
	addi $t1, $t1, -1	#Subtract one from the counter
	j loopy			#Loop again
addDat:	add $v0, $v0, $t3	#Add the functioning divisor to our running total
	j reset			#Adjust counter variables
donSum:	jr $ra			#Return - $v0 should have the total sum of divisors
	
	

exit:	li $v0, 10		#Exit the program
	syscall
