# Instrucciones: and, or, andi, ori, lui
# Casos Tabla 3:
# - and, or: operandos con unos en los 16 bits altos.
# - andi, ori: inmediato cuyo bit 15 vale 1 (extension con ceros).
# - lui: inmediato cuyo bit 15 vale 1.

.text
main:
    # lui con bit 15 = 1 (0x8000 = 32768) -> debe ser 0x80000000
    lui $t0, 0x8000
    # ori con bit 15 = 1 (0xF0F0) -> debe extender con ceros: 0x8000F0F0
    ori $s0, $t0, 0xF0F0
    
    # Segundo operando con 1s en bits altos (0xC3C35A5A)
    lui $t1, 0xC3C3
    ori $t1, $t1, 0x5A5A
    
    # and y or con 1s en los 16 bits altos
    and $s1, $s0, $t1     # 0x80005050
    or  $s2, $s0, $t1     # 0xC3C3FAFA
    
    # andi con bit 15 = 1 (0x80FF) -> debe extender con ceros: 0x000080FA
    andi $s3, $s2, 0x80FF

    move $a0, $t0
    jal print_hex
    move $a0, $s0
    jal print_hex
    move $a0, $s1
    jal print_hex
    move $a0, $s2
    jal print_hex
    move $a0, $s3
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