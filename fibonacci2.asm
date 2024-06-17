.data
n: .word 0
fibo_30: .word 0
fibo_40: .word 0
fibo_41: .word 0

msg_n_termos: .asciiz "Digite o numero de termos: "
msg_virgula: .asciiz ", " 

msg_fibo_30: .asciiz "\n30° termo de Fibonacci: "
msg_fibo_40: .asciiz "\n40° termo de Fibonacci: "
msg_fibo_41: .asciiz "\n41° termo de Fibonacci: "
msg_proportion: .asciiz "\nProporção Áurea: "

.text
.globl main

main:
    # leitura de input
    li $v0, 4
    la $a0, msg_n_termos
    syscall

    li $v0, 5
    syscall
    sw $v0, n

    lw $t0, n           # carregar n em $t0

    # inicializar os primeiros termos da sequência de Fibonacci
    li $t1, 0           # F(0)
    li $t2, 1           # F(1)
    li $t4, 1           # contador

    # Calcular e imprimir até o 42º termo
    LOOP:
        add $t3, $t1, $t2 # prox = t1 + t2
        move $t1, $t2     # t1 = t2
        move $t2, $t3     # t2 = prox

        addi $t4, $t4, 1
        
        li $t5, 1
        add $t5, $t0, $t5
        ble $t4, $t5, TERMOS_SOLICITADOS #imprime os termos que o usuario solicitou

        # Se já calculou até o 42º termo, sair do loop
        bgt $t4, 42, CALC_PROPORTION

        # armazenar o 30º, 40º e 41º termos nos registradores e na memória
        beq $t4, 30, STORE_30
        beq $t4, 40, STORE_40
        beq $t4, 41, STORE_41

        j LOOP
        
    TERMOS_SOLICITADOS:
        li $v0, 1
        move $a0, $t1
        syscall
        
        li $v0, 4
    	la $a0, msg_virgula
    	syscall
    	
    	j LOOP

    STORE_30:
    	move $s1, $t3
        sw $t3, fibo_30
        j LOOP

    STORE_40:
    	move $s3, $t3
        sw $t3, fibo_40
        j LOOP

    STORE_41:
    	move $s2, $t3
        sw $t3, fibo_41
        j LOOP

    CALC_PROPORTION:
        lw $t2, fibo_40  # F(40)
        lw $t3, fibo_41  # F(41)

        # Calcular a proporção áurea F(41)/F(40)
        mtc1 $t3, $f2
        mtc1 $t2, $f4
        cvt.s.w $f2, $f2
        cvt.s.w $f4, $f4
        div.s $f0, $f2, $f4

        # Imprimir termos 30, 40 e 41
        li $v0, 4
        la $a0, msg_fibo_30
        syscall
        lw $a0, fibo_30
        li $v0, 1
        syscall

        li $v0, 4
        la $a0, msg_fibo_40
        syscall
        lw $a0, fibo_40
        li $v0, 1
        syscall

        li $v0, 4
        la $a0, msg_fibo_41
        syscall
        lw $a0, fibo_41
        li $v0, 1
        syscall

        # Imprimir proporção áurea
        li $v0, 4
        la $a0, msg_proportion
        syscall
        li $v0, 2
        mov.s $f12, $f0
        syscall

    FIM:
        li $v0, 10
        syscall
