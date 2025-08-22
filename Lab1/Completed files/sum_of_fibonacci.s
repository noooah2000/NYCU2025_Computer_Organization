.data
	input_msg:	.asciiz "Please input a number: "
	output_msg:	.asciiz "The sum of Fibonacci is "
	newline: 	.asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure fibonacciSum)

# jump to procedure fibonacciSum
	jal 	fibonacciSum
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg		# load address of string into $a0
	syscall                 	# run the syscall

# print the result of procedure fibonacciSum on the console interface
	li 		$v0, 1				# call system call: print int
	move 	$a0, $t0			# move value of integer into $a0
	syscall 					# run the syscall

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure fibonacciSum -----------------------------
# load argument n in $a0, return value in $v0. 
.text
fibonacciSum:
	addi	$sp, $sp, -8
	sw		$a0, 0($sp)
	sw		$ra, 4($sp)
	li		$s0, 0				# sum = 0
	li		$s1, 0				# i = 0
L1:
	slt		$t0, $a0, $s1		
	bne		$zero, $t0, L2		# if (i > n): goto L2
	move	$a1, $s1			# load i to $a1
	jal		fibonacci			# call fibonacci(i)
	add		$s0, $s0, $v0		# sum += fibonacci(i)
	addi	$s1, $s1, 1			# i++
	j		L1
L2:
	move	$v0, $s0
	lw		$a0, 0($sp)
	lw		$ra, 4($sp)
	addi	$sp, $sp, 8
	jr		$ra

#------------------------- procedure fibonacci -----------------------------
# load argument n in $a1, return value in $v0. 
.text
fibonacci:
	addi	$sp, $sp, -12
	sw		$a1, 0($sp)
	sw		$ra, 4($sp)
	sw		$s0, 8($sp)
	move	$t0, $a1			# load n into $t0
	bne		$t0, 0, L3
	add		$v0, $zero, $zero	# if n == 0: return 0
	addi	$sp, $sp, 12
	jr		$ra
L3:
	bne		$t0, 1, L4
	addi	$v0, $zero, 1		# if n == 1: return 1
	addi	$sp, $sp, 12
	jr		$ra
L4:
	addi	$a1, $a1, -1
	jal		fibonacci			# call fibonacci(n-1)
	add		$s0, $v0, $zero		# save the result of fibonacci(n-1)
	addi	$a1, $a1, -1
	jal		fibonacci			# call fibonacci(n-2)
	add		$v0, $s0, $v0		# return fibonacci(n-1) + fibonacci(n-2)
	lw		$a1, 0($sp)			
	lw		$ra, 4($sp)
	lw		$s0, 8($sp)
	addi	$sp, $sp, 12
	jr		$ra

# spim -file sum_of_fibonacci.s