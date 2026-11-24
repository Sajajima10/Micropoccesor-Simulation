# Instrucciones: sll, srl, slt, slti
# Casos Tabla 3:
# - sll, srl: con shamt = 0 y shamt != 0; srl sobre valor negativo (entran ceros).
# - slt, slti: resultado 1 y resultado 0; operando negativo donde comparacion
#   con signo y sin signo difieren (-1 < 1 debe dar 1, no 0).

.text
main:
    li $t0, -16           # 0xFFFFFFF0 (negativo, bit 31 = 1)
    li $t1, 5             # 0x00000005 (positivo)
    
    # Desplazamientos con shamt = 0
    sll $s0, $t0, 0       # 0xFFFFFFF0
    srl $s1, $t0, 0       # 0xFFFFFFF0
    
    # Desplazamientos con shamt != 0 (srl sobre negativo mete ceros)
    sll $s2, $t1, 4       # 0x00000050
    srl $s3, $t0, 4       # 0x0FFFFFFF (si fuera aritmetico seria 0xFFFFFFFF)
    
    # slt: con signo vs sin signo (-16 < 5 -> 1; 5 < -16 -> 0)
    slt $s4, $t0, $t1     # 1
    slt $s5, $t1, $t0     # 0
    
    # slti: con signo vs sin signo (-16 < 10 -> 1; 5 < -1 -> 0)
    slti $s6, $t0, 10     # 1
    slti $s7, $t1, -1     # 0

    move $a0, $s0
    jal print_hex
    move $a0, $s1
    jal print_hex
    move $a0, $s2
    jal print_hex
    move $a0, $s3
    jal print_hex
    
    # Imprimir resultados booleanos (0 o 1) en una linea
    addi $a0, $s4, 48
    li $v0, 11
    syscall
    addi $a0, $s5, 48
    syscall
    addi $a0, $s6, 48
    syscall
    addi $a0, $s7, 48
    syscall
    li $a0, 10
    syscall

    li $v0, 10
    syscall

print_hex:
    move $t8, $a0
    li $t9, 28
hex_loop:
    srl $t7, $t8, 28
    sll $t8, $t8, 4
    slti $t6, $t7, 10
    bne $t6, $zero, is_digit
    addi $a0, $t7, 55
    j print_char
is_digit:
    addi $a0, $t7, 48
print_char:
    li $v0, 11
    syscall
    addi $t9, $t9, -4
    bge $t9, $zero, hex_loop
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra