.data
	input_msg:	.asciiz "Enter a number: "
	output_msg:	.asciiz "Reversed number: "
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
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure reverseNumber)

# jump to procedure reverseNumber
	jal 	reverseNumber
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg		# load address of string into $a0
	syscall                 	# run the syscall

# print the result of procedure reverseNumber on the console interface
	li 		$v0, 1				# call system call: print int
	move 	$a0, $t0			# move value of integer into $a0
	syscall 					# run the syscall

# print a newline at the end
	li		$v0, 4				# call system call: print string
	la		$a0, newline		# load address of string into $a0
	syscall						# run the syscall

# exit the program
	li      $v0, 10				# call system call: exit
	syscall	       				# run the syscall

#------------------------- procedure reverseNumber -----------------------------
# load argument n in $a0, return value in $v0. 
.text
reverseNumber:	
    move     $t0, $a0           # load n into $t0
    li       $s0, 0             # n_reverse 
    li       $t1, 10            # mod = 10
L1:
    beq     $zero, $t0, L2
    div     $t0, $t1            # n / 10
    mfhi    $t2                 # $t2 = n % 10
    mflo    $t0                 # $t0 = n / 10
    mul     $s0, $s0, $t1       # n_reverse *= 10
    add     $s0, $s0, $t2       # n_reverse += n % 10
    j	    L1
L2:
    move    $v0, $s0
    jr      $ra

# spim -file reverse_number.s
    



