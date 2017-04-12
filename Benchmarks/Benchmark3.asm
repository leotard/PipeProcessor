loop: lw $1, 5($3)
beq $1, 10, exit
addi $2, $2, 1
addi $3, $3, 1
j loop
exit: addi $0, $0, 0