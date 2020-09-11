.data
str:.space 20
.eqv n $s7
.eqv i $s6
.eqv ans $s5
.macro readInt(%reg)
	li $v0 5
	syscall
	move %reg $v0
.end_macro
.macro readChar(%reg)
	li $v0 12
	syscall
	move %reg $v0
.end_macro
.macro printInt(%reg)
	li $v0 1
	move $a0 %reg
	syscall
.end_macro
.macro getStr(%reg %index)
	lb %reg str(%index)
.end_macro
.macro setStr(%reg %index)
	sb %reg str(%index)
.end_macro
.macro Exit
	li $v0 10
	syscall
.end_macro
.text
li ans 1
readInt(n)
li i 0
for1begin:
bge i n for1end
	readChar($t0)
	setStr($t0 i)
addi i i 1
j for1begin
for1end:

li i 0
for2begin:
bge i n for2end
	move $t0 n
	sub $t0 $t0 i
	subi $t0 $t0 1
	getStr($t1 i)
	getStr($t2 $t0)
	if1begin:
	beq $t1 $t2 if1end
		li ans 0
	if1end:
addi i i 1
j for2begin
for2end:

printInt(ans)
Exit

