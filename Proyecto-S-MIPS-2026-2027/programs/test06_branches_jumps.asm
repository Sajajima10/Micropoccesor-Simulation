# Instrucciones: beq, bne, j
# Casos Tabla 3:
# - beq, bne: cada uno tomado y no tomado; al menos un salto hacia atras.
# - j: al menos una vez.

.text
main:
    li $s0, 0             # Acumulador de control
    li $t0, 5
    li $t1, 5
    li $t2, 9
    
    # 1. beq NO tomado (5 == 9 es falso)
    beq $t0, $t2, fallo
    addi $s0, $s0, 1      # s0 = 1
    
    # 2. beq TOMADO hacia adelante (5 == 5 es verdadero)
    beq $t0, $t1, beq_ok
    addi $s0, $s0, 100    # No debe ejecutarse
beq_ok:
    addi $s0, $s0, 2      # s0 = 3
    
    # 3. bne NO tomado (5 != 5 es falso)
    bne $t0, $t1, fallo
    addi $s0, $s0, 4      # s0 = 7
    
    # 4. bne TOMADO hacia atras (bucle de 3 iteraciones)
    li $t3, 0
bucle:
    addi $s0, $s0, 10     # +10 en cada iteracion (total +30 -> s0 = 37)
    addi $t3, $t3, 1
    bne $t3, $t1, check_3 # Salto hacia adelante
check_3:
    li $t4, 3
    bne $t3, $t4, bucle   # Salto hacia ATRAS tomado 2 veces, no tomado la 3ra
    
    # 5. Salto incondicional j
    j fin_ok
fallo:
    li $s0, 0xEEEE
fin_ok:
    move $a0, $s0         # Debe imprimir 0x00000025 (37 en decimal)
    jal print_hex

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