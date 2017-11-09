.data
	getLower: .asciiz "Input the start of the range: "
	getUpper: .asciiz "Input the end of the range: "
	swapValues: .asciiz "End of range < start of range -- swapping values\n"
	areAmicable: .asciiz " are amicable numbers\n"
	newLine: .asciiz "\n"
	range: .asciiz "Range of numbers: "
	dash: .asciiz "-----\n"
	numPairs: .asciiz "Pairs of amicable numbers = "
	dying: .asciiz "Unable to check non-positive values\nExiting ....."
	
.text
	jal readIn
	jal swap
	
readIn:	li $v0, 4		#Specify that we are printing a string
	la $a0, getLower	#Load the string
	syscall			
	li $v0, 5		#Load the starting bound to $v0
	syscall
	move $s0, $v0		#Move starting bound to $s0
	slt $t6, $zero, $s0	#If negative number, end program
	beq $t6, $zero die
	li $v0, 4		#Speify that we are printing a string
	la $a0, getUpper	#Load the string
	syscall			
	li $v0, 5		#Load the ending bound to $v0
	syscall
	move $s1, $v0		#Move the ending bound to $s1
	slt $t6, $zero, $s1	#If negative number, end program
	beq $t6, $zero die
	jr $ra
	
swap:	slt $t0, $s0, $s1	#If lower bound is less than upper bound
	bne $t0, $zero, calc	#We can go to the calculations now
	
	li $v0, 4		#Specify that we are printing a string
	la $a0, swapValues	#Load the string
	syscall			
	
	xor $s0, $s0, $s1	#Quick swapping...
	xor $s1, $s0, $s1	#...
	xor $s0, $s0, $s1	#...

calc:	sub $s2, $s1, $s0	#How many times we are looping
	add $s5, $zero, $zero	#If we have founda a value before
	add $s6, $zero, $zero	
	add $s7, $s0, $zero
	add $t5, $zero, $zero	#Count number of pairs

loop:	beq $s2, $zero, exit	#If we reached our max value...
	sub $s6, $s5, $s0	#See if we've done this before
	beq $s6, $zero, adjVal	#If we have, go to the next number
	add $a0, $s0 $zero	#Move our number to function argument
	jal sumDiv		#Calculate its total divisors	
	add $s3, $v0, $zero	#$s3 holds $s0's divisor sum
	beq $s3 $s0 adjVal
	add $a0, $s3, $zero	#Move result sumDivisors($s0) to function argument
	jal sumDiv		#Calculate the sumDivisors of the original return value
	add $s4, $v0 $zero	#$s4 holds the total of the divisors of $s0's sumDivisor total
	
	add $a0, $s0, $zero	#Moving values...
	add $a1, $s4, $zero	#...
	jal isAmic		#Test if the two are amicable
	beq $v0 $zero printy	#If yes, print them out
	
	
adjVal:	addi $s0, $s0, 1	#Add one to number to find sumDivisors of
	addi $s2, $s2, -1	#Subtract one from our counter
	j loop			#Loop again

	
printy:	add $s5, $s3, $zero	#$s5 is the bigger of the amicable pair
	addi $t5, $t5, 1	#Add one to our total counter of how many pairs we found

	li $v0, 1		#Lower number
	move $a0, $s4
	syscall

	li $a0, ' '
	la $v0, 11
	syscall	

	li $v0, 1		#Upper number
	move $a0, $s3
	syscall
	
	li $v0, 4		#Specify that we are printing a string
	la $a0, areAmicable	#Load the string
	syscall

	j adjVal
	
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
	
	
isAmic:	beq $a0 $a1 match	#If we have found a pair...
	addi $v0, $zero, 1	#If not, set set, $v0 to 1
	jr $ra			#Return
	
match:	add $v0, $zero, $zero	#Set $v0 to 0
	jr $ra			#Return

exit:	li $v0, 4
	la $a0, newLine		#Skip a line
	syscall	
	
	li $v0, 4
	la $a0, range		#"Range of numbers..."
	syscall	
	
	li $v0, 1
	move $a0, $s7		#Start of the range
	syscall
	
	li $a0, ' '
	la $v0, 11
	syscall	

	li $a0, '-'
	la $v0, 11
	syscall	

	li $a0, ' '
	la $v0, 11
	syscall	
	
	li $v0, 1
	move $a0, $s1		#End of range
	syscall
	
	li $v0, 4
	la $a0, newLine		#New line
	syscall	
	
	li $v0, 4
	la $a0, numPairs	#"Pairs of amicable numbers..."
	syscall	
	
	li $v0, 1
	move $a0, $t5		#Number of amicable nubmers found
	syscall
	
	li $v0, 4
	la $a0, newLine		#New line
	syscall	
	
	li $v0, 4
	la $a0, dash		#Row of dashes
	syscall	

	li $v0, 10		#End program
	syscall
	
die:	li $v0, 4		#Tell user they inputted a negative number
	la $a0, dying
	syscall	

	li $v0, 10		#Die
	syscall
