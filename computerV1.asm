	.data
        instr: .space 32
        arr: .word 1024
        str1:  .asciiz "Enter string(max 30 chars): "
        str2:  .asciiz "You wrote:\n"
        str3:  .asciiz "Total = \n"
 #####################################      
 #	Note      
 #	'+' ->  add
 #	'-' ->  subtract
 #	'*' ->  multiply
 #	'/' ->  divide
 #	'!' ->  Factorial
 #	'^' ->  power
 #
 # allow: + - / * ^ ! = 
 # -2^2
 # 2^2
 # 2^2!
 # -2^2!
 # illegal: float  (all number must be integer)
 # -2!
 # 2^-2!
 # -2^-2
 # 
 #####################################
 #
 #	Sample input:		output:
 #	-4^2=			-16
 #	1+2!*3!-4^2/2^0=	-3
 #	10*20/2!-10=		90
 #	-10*-20=		200
 #	10*-20=			-200
 #	0!=			1
 #	1+1=			2
 #	4-3=			1
 # 
 #####################################
       	#t0  = i
       	#t1  = j
       	#t2  = bool for if else
       	#t3  = bool for if else
       	#t4  = bool for if else
       	#t5  = bool for if else
       	#t8  = instr[]
       	#t9  = arr[]
       	#s0  = total
       	#s1  = IsNum
       	#s2  = IsSub
       	#s3  = n1 
       	#s4  = n2
       	#s5  = n3
       	#s6  = IsMulDiv
       	#s7  = arr.size
########################################
        .text
main:
        ####### initial
        move $s1, $zero #IsNum = false
        move $s2, $zero #IsSub = false
        #li $s2, 1 #IsSub = false
        move $s3, $zero #n1 = 0
        move $s4, $zero #n2 = 0
        move $s5, $zero #n3 = 0
        move $s6, $zero #IsMulDiv = false
        move $s7, $zero #arr.size = 0
        move $t0, $zero #i=0
        move $t1, $zero #j=0
        #######
	la $a0,str1 #Asking for string
        li $v0,4
        syscall
        ####### cin>>input
        la $a0, instr #load byte space into address
        li $a1, 30 # allot the byte space for string
        li $v0,8 #take in input
        syscall
        #######
	#for loop
	la $t0, instr
	la $t9, arr
for1: 	li $t7, '=' 
	lb $t8, 0($t0) #t8=instr[i] t0=i
        beq $t7,$t8 sum #if instr[i] = '=' jump to sum
	#############################################################
if1:   	
	#if (input[i] >= '0' && input[i] <= '9')
	sge $t2, $t8, '0' 
        sle $t3, $t8, '9'
        add $t4, $t2,$t3
       	bne $t4, 2, if2 
        #if (!IsNum)
	beq $s1, 1, ISNUM1
        beq $s1, $zero, nISNUM1
ISNUM1:	
	mul  $s3, $s3, 10 
	move $s4, $s3
	addi $s3, $t8, -48
	add  $s3, $s3, $s4 #n1 = n1 * 10 + input[i] - '0';
	j nextnum1
nISNUM1:
	addi $s3, $t8, -48 #n1 = input[i] - '0';
	j nextnum1
nextnum1:
	#if (!(input[i + 1] >= '0' && input[i + 1] <= '9'))
	lb   $t1, 1($t0)	#j = input[i+1]
	sge $t2, $t1, '0'
        sle $t3, $t1, '9'
        add $t4, $t2,$t3
       	bne $t4, 2, SUB1
	j outif1
	#if (IsSub)
SUB1:   beq $s2, 1, IsSUB1
        beq $s2, $zero, nIsSUB1
IsSUB1:	
	mul $s3, $s3, -1
	sw $s3, 0($t9)	
	addi $t9, $t9, 4 #x.push(-n1)
	addi $s7, $s7, 1
	j outif1
nIsSUB1:
	sw $s3, 0($t9)
	addi $t9, $t9, 4 #x.push(n1)
	addi $s7, $s7, 1
	j outif1
outif1:addi $s1, $zero, 1 #IsNum = true
        move $s6, $zero #IsMulDiv = false
	j for1end
	#############################################################
if2:	
	bne $t8, '+' if3
        move $s1, $zero #IsNum = false
        move $s2, $zero #IsSub = false
        move $s6, $zero #IsMulDiv = false
        j for1end
	#############################################################
if3:	
	bne $t8, '-' if4
        move $s1, $zero #IsNum = false
        addi $s2, $zero, 1 #IsSub = true
        move $s6, $zero #IsMulDiv = false
        j for1end
	#############################################################
if4:	
	bne $t8, '/' if5 
	addi $t9, $t9, -4 #x.pop()
	addi $s7, $s7, -1
	lw $s3, 0($t9) #n1=x.top()
	addi $t0,$t0,1 #i++
        move $s1, $zero #IsNum = false
        move $s2, $zero #IsSub = false
        #while (input[i] >= '0' && input[i] <= '9')
while4:	
	lb $t8, 0($t0) #t8=instr[i] t0=i
        #beq $t8, '-', IsSub4
        seq $t2, $t8, '-'
        seq $t3, $s6, $zero
        add $t4, $t2,$t3
       	beq $t4, 2, IsSub4
	sge $t2, $t8, '0' 
        sle $t3, $t8, '9'
        add $t4, $t2,$t3
       	bne $t4, 2, nextdiv1
       	beq $t4, 2, nextloop4
IsSub4: 
        addi $s2, $zero, 1 #IsSub = true
	addi $t0,$t0,1 #i++
	j while4
nextloop4:#if (!IsNum)
	beq $s1, 1, ISNUM4
        beq $s1, $zero, nISNUM4
ISNUM4:	
	mul  $s4, $s4, 10 
	move $s5, $s4
	addi $s4, $t8, -48
	add  $s4, $s4, $s5 #n2 = n2 * 10 + input[i] - '0';
        addi $s1, $zero, 1 #IsNum = true
	addi $t0,$t0,1 #i++
	addi $s6,$zero , 1
	j while4
nISNUM4:
	addi $s4, $t8, -48 #n2 = input[i] - '0';
        addi $s1, $zero, 1 #IsNum = true
	addi $t0,$t0,1 #i++
	addi $s6,$zero , 1
	j while4
nextdiv1:
	bne $t8, '^', nextdiv2
	addi $t0, $t0, 1	#i++
	lb $t7, 0($t0) #t7=input[i]
	beq $t7, '-' exit #2^-2 illegal
	addi $t7 ,$t7, -48
	beq $t7, $zero, zero4
	move $s5, $s4 # n3=n2
	addi $t7 ,$t7, -1
for4:	beq $t7,$zero, outfor4
	mul $s4, $s5, $s4 #n2*=n3
	addi $t7,$t7,-1
	j for4
zero4:	
	addi $s4,$zero,1 #n2=1
outfor4:
	addi $t0,$t0,1 #i++
nextdiv2:
	bne $t8, '!', SUB4
 	blt $s4 $zero exit #-2! illegal
 	beq $s4 $zero zeroloop4
 	move $s5, $s4 #tmp=n2
 	addi $t6, $zero, 1
loop4:	 	
	beq $t6, $s5 outloop4
 	mul $s4 ,$s4 , $t6 #n2*=j
 	addi $t6,$t6,1
 	j loop4
	#if (IsSub)
zeroloop4:
	addi $s4 ,$zero , 1
	j outloop4
outloop4:
        move $s1, $zero #IsNum = false
        addi $t0, $t0, 1 #i++
        
	#if (IsSub)
SUB4:   beq $s2, 1, IsSUB4
        beq $s2, $zero, nIsSUB4
IsSUB4:	
	div $s5, $s3, $s4 #n3=n1/n2
	mul $s5, $s5, -1
	sw $s5, 0($t9)	
	addi $t9, $t9, 4 #x.push(-n3)
	addi $s7, $s7, 1
	j out4
nIsSUB4:
	div $s5, $s3, $s4 #n3=n1/n2
	sw $s5, 0($t9)
	addi $t9, $t9, 4 #x.push(n3)
	addi $s7, $s7, 1
	j out4
out4:	move $s1, $zero	#IsNum = false
	move $s2, $zero	#Issub = false
	addi $t0,$t0,-1 #i--
	j for1end
	#############################################################
if5:	
	bne $t8, '*' if6 
	addi $t9, $t9, -4 #x.pop()
	addi $s7, $s7, -1
	lw $s3, 0($t9) #n1=x.top()
	addi $t0,$t0,1 #i++
        move $s1, $zero #IsNum = false
        #while (input[i] >= '0' && input[i] <= '9')
while5:	
	lb $t8, 0($t0) #t8=instr[i] t0=i
        seq $t2, $t8, '-'
        seq $t3, $s6, $zero
        add $t4, $t2,$t3
       	beq $t4, 2, IsSub5
	sge $t2, $t8, '0' 
        sle $t3, $t8, '9'
        add $t4, $t2,$t3
       	bne $t4, 2, nextmul1
       	beq $t4, 2, nextloop5
IsSub5: 
        addi $s2, $zero, 1 #IsSub = true
	addi $t0,$t0,1 #i++
	j while5
nextloop5:#if (!IsNum)
	beq $s1, 1, ISNUM5
        beq $s1, $zero, nISNUM5
ISNUM5:	
	mul  $s4, $s4, 10 
	move $s5, $s4
	addi $s4, $t8, -48
	add  $s4, $s4, $s5 #n2 = n2 * 10 + input[i] - '0';
        addi $s1, $zero, 1 #IsNum = true
	addi $t0,$t0,1 #i++
	addi $s6,$zero , 1
	j while5
