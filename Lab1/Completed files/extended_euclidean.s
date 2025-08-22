.data
	input_msg_1:			.asciiz "Enter the number: "
	input_msg_2:			.asciiz "Enter the modulo: "
	output_msg_1:			.asciiz "Inverse not exist "
	output_msg_2:			.asciiz "Result: "
	newline: 	.asciiz "\n"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg_1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg_1	# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $t0, $v0      		# store the number input in $t0 (先存起來)

# print input_msg_2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg_2	# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall

# set arugument of procedure mod_inverse
	move    $a1, $v0      		# store the module input in $a1 
	move	$a0, $t0			# store the number input in $a0

# jump to procedure mod_inverse
	jal 	mod_inverse
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# determine the result
	addi	$t1, $zero, -1
	bne		$t0, $t1, main_L1

# print output_msg_1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg_1	# load address of string into $a0
	syscall                 	# run the syscall
	j		main_L2

main_L1:
# print output_msg_2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg_2	# load address of string into $a0
	syscall                 	# run the syscall

# print the result of procedure mod_inverse on the console interface
	li 		$v0, 1				# call system call: print int
	move 	$a0, $t0			# move value of integer into $a0
	syscall 					# run the syscall

main_L2:
# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure mod_inverse -----------------------------
# load argument (a, b) in ($a0, $a1), return value in $v0. 
.text
mod_inverse:
	add		$s0, $zero, $a0		# int old_r = a
	add		$s1, $zero, $a1		# int r = b
	addi	$s2, $zero, 1		# int old_s = 1
	addi	$s3, $zero, 0		# int s = 0
L2:
	beq		$s1, $zero, L1
	div		$s0, $s1			# 
	mflo	$t0					# q= old_r / r
	move	$t1, $s0			# 
	move	$s0, $s1			# 
	mul		$t2, $s1, $t0		# 
	sub		$s1, $t1, $t2		# old_r, r = r, old_r - (q * r)
	move	$t1, $s2			# 
	move	$s2, $s3			# 
	mul		$t2, $s3, $t0		# 
	sub		$s3, $t1, $t2		# old_s, s = s, old_s - (q * s)
	j		L2
L1:
	addi	$t0, $zero, 1
	beq		$s0, $t0, L3
	addi	$v0, $zero, -1
	jr		$ra
L3:
	add		$s2, $s2, $a1		#
	div		$s2, $a1			#
	mfhi	$v0					# (old_s + b) % b
	jr		$ra

# spim -file extended_euclidean.s