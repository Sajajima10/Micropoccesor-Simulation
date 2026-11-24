# Instrucciones: add, sub, addi, addu, addiu
# Casos Tabla 3:
# - add, sub: operandos positivos y al menos un operando negativo.
# - addi: inmediato negativo.
# - addiu, addu: mediante pseudoinstrucciones li (-2^15 a 2^15-1) y move.
# - syscall: servicios 11 (imprimir) y 10 (terminar).

.text
main:
    # Prueba li (addiu) con positivo y negativo en rango [-32768, 32767]
    li $t0, 1500          # addiu $t0, $zero, 1500
    li $t1, -500          # addiu $t1, $zero, -500
    
    # Prueba add positivo y con negativo
    add $s0, $t0, $t0     # 3000 (0x00000BB8)
    add $s1, $t0, $t1     # 1000 (0x000003E8)
    
    # Prueba sub positivo y con negativo
    sub $s2, $t0, $t1     # 2000 (0x000007D0)
    sub $s3, $t1, $t0     # -2000 (0xFFFFF830)
    
    # Prueba addi con inmediato negativo
    addi $s4, $s1, -1005  # -5 (0xFFFFFFFB)
    
    # Prueba move (addu)
    move $s5, $s3         # addu $s5, $s3, $zero -> 0xFFFFF830

    # Imprimir resultados en hex
    move $a0, $s0
    jal print_hex
    move $a0, $s1
    jal print_hex
    move $a0, $s2
    jal print_hex
    move $a0, $s3
    jal print_hex
    move $a0, $s4
    jal print_hex
    move $a0, $s5
    jal print_hex

    li $v0, 10
    syscall

# Rutina auxiliar: imprime $a0 en 8 digitos hex + '\n'
print_hex:
    move $t8, $a0
    li $t9, 28
hex_loop:
    srl $t7, $t8, 28
    sll $t8, $t8, 4
    slti $t6, $t7, 10
    bne $t6, $zero, is_digit
    addi $a0, $t7, 55     # 'A' - 10
    j print_char
is_digit:
    addi $a0, $t7, 48     # '0'
print_char:
    li $v0, 11
    syscall
    addi $t9, $t9, -4
    bge $t9, $zero, hex_loop
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra