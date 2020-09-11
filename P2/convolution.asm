.data
.eqv MAX 10
.eqv MAX_SQ 100
a:.word 0:MAX_SQ
core:.word 0:MAX_SQ
.eqv m1 $s7
.eqv n1 $s6
.eqv m2 $s5
.eqv n2 $s4
.eqv m3 $s3
.eqv n3 $s2
.eqv i $t7
.eqv ij $t6
.eqv ki $t5
.eqv kj $t4
.eqv temp $t3
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
.macro getMat(%dest %label %i %j)
	move $t9 %i
	mul $t9 $t9 MAX
	add $t9 $t9 %j
	sll $t9 $t9 2
	lw %dest %label($t9)
.end_macro
.macro setMat(%src %label %i %j)
	move $t9 %i
	mul $t9 $t9 MAX
	add $t9 $t9 %j
	sll $t9 $t9 2
	sw %src %label($t9)
.end_macro
.macro printString(%str)
	.data
	STR:.asciiz %str
	.text
	li $v0 4
	la $a0 STR
	syscall
.end_macro
.text
readInt(m1)
readInt(n1)
readInt(m2)
readInt(n2)

li i 0
for1begin:
bge i m1 for1end
	li ij 0
	for2begin:
	bge ij n1 for2end
		readInt($t0)
		setMat($t0 a i ij)
	addi ij ij 1
	j for2begin
	for2end:
addi i i 1
j for1begin
for1end:

li i 0
for3begin:
bge i m2 for3end
	li ij 0
	for4begin:
	bge ij n2 for4end
		readInt($t0)
		setMat($t0 core i ij)
	addi ij ij 1
	j for4begin
	for4end:
addi i i 1
j for3begin
for3end:

sub m3 m1 m2
addi m3 m3 1
sub n3 n1 n2
addi n3 n3 1

li i 0
for5begin:
bge i m3 for5end
	li ij 0
	for6begin:
	bge ij n3 for6end
		li temp 0
		li ki 0
		for7begin:
		bge ki m2 for7end
			li kj 0
			for8begin:
			bge kj n2 for8end
				add $t0 i ki
				add $t1 ij kj
				getMat($t2 a $t0 $t1)
				getMat($t1 core ki kj)
				mul $t0 $t1 $t2
				add temp temp $t0
			addi kj kj 1
			j for8begin
			for8end:
		addi ki ki 1
		j for7begin
		for7end:
		printInt(temp)
		printString(" ")
	addi ij ij 1
	j for6begin
	for6end:
	printString("\n")
addi i i 1
j for5begin
for5end:
Exit

