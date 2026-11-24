# Instrucciones: jal, jr, escritura en $zero
# Casos Tabla 3:
# - jal, jr: procedimiento que llama a otro (no hoja), guardando $ra en la pila
#   y retornando correctamente (calculo recursivo de factorial).
# - $zero: instruccion que escribe en $zero, comprobando despues que vale 0.

.text
main:
    # Intentar sobrescribir $zero con varias instrucciones
    addi $zero, $zero, 99
    li $t0, 12345
    add $zero, $t0, $t0
    ori $zero, $zero, 0xFFFF
    
    # Comprobar que $zero sigue valiendo 0
    move $a0, $zero
    jal print_hex         # Debe imprimir 00000000
    
    # Llamada a procedimiento no hoja (factorial(5) = 120 = 0x78)
    li $a0, 5
    jal factorial
    
    move $a0, $v0
    jal print_hex         # Debe imprimir 00000078

    li $v0, 10
    syscall

# Procedimiento recursivo (no hoja): guarda $ra y $a0 en $sp
factorial:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)
    
    slti $t0, $a0, 2
    beq $t0, $zero, rec_step
    li $v0, 1
    addi $sp, $sp, 8
    jr $ra
    
rec_step:
    addi $a0, $a0, -1
    jal factorial         # Llamada anidada
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    
    # Multiplicacion por sumas iterativas: $v0 = $a0 * $v0
    move $t1, $v0
    li $v0, 0
mul_loop:
    beq $a0, $zero, mul_done
    add $v0, $v0, $t1
    addi $a0, $a0, -1
    j mul_loop
mul_done:
    jr $ra

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