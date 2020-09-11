.data
symbol:.word 0:7
array:.word 0:7
.eqv n $s7
.eqv i $s6
.eqv index $s5
.macro readInt(%reg)
	li $v0 5
	syscall
	move %reg $v0
.end_macro
.macro printInt(%reg)
	li $v0 1
	move $a0 %reg
	syscall
.end_macro
.macro Exit
	li $v0 10
	syscall
.end_macro
.macro printString(%str)
	.data
	STR:.asciiz %str
	.text
	li $v0 4
	la $a0 STR
	syscall
.end_macro
.macro getArr(%reg %label %index)
	sll $t9 %index 2
	lw %reg %label($t9)
.end_macro
.macro setArr(%reg %label %index)
	sll $t9 %index 2
	sw %reg %label($t9)
.end_macro
.macro push(%reg)
	sw %reg ($sp)
	addi $sp $sp -4
.end_macro
.macro pop(%reg)
	addi $sp $sp 4
	lw %reg ($sp)
.end_macro

.text
readInt(n)
li $a0 0
jal FullArray
Exit

FullArray:
push(i)
push($ra)
push(index)
	move index $a0
	if1begin:
	blt index n if1end
		li i 0
		for1begin:
		bge i n for1end
			getArr($t0 array i)
			printInt($t0)
			printString(" ")
		addi i i 1
		j for1begin
		for1end:
		printString("\n")
		j return
	if1end:
	
	li i 0
	for2begin:
	bge i n for2end
		if2begin:
		getArr($t0 symbol i)
		bnez $t0 if2end
			addi $t0 i 1
			setArr($t0 array index)
			li $t0 1
			setArr($t0 symbol i)
			addi $a0 index 1
			jal FullArray
			setArr($0 symbol i)
		if2end:
	addi i i 1
	j for2begin
	for2end:
	
return:
pop(index)
pop($ra)
pop(i)
jr $ra
