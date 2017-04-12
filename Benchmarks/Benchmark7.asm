#infinite loop
addi $2, $2, 10
addi $3, $3, 0
addi $4, $4, 1
inc: addi $1, $1, 1
bne $1, $2, inc
beq $1, $2, dec
dec: sub $1, $1, $4
bne $1, $3, dec
beq $1, $3, inc