addi $4, $1, 0
bne $1, $4, C2_c
j C1_b
C2_c: addi $4, $0, 2
bne $1, $4, C3_c
j C2_b
C3_c: addi $4, $0, 3
bne $1, $4, EXIT
C1_b: addi $1, $1, 1
C2_b: addi $1, $1, 2
j EXIT
C3_b: addi $1, $1, 3
EXIT: addi $0, $0, 0