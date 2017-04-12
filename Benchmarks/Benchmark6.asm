#for loop
add $1, $5, $0
lw $2, 4($5)
sll $2, $2, 2
add $2, $2, $5
ori $3, $0, 256
top: slt $4, $1, $2 #check if reached the final address
beq $4, $0, done
sw $3, 28($1)
addi $1, $1, 4
j top
done: addi $0, $0, 0