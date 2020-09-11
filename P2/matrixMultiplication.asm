.data
.eqv n $s7
.eqv i $s6
.eqv ij $s5
.eqv k $s4
.eqv MAX 8
a:.word 0:64
b:.word 0:64
ans:.word 0:64
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
.macro printString(%str)
	.data
	STR:.asciiz %str
	.text
	li $v0 4
	la $a0 STR
	syscall
.end_macro
.macro Exit
	li $v0 10
	syscall
.end_macro
.macro getMat(%dest,%label,%x,%y)
	move $t9 %x
	mul $t9 $t9 MAX
	add $t9 $t9 %y
	sll $t9 $t9 2
	lw %dest %label($t9)
.end_macro
.macro setMat(%src,%label,%x,%y)
	move $t9 %x
	mul $t9 $t9 MAX
	add $t9 $t9 %y
	sll $t9 $t9 2
	sw %src %label($t9)
.end_macro

.text
readInt(n)
li i 0
for_begin:
bge i n for_end
	li ij 0
	for_1_begin:
	bge ij n for_1_end
		readInt($t0)
		setMat($t0,a,i,ij)
		addi ij ij 1
	j for_1_begin
	for_1_end:
	addi i i 1
j for_begin
for_end:

li i 0
for_2_begin:
bge i n for_2_end
	li ij 0
	for_3_begin:
	bge ij n for_3_end
		readInt($t0)
		setMat($t0,b,i,ij)
		addi ij ij 1
	j for_3_begin
	for_3_end:
	addi i i 1
j for_2_begin
for_2_end:

li i 0
for_4_begin:
bge i n for_4_end
	li ij 0
	for_5_begin:
	bge ij n for_5_end
		li k 0
		for_6_begin:
		bge k n for_6_end
			getMat($t0,ans,i,ij)
			getMat($t1,a,i,k)
			getMat($t2,b,k,ij)
			mul $t1 $t1 $t2
			add $t0 $t0 $t1
			setMat($t0,ans,i,ij)
			addi k k 1
		j for_6_begin
		for_6_end:
		getMat($t0,ans,i,ij)
		printInt($t0)
		printString(" ")
		addi ij ij 1
	j for_5_begin
	for_5_end:
	printString("\n")
	addi i i 1
j for_4_begin
for_4_end:
Exit
