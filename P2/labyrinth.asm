.data
.eqv MAX 7
.eqv MAX_SQ 49
map:.word 0:MAX_SQ
visited:.word 0:MAX_SQ
dx:.word 1 0 -1 0
dy:.word 0 1 0 -1
.eqv ans $s7
.eqv ex $s6
.eqv ey $s5
.eqv n $s4
.eqv m $s3

.eqv i $t7
.eqv k $t6
.eqv x $t5
.eqv y $t4

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
.macro push(%reg)
	sw %reg ($sp)
	addi $sp $sp -4
.end_macro
.macro pop(%reg)
	addi $sp $sp 4
	lw %reg ($sp)
.end_macro
.macro getArr(%reg %label %index)
	sll $t9 %index 2
	lw %reg %label($t9)
.end_macro
.macro setArr(%reg %label %index)
	sll $t9 %index 2
	sw %reg %label($t9)
.end_macro

.text
readInt(n)
readInt(m)
li i 0
for1begin:
bge i n for1end
	li k 0
	for2begin:
	bge k m for2end
		readInt($t0)
		setMat($t0 map i k)
	addi k k 1
	j for2begin
	for2end:
addi i i 1
j for1begin
for1end:

readInt($t0)#sx
readInt($t1)#sy
readInt(ex)
readInt(ey)
addi ex ex -1
addi ey ey -1

addi $a0 $t0 -1
addi $a1 $t1 -1
jal dfs

printInt(ans)
Exit

dfs:
push(x)
push(y)
push(i)
push($ra)
move x $a0
move y $a1
	if1begin:
	seq $t0 x ex
	seq $t1 y ey
	and $t0 $t0 $t1
	beqz $t0 if1end
		addi ans ans 1
		j return
	if1end:
	
	if2begin:
	getMat($t0 visited x y)
	beqz $t0 if2end
		j return
	if2end:
	
	li $t0 1
	setMat($t0 visited x y)
	li i 0
	for3begin:
	bge i 4 for3end
		if3begin:
		.eqv newx $t0
		.eqv newy $t1
		getArr(newx dx i)
		add newx x newx
		getArr(newy dy i)
		add newy y newy
		
		blt newx 0 if3end
		bge newx n if3end
		blt newy 0 if3end
		bge newy m if3end
		getMat($t2 map newx newy)
		bnez $t2 if3end
		
			move $a0 newx
			move $a1 newy
			jal dfs
		if3end:
	addi i i 1
	j for3begin
	for3end:
	
	setMat($0 visited x y)
return:
pop($ra)
pop(i)
pop(y)
pop(x)
jr $ra
