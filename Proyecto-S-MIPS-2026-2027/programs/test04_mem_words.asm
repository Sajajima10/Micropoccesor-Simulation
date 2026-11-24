# Instrucciones: lw, sw
# Casos Tabla 3:
# - lw, sw: con desplazamiento positivo y con desplazamiento negativo.

.data
buffer: .word 0x11111111, 0x22222222, 0x33333333, 0x44444444

.text
main:
    la $t0, buffer
    addi $t1, $t0, 8      # Apunta al tercer elemento (0x33333333)
    
    # Lecturas con desplazamiento positivo y negativo
    lw $s0, -8($t1)       # 0x11111111
    lw $s1, 4($t1)        # 0x44444444
    
    # Escrituras con desplazamiento positivo y negativo
    lui $t2, 0xABCD
    ori $t2, $t2, 0x1234
    sw $t2, -4($t1)       # Sobrescribe segundo elemento (buffer[1])
    
    lui $t3, 0xDEAD
    ori $t3, $t3, 0xBEEF
    sw $t3, 4($t1)        # Sobrescribe cuarto elemento (buffer[3])
    
    # Verificar memoria leyendo de vuelta
    lw $s2, 4($t0)        # 0xABCD1234
    lw $s3, 12($t0)       # 0xDEADBEEF

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