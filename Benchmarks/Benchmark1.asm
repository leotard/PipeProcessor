addi $1, $0, 1
addi $2, $0, 5
loop: beq $1, $2, EXIT
addi $1, $1, 1
j loop
EXIT: add $0, $0, $0