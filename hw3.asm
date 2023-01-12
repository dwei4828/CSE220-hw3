######### FULL NAME ##########
######### SBU ID ##########
######### NET ID ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
    move $t0, $a0
    move $t1, $a1
    li $t7, 10
    li $t8, 13
    li $a1, 0
    li $a2, 0
    addi $v0, $0, 13
    syscall
    bltz $v0, error
    move $a0, $v0
    move $a1, $t1
    li $a2, 1
    addi $v0, $0, 14
    syscall 
    lbu $t2, 0($a1) 
    addi $v0, $0, 14
    syscall
    lbu $t3, 0($a1)
    beq $t3, $t8, skip2
    beq $t3, $t7, skip1
    skip2:
    	addi $v0, $0, 14
        syscall
    skip1:
    	addi $v0, $0, 14
    	syscall
    lbu $t3, 0($a1)
    li $t5, 49
    li $t9, 57
    blt $t2, $t5, error #check row and col
    bgt $t2, $t9, error
    blt $t3, $t5, error
    bgt $t3, $t9, error
    addi $t5, $t5, -1 
    sub $t2, $t2, $t5
    sub $t3, $t3, $t5
    mul $t4, $t2, $t3 #find length of array
    move $t6, $t1   #set another starting address of buffer
    addi $t6, $t6 , 4
    sw $t3, 0($t6)
    move $a1, $t1
    addi $t6, $t6, 4
    move $t0, $t2
    li $t3, 0
    
init_loop:
    li $a2, 1
    addi $v0, $0, 14
    syscall 
    lbu $t2, 0($t1)
    beq $t2, $t7, skip
    beq $t2, $t8, skip
    blt $t2, $t5, error
    bgt $t2, $t9, error
    sub $t2, $t2, $t5
    sw $t2, 0($t6)
    addi $t6, $t6, 4
    addi $t3, $t3, 1
    beq $t3, $t4, success
    j init_loop
    
done:
 jr $ra

skip:
    j init_loop
    
success:
    sw $t0, 0($t1)
    addi $v0, $0, 16
    syscall
    li $v0, 1
    jr $ra

error: 
    li $t2, 0
    li $t3, 83
    li $t4, 0
    loop:
    	sw $t2, 0($t1)
    	addi $t1, $t1, 4
    	addi $t4, $t4, 1
    	bne $t4, $t3, loop
    addi $v0, $0, 16
    syscall
    li $v0, -1
    jr $ra



.globl write_file
write_file:
    move $t0, $a1
    li $a2, 0
    li $a1, 1
    addi $v0, $0, 13
    syscall
    
    move $a0, $v0
    move $a1, $t0
    lw $t1, 0($a1)
    lw $t2, 4($a1)
    addi $t4, $t1, 48
    addi $t5, $t2, 48 # get char
    mul $t3, $t1, $t2  #get total length
    
    li $t7, 10
    addi $sp, $sp, -4
    sw $t7, 0($sp)
    
    sw $t4, 0($a1)
    li $a2, 1
    addi $v0, $0, 15
    syscall
    addi $t0, $t0, 4
    
    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    move $a1, $t0
    sw $t5, 0($a1)
    addi $v0, $0, 15
    syscall

    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    addi $t0, $t0, 4
    li $t4, 0 #column counter
    li $t5, 0 #counter
    
    writeLoop:
        lw $t8, 0($t0)
        move $a1, $t0
        addi $t8, $t8, 48
        sw $t8, 0($a1)
        addi $v0, $0, 15
    	syscall
    	
        addi $t0, $t0, 4
        addi $t4, $t4, 1
        addi $t5, $t5, 1
        bne $t4, $t2, next
        
        move $a1, $sp
        addi $v0, $0, 15
   	syscall
   	li $t4, 0
   	
    next:
        beq $t5, $t3, finishWrite
        j writeLoop
    
finishWrite:
    addi $v0, $0, 16
    syscall
    addi $sp, $sp, 4
    jr $ra
    
    
.globl rotate_clkws_90
rotate_clkws_90:
    move $t9, $a1
    move $a1, $a0
    move $a0, $t9
    
    move $t0, $a1
    li $a2, 0
    li $a1, 1
    addi $v0, $0, 13
    syscall
    
    move $a0, $v0
    move $a1, $t0
    lw $t1, 0($a1)
    lw $t2, 4($a1)
    addi $t4, $t1, 48
    addi $t5, $t2, 48 # get char
    mul $t3, $t1, $t2  #get total length
    
    li $t7, 10
    addi $sp, $sp, -4
    sw $t7, 0($sp)
    
    sw $t5, 0($a1)
    li $a2, 1
    addi $v0, $0, 15
    syscall
    addi $t0, $t0, 4
    
    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    move $a1, $t0
    sw $t4, 0($a1)
    addi $v0, $0, 15
    syscall

    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    addi $t0, $t0, 4
    li $t4, 1 #row counter
    li $t5, 0 #col counter
    move $a1, $t0
    colLoop:
	
    	rowLoop:
    	    sub $t7, $t1, $t4
    	    mul $t7, $t7, $t2
    	    add $t7, $t7, $t5
    	    li $t8, 4
    	    mul $t7, $t7, $t8
    	    add $a1, $a1, $t7
    	    lw $t9, 0($a1)
    	    addi $t9, $t9, 48
    	    sw $t9, 0($a1)
    	    addi $v0, $0, 15
    	    syscall
    	    sub $a1, $a1, $t7
    	    addi $t4, $t4, 1
    	    addi $t6, $t4, -1
    	    bne $t6, $t1, rowLoop
    	    
    	move $t0, $a1
    	move $a1, $sp
    	addi $v0, $0, 15
    	syscall
    	move $a1, $t0
    	
	addi $t5, $t5, 1
	li $t4, 1
    	beq $t5, $t2, finishRotate
	j colLoop
	
    finishRotate:
        addi $v0, $0, 16
   	syscall
  	addi $sp, $sp, 4
    	jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
    addi $sp, $sp, -12
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $ra, 8($sp)
    
    jal rotate_clkws_90
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    
    move $t9, $a0
    move $a0, $a1
    move $a1, $t9
    jal initialize
     
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    jal rotate_clkws_90

    lw $ra, 8($sp) 
    addi $sp, $sp, 12
    jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
    addi $sp, $sp, -12
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $ra, 8($sp)
    
    jal rotate_clkws_180
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    
    move $t9, $a0
    move $a0, $a1
    move $a1, $t9
    jal initialize
    
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    jal rotate_clkws_90

    lw $ra, 8($sp) 
    addi $sp, $sp, 12
    jr $ra

.globl mirror
mirror:
    move $t9, $a1
    move $a1, $a0
    move $a0, $t9
    
    move $t0, $a1
    li $a2, 0
    li $a1, 1
    addi $v0, $0, 13
    syscall
    
    move $a0, $v0
    move $a1, $t0
    lw $t1, 0($a1)
    lw $t2, 4($a1)
    addi $t4, $t1, 48
    addi $t5, $t2, 48 # get char
    mul $t3, $t1, $t2  #get total length
    
    li $t7, 10
    addi $sp, $sp, -4
    sw $t7, 0($sp)
    
    sw $t4, 0($a1)
    li $a2, 1
    addi $v0, $0, 15
    syscall
    addi $t0, $t0, 4
    
    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    move $a1, $t0
    sw $t5, 0($a1)
    addi $v0, $0, 15
    syscall

    move $a1, $sp
    addi $v0, $0, 15
    syscall
    
    addi $t0, $t0, 4
    li $t4, 0 #row counter
    li $t5, 1 #col counter
    move $a1, $t0
    
    mirrorRowLoop:
    
    mirrorColLoop:
        mul $t6, $t4, $t2
    	sub $t7, $t2, $t5
    	add $t7, $t7, $t6
	li $t8, 4
	mul $t7, $t7, $t8
	add $a1, $a1, $t7
	lw $t9, 0($a1)
	addi $t9, $t9, 48
    	sw $t9, 0($a1)
        addi $v0, $0, 15
        syscall
        sub $a1, $a1, $t7
    	addi $t5, $t5, 1
    	addi $t6, $t5, -1
    	bne $t6, $t2, mirrorColLoop
    	
    	move $t0, $a1
    	move $a1, $sp
    	addi $v0, $0, 15
    	syscall
    	move $a1, $t0
    	
	addi $t4, $t4, 1
	li $t5, 1
    	beq $t4, $t1, finishMirror
	j mirrorRowLoop
 
	finishMirror:
	    addi $v0, $0, 16
   	    syscall
  	    addi $sp, $sp, 4
    	    jr $ra

.globl duplicate
duplicate:
    move $t0, $a0
    lw $t1, 0($a0)
    lw $t2, 4($a0)
    addi $t0, $t0, 8
    
    li $t3, 0  #row counter
    li $t4, 0  #col counter
    li $t9, 0 # num counter
    calcLoop:
    	 move $t5, $t0
        calcLoop2:
            lw $t6, 0($t5)
            beqz $t6, dupNext
            li $t7, 1
            sllv $t7, $t7, $t4
	    add $t9, $t9, $t7        
            dupNext:
               addi $t4, $t4, 1
               addi $t5, $t5, 4
               bne $t4, $t2, calcLoop2
            	
        sw $t9, 0($t0)
        li $t7, 4
        mul $t8, $t2, $t7  #space between each number
        add $t0, $t0, $t8
        addi $t3, $t3, 1
	li $t9, 0
        li $t4, 0
        bne $t3, $t1, calcLoop
    
    li $t3, 1 #compare counter 0
    li $t4, 1 #origin counter
    addi $a0, $a0, 8
    move $t0, $a0
    move $t5, $a0
    li $t9, 10
    compareLoop:
    	lw $t6, 0($t0)
    	move $t5, $t0
        compareLoop2:
	        add $t5, $t5, $t8
    	        lw $t7, 0($t5)
    	        addi $t3, $t3, 1
    	        bne $t6, $t7, moveNext
    	        bge $t3, $t9, moveNext
    	        move $t9, $t3
    	        moveNext:
    	            bne $t3, $t1, compareLoop2
    	        
    	add $t0, $t0, $t8
    	addi $t4, $t4, 1
    	move $t3, $t4
    	bne $t4, $t1, compareLoop    
    li $t8, 10
    bne $t9, $t8, dup   
    noDup:
    	li $v0, -1
    	li $v1, 0
    	jr $ra
    dup:
    	li $v0, 1
    	move $v1, $t9
    	jr $ra
