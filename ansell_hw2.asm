.data
inBuf:		.space	80		# input line
outBuf: 	.space 	80		# char types for the input line
prompt:		.asciiz	"\nEnter a new input line. \n”
Tabchar: 	.word 	0x0a, 6		# LF
		.word 	' ', 5
 		.word 	'#', 6
		.word 	'$', 4
		.word 	'(', 4 
		.word 	')', 4 
		.word 	'*', 3 
		.word 	'+', 3 
		.word 	',', 4 
		.word 	'-', 3 
		.word 	'.', 4 
		.word 	'/', 3 

		.word 	'0', 1
		.word 	'1', 1 
		.word 	'2', 1 
		.word 	'3', 1 
		.word 	'4', 1 
		.word 	'5', 1 
		.word 	'6', 1 
		.word 	'7', 1 
		.word 	'8', 1 
		.word 	'9', 1 

		.word 	':', 4 

		.word 	'A', 2
		.word 	'B', 2 
		.word 	'C', 2 
		.word 	'D', 2 
		.word 	'E', 2 
		.word 	'F', 2 
		.word 	'G', 2 
		.word 	'H', 2 
		.word 	'I', 2 
		.word 	'J', 2 
		.word 	'K', 2
		.word 	'L', 2 
		.word 	'M', 2 
		.word 	'N', 2 
		.word 	'O', 2 
		.word 	'P', 2 
		.word 	'Q', 2 
		.word 	'R', 2 
		.word 	'S', 2 
		.word 	'T', 2 
		.word 	'U', 2
		.word 	'V', 2 
		.word 	'W', 2 
		.word 	'X', 2 
		.word 	'Y', 2
		.word 	'Z', 2

		.word 	'a', 2 
		.word 	'b', 2 
		.word 	'c', 2 
		.word 	'd', 2 
		.word 	'e', 2 
		.word 	'f', 2 
		.word 	'g', 2 
		.word 	'h', 2 
		.word 	'i', 2 
		.word 	'j', 2 
		.word 	'k', 2
		.word 	'l', 2 
		.word 	'm', 2 
		.word 	'n', 2 
		.word 	'o', 2 
		.word 	'p', 2 
		.word 	'q', 2 
		.word 	'r', 2 
		.word 	's', 2 
		.word 	't', 2 
		.word 	'u', 2
		.word 	'v', 2 
		.word 	'w', 2 
		.word 	'x', 2 
		.word 	'y', 2
		.word 	'z', 2

		.word	0x5c, -1	# if you ‘\’ as the end-of-table symbol


.text
main:	
while:
	li $t1, 0		#i
	jal getline		#getline
for:
	

	lb  $t2, Tabchar+16	#get the pound sign for comp.
	lb  $t3, inBuf($t1)	#load the current char in the stream
	
	jal linsearch		#linsearch
	addi $t6,$t6,48		#convert to char
	sb $t6,outBuf($t1)	#store output of linsearch
	
	
	
	beq $t2, $t3,donefor	#check for # char
	beq $t2, 0x0a,donefor	#check for LF char
	beq $t2,$zero,donefor	#check for NULL char
	
	addi $t1, $t1, 1	#i++
	bge  $t1,80,donefor	#check the for loop condition
	b for			
donefor:
	bne $t1,$zero,noexit	#check if # was first char
	li $v0,10		
	syscall			#exit
noexit:
	li $t7,0
printloop:
	li $v0,11		
	lb $a0, outBuf($t7)	#load the char
	beq $a0, 53, skip	#dont print 5s
	syscall			#print
	b clear			
skip:
	li $a0, 32		#replace 5s with space
	syscall			#print
clear:
	sb $zero, outBuf($t7)	#clear the outBuf byte
	sb $zero, inBuf($t7)	#clear the inBuf byte
	
	addi $t7, $t7, 1	#increment the offset
	bne $a0,54,printloop	#keep printing till #
	b while
 

getline: 
	la	$a0, prompt	# Prompt to enter a new line
	li	$v0, 4
	syscall

	la	$a0, inBuf	# read a new line
	li	$a1, 80	
	li	$v0, 8
	syscall

	jr	$ra
	
linsearch:
	li $t4, 0		#track offset
rept:
	sll $t4,$t4,3		#get the offset
	lw $t5, Tabchar($t4)	#load the char from the table
	beq $t5,$t3,finsearch	#check if that char is correct
	sra $t4,$t4,3		#get back to i
	addi $t4,$t4,1		#i++
	b rept
finsearch:
	addi $t4,$t4,4		#get to the number part of the key val table
	lw $t6,Tabchar($t4)	#load the number
	jr $ra