nISNUM5:
	addi $s4, $t8, -48 #n2 = input[i] - '0';
        addi $s1, $zero, 1 #IsNum = true
	addi $t0,$t0,1 #i++
	addi $s6,$zero , 1
	j while5
nextmul1:
	bne $t8, '^', nextmul2
	addi $t0, $t0, 1	#i++
	lb $t7, 0($t0) #t7=input[i]
	beq $t7, '-' exit #2^-2 illegal
	addi $t7 ,$t7, -48
	beq $t7, $zero, zero5
	move $s5, $s4 # n3=n2
	addi $t7 ,$t7, -1
for5:	beq $t7,$zero, outfor5
	mul $s4, $s5, $s4 #n2*=n3
	addi $t7,$t7,-1
	j for5
zero5:	
	addi $s4,$zero,1 #n2=1
outfor5:
	addi $t0,$t0,1 #i++
nextmul2:
	bne $t8, '!', SUB5
 	blt $s4 $zero exit #-2! illegal
 	beq $s4 $zero zeroloop5
 	move $s5, $s4 #tmp=n2
 	addi $t6, $zero, 1
loop5:	 	
	beq $t6, $s5 outloop5
 	mul $s4 ,$s4 , $t6 #n2*=j
 	addi $t6,$t6,1
 	j loop5
	#if (IsSub)
zeroloop5:
	addi $s4 ,$zero , 1
	j outloop5
outloop5:
        move $s1, $zero #IsNum = false
        addi $t0, $t0, 1 #i++
        
SUB5:   beq $s2, 1, IsSUB5
        beq $s2, $zero, nIsSUB5
IsSUB5:	
	mul $s5, $s3, $s4 #n3=n1*n2
	mul $s5, $s5, -1
	sw $s5, 0($t9)	
	addi $t9, $t9, 4 #x.push(-n3)
	addi $s7, $s7, 1
	j out4
nIsSUB5:
	mul $s5, $s3, $s4 #n3=n1*n2
	sw $s5, 0($t9)
	addi $t9, $t9, 4 #x.push(n3)
	addi $s7, $s7, 1
	j out4
out5:	move $s1, $zero	#IsNum = false
	move $s2, $zero	#Issub = false
	addi $t0,$t0,-1 #i--
	j for1end
	#############################################################
if6:	
	bne $t8, '^' if7
	addi $t9, $t9, -4 #x.pop()
	addi $s7, $s7, -1
	lw $s3, 0($t9) #n1=x.top()
	addi $t0,$t0,1 #i ++
	lb $t7, 0($t0) #$t7 = input[i] 
	beq $t7, '-' exit #2^-2 illegal
	addi $t7 $t7 -48 #t7 = input[i] -'0'
	beq $t7,$zero, zero6 #if x^0  = 
	move $s4, $s3 #n2=n1
	bgez $s4 out6
	mul $s4,$s4,-1
out6:	addi $t7, $t7 -1
for6:	beq $t7,$zero, outfor6 
	mul $s3,$s4,$s3 # n1 *= n2;
	addi $t7, $t7 -1
	j for6
zero6:	
	addi $s3,$zero,1 #if x^0  = 1
outfor6:
	sw $s3, 0($t9)
	addi $t9, $t9, 4 #x.push(n1)
	addi $s7, $s7, 1
	move $s1, $zero	#IsNum = false
        move $s6, $zero #IsMulDiv = false
        j for1end
#############################################################
if7:
	bne $t8, '!' for1end
	addi $t9, $t9, -4 #x.pop()
	addi $s7, $s7, -1
	lw $s3, 0($t9) #n1=x.top()
	blt $s3, $zero exit #-2! illegal
	beq $s3, $zero zero7
	move $s4, $s3 #tmp = n1
	addi $t6,$zero, 1
loop7:
	beq $t6,$s4, out7
	mul $s3,$s3,$t6 
	addi $t6,$t6,1
	j loop7
zero7:
	addi $s3,$zero,1
	j out7
out7:
	sw $s3,0($t9)
	addi $t9, $t9, 4 #x.pop()
	addi $s7, $s7, 1
	move $s1,$zero
	move $s6,$zero
	
        ##############################
for1end:addi $t0,$t0,1	#i++
        j for1
sum:	
	la $a0,str3 #Asking for string
        li $v0,4
        syscall
        ###
	la $t0, arr
	move $t1, $zero
sumloop:
	beq $t1,$s7,coutsum
	lw $t2, 0($t0)
	add $s0, $s0, $t2
	addi $t1, $t1,1 
	addi $t0, $t0,4
	j sumloop
        ###
coutsum:move $a0, $s0
        li $v0,1 #end program
        syscall
	
exit:   li $v0,10 #end program
        syscall
