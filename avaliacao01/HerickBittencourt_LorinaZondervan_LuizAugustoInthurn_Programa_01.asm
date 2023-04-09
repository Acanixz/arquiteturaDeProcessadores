# Disciplina: Arquitetura e Organização de Computadores
# Atividade: Avaliação 01 – Programação em Linguagem de Montagem
# Programa 01
# Grupo: - Hérick Vitor Vieira Bittencourt
# - Lorina Zondervan
# - Luiz Augusto Inthurn

.data
	tamanho_vetor: .asciz "Entre com o tamanho dos vetores (máx. = 8) : "
	vetor_a: .word 0,0,0,0,0,0,0,0
	vetor_b: .word 0,0,0,0,0,0,0,0
	tamanho_invalido: .asciz "Valor inválido digite novamente: "
	entrada_de_valor_A: .asciz "Vector A = "
	entrada_de_valor_B: .asciz "Vector B = "
	saida_vetor_A: .asciz "Vetor A trocado = "
	saida_vetor_B: .asciz "Vetor B trocado = "
	
.text
	li a7, 4                # chama imprimir string
	la a0, tamanho_vetor    # carrega endereço da memoria
	ecall                   # executa a7 imprimir string
	
	li a7, 5                # ler int de input do usuário
 	ecall                   # executa a7 ler input
 	mv t5, a0               # move 0 q está em a0 para s7
 	
 	
 	
 	
 	enquanto:
 		li t1, 9              # t1 recebe 9
 		li t2, 0              # t2 recebe 0
	 	bge t5, t1,faca     # vai para faca se to for maior ou igual que t1=9
	 	ble t5,t2,faca      # vai para faca se to for menor ou igual que t2 =0
	 	b fim_enquanto
	faca:
		li a7, 4
	 	la a0, tamanho_invalido
	 	ecall
		
		li a7, 5                # ler int de input do usuário
	 	ecall                   # executa a7 ler input
	 	mv t5, a0               # move 0 q está em a0 para t0
	 	j enquanto
	 	
	fim_enquanto:
	
	la s0,vetor_a                   # vetor_a começa em s0
	li t0,0                         # t0 recebe 0
	
	for:
		beq t0,t5,fim_for       # quando t0 for igual a t5 ir para fim_for
		
		li a7, 4        #syscal 4 printscreen
		la a0,entrada_de_valor_A
		ecall
		
		li a7, 5               #syscal 5 ler inteiro
		ecall
		mv t3,a0                # move o ques está no ao para t3
		
		#calcula a posição do vetor que vai escrever
    		slli t1, t0, 2 #4xi
    		add s1, s0, t1 #inicio+4xi
   		sw t3, 0(s1) #va[i]=t3
    
    		addi t0, t0, 1 # i++
    		jal zero, for
    		
	fim_for:
	
	la s9,vetor_b                   # vetor_b começa em s9
	addi t0,zero,0                           # t0 recebe 0
	
	for_2:
		beq t0,t5,fim_for_2       # quando t0 for igual a t5 ir para fim_for2
		
		li a7,4                   #syscal 4 printscreen
		la a0,entrada_de_valor_B
		ecall
		
		li a7,5                 #syscal 5 ler inteiro
		ecall
		mv t4,a0                # move o ques está no ao para t3
		
		#calcula a posição do vetor que vai escrever
    		slli t1, t0, 2 #4xi
    		add s10, s9, t1 #inicio+4xi
   		sw t4, 0(s10) #va[i]=t3
    
    		addi t0, t0, 1 # i++
    		jal zero, for_2
    		
	fim_for_2:
	
	addi t0,zero,0         # t0 recebe 0
	
	la s0,vetor_a          # vetor_a começa em s0
	la s9,vetor_b          # vetor_b começa em s9
	
	for_3:
		beq t0,t5,fim_for_3
		
		slli t1, t0, 2 #4xi
    		add s10, s9, t1 #inicio+4xi vetor b
    		add s1, s0, t1 #inicio+4xi vetor a
   		lb  t4,0(s1) 
    		lb t3,0(s10)
    		
   		sw t4,0(s10) 
   		sw t3,0(s1)
   		
   		addi t0, t0, 1 # i++
   		jal zero, for_3
   		
   	fim_for_3:
   	
   	addi t0,zero,0         # t0 recebe 0
   	la s0,vetor_a          # vetor_a começa em s0
   	
   	for_4:
   		beq t0,t5,fim_for_4
   		slli t1, t0, 2 #4xi
    		add s1, s0, t1 #inicio+4xi
    		
    		li a7,4
    		la a0,saida_vetor_A
    		ecall
    		
    		li a7,1
   		lb a0, 0(s1) 
   		ecall
   		
   		addi t0, t0, 1 # i++
   		jal zero, for_4
   		
   	fim_for_4:
   	
   	la s9,vetor_b          # vetor_b começa em s9
   	addi t0,zero,0         # t0 recebe 0
   	
   	for_5:
   		beq t0,t5,fim_for_5
   		slli t1, t0, 2 #4xi
    		add s10, s9, t1 #inicio+4xi

    		
    		li a7,4
    		la a0,saida_vetor_B
    		ecall
    		
    		li a7,1
   		lb a0, 0(s10) 
   		ecall
   		
   		addi t0, t0, 1 # i++
   		jal zero, for_5
   		
   	fim_for_5:
