# IF (i<N)
# A[i] = 0
# End if
lw $1, 0($3)
lw $2, 4($3)
slt $2, $1, $2
beq $2, $0, skip
sll $1, $1, 2
add $1, $1, $3
sw $0, 28($1)
skip: addi $0, $0, 0