# Instrucciones: lb, lbu, sb, lw
# Casos Tabla 3:
# - lb, lbu: sobre un byte cuyo bit 7 vale 1, en al menos dos posiciones
#   distintas dentro de la palabra (d[1:0] distinto).
# - sb: en las cuatro posiciones de una misma palabra (d[1:0] = 0, 1, 2, 3),
#   comprobando despues con lw que los otros bytes no cambiaron.

.data
palabra: .word 0x00000000

.text
main:
    la $t0, palabra
    
    # sb en d[1:0] = 0, 1, 2, 3 e impresion de lw tras cada escritura
    li $t1, 0x81          # bit 7 = 1 (-127 con signo, 129 sin signo)
    sb $t1, 0($t0)
    lw $a0, 0($t0)        # 0x00000081
    jal print_hex
    
    li $t2, 0xFE          # bit 7 = 1 (-2 con signo, 254 sin signo)
    sb $t2, 1($t0)
    lw $a0, 0($t0)        # 0x0000FE81
    jal print_hex
    
    li $t3, 0x7F          # bit 7 = 0 (127)
    sb $t3, 2($t0)
    lw $a0, 0($t0)        # 0x007FFE81
    jal print_hex
    
    li $t4, 0xA5          # bit 7 = 1 (-91 con signo, 165 sin signo)
    sb $t4, 3($t0)
    lw $a0, 0($t0)        # 0xA57FFE81
    jal print_hex
    
    # lb y lbu en posiciones distintas (d[1:0] = 0 y d[1:0] = 3) con bit 7 = 1
    lb  $a0, 0($t0)       # 0xFFFFFF81
    jal print_hex
    lbu $a0, 0($t0)       # 0x00000081
    jal print_hex
    lb  $a0, 3($t0)       # 0xFFFFFFA5
    jal print_hex
    lbu $a0, 3($t0)       # 0x000000A5
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