max: lw $1, 0($4) #register 4 stores the first array value
addi $2, $2, 1
loop: beq $2, $5, exit  #exit when reach the end of the array
addi $4, $4, 4
addi $2, $2, 1
lw $3, 0($4)
beq $3, $1, end_if
#move $1, $3 cannot be compiled
end_if: addi $0, $0, 0
j loop
exit: addi $0, $0, 0