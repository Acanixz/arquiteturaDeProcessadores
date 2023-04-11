# Disciplina: Arquitetura e Organização de Computadores
# Atividade: Avaliação 01 – Programação em Linguagem de Montagem
# Programa 01
# Grupo: - Hérick Vitor Vieira Bittencourt
# - Lorina Zondervan
# - Luiz Augusto Inthurn

.data
	tamanho_vetor: .asciz "Entre com o tamanho dos vetores (máx. = 8) : "
	vetor_a: .word 0,0,0,0,0,0,0,0                                               #Inicialização do vetor_a com 8 bits
	vetor_b: .word 0,0,0,0,0,0,0,0                                               #Inicialização do vetor_b com 8 bits
	tamanho_invalido: .asciz "Valor inválido digite novamente: "
	entrada_de_valor_A: .asciz "Vector A["
	entrada_de_valor_B: .asciz "Vector B["
	final_entrada_de_valor: .asciz "] = "
	final_saida_de_valor: .asciz "]trocado = "
	
.text
	# Imprimir "Entre com o tamanho dos vetores (máx. = 8) : "
	li a7, 4                # syscall imprimir string
	la a0, tamanho_vetor    # carrega tamanho_vetor no endereço da memoria a0
	ecall                   # executa syscall no a7  imprimir string
	
	# Pegar input do usuario
	li a7, 5                # syscall guardar inteiro de input do usuário
 	ecall                   # executa a7 que coloca input inteiro no a0
 	mv t5, a0               # move o input do usuário que está no a0 para t5
 	     
 	# Filtragem do input do usuário                                  
 	li t1, 9              # t1 recebe 9
 	li t2, 0              # t2 recebe 0
 	enquanto:
	 	bge t5, t1,faca           # vai para faca se t5(input do usuário) for maior ou igual que t1=9
	 	ble t5,t2,faca            # vai para faca se t5(input do usuário) for menor ou igual que t2 =0
	 	b fim_enquanto            # Se não foi para faca vai pra fim_enquanto 
	faca:
		li a7, 4                  # syscall imprimir string                
	 	la a0, tamanho_invalido   # carrega tamanho_invalido no endereço da memoria a0
	 	ecall                     # executa syscall no a7  imprimir string
		
		li a7, 5                # syscall guardar inteiro de input do usuário
	 	ecall                   # executa a7 que coloca input inteiro no a0
	 	mv t5, a0               # move o input do usuário que está em a0 para t5
	 	j enquanto              # volta para enquanto
	 	
	fim_enquanto:
	#t5 == tamanho dos vetores
	
	la s0,vetor_a                   # vetor_a começa em s0
	li t0,0                         # t0(contador) recebe 0
	
	for:
		beq t0,t5,fim_for          # quando t0(contador iniciado em 0) for igual a t5(tamanho do vetor) ir para fim_for
		
		li a7, 4        	   # syscall imprimir string
		la a0,entrada_de_valor_A   # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7,1                    # syscall imprimir inteiro
		mv a0,t0                   # move t0(contador) no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir inteiro
		
		li a7, 4        	   # syscall imprimir string
		la a0,final_entrada_de_valor   # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7, 5                   # syscall guardar inteiro de input do usuário
		ecall                      # executa a7 que coloca input inteiro no a0
		mv t3,a0                   # move o que está no ao para t3(input do usuário)
		
		#calcula a posição do vetor que vai escrever
    		slli t1, t0, 2             #4xt0(contador)
    		add s1, s0, t1             #inicio+4xt0(contador)
   		sw t3, 0(s1)               #va[t0(contador)] recebe t3(input do usuário)
    
    		addi t0, t0, 1             # soma 1 ao t0(contador) e guarta no t0
    		j for                      # pula para o for
    		
	fim_for:
	
	la s9,vetor_b                   # vetor_b começa em s9
	li t0,0                         # t0(contador) recebe 0
	
	for_2:
		beq t0,t5,fim_for_2        # quando t0(contador iniciado em 0) for igual a t5(tamanho do vetor) ir para fim_for_2
		
		li a7,4                    # syscall imprimir string
		la a0,entrada_de_valor_B   # carrega entrada_de_valor_B no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7,1                    # syscall imprimir inteiro
		mv a0,t0                   # move t0(contador) no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir inteiro
		
		li a7, 4        	   # syscall imprimir string
		la a0,final_entrada_de_valor   # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7,5                    # syscall guardar inteiro de input do usuário
		ecall                      # executa a7 que coloca input inteiro no a0
		mv t3,a0                   # move o que está no ao para t3(input do usuário)
		
		#calcula a posição do vetor que vai escrever
    		slli t1, t0, 2             #4xt0(contador)
    		add s10, s9, t1            #inicio+4xt0(contador)
   		sw t3, 0(s10)              #va[t0(contador)] rebebe t3(input do usuário)
    
    		addi t0, t0, 1             # soma 1 ao t0(contador) e guarta no t0
    		j for_2                    # pula para o for_2
    		
	fim_for_2:
	
	li t0,0                 # t0 recebe 0
	
	for_3:
		beq t0,t5,fim_for_3     # quando t0(contador iniciado em 0) for igual a t5(tamanho do vetor) ir para fim_for_3
		
		slli t1, t0, 2          #4xt0(contador)
    		add s10, s9, t1         #inicio+4xt0(contador) vetor b
    		add s1, s0, t1          #inicio+4xt0(contador) vetor a
    		
   		lb t4,0(s1)             #coloca endereço de s1(vetor_A) no t4
    		lb t3,0(s10)            #coloca endereço de s10(vetor_B) no t3
    		
   		sw t4,0(s10)            #coloca endereço que está no t4(vetor_A) no s10(vetor_B)
   		sw t3,0(s1)             #coloca endereço que está no t3(vetor_B) no s1(vetor_A)
   		
   		addi t0, t0, 1          # soma 1 ao t0(contador) e guarta no t0
   		j for_3                 # pula para o for_3
   		
   	fim_for_3:
   	
   	li t0,0                # t0 recebe 0
   	
   	for_4:
   		beq t0,t5,fim_for_4     # quando t0(contador iniciado em 0) for igual a t5(tamanho do vetor) ir para fim_for_4
   		slli t1, t0, 2          #4xt0(contador)
    		add s1, s0, t1          #inicio+4xt0(contador)
    		
    		li a7, 4        	   # syscall imprimir string
		la a0,entrada_de_valor_A   # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7,1                    # syscall imprimir inteiro
		mv a0,t0                   # move t0(contador) no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir inteiro
		
		li a7, 4        	   # syscall imprimir string
		la a0,final_saida_de_valor # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
    		
    		li a7,1                # syscall imprimir inteiro
   		lb a0, 0(s1)           # carrega byte do s1(vetor_A)
   		ecall                  # executa syscall no a7  imprimir inteiro
   		
   		#imprimi nova linha
   		li a0, 10              # carrega codigo ascii codigo de nova linha para a0
		li a7, 11              # syscall imprimi caractere ascii
		ecall                  # executa syscall imprimi caractere ascii

   		addi t0, t0, 1         # soma 1 ao t0(contador) e guarta no t0  
   		j for_4                # pula para o for_4
   		
   	fim_for_4:
   	
   	li t0,0                # t0 recebe 0
   	
   	for_5:
   		beq t0,t5,fim_for_5    # quando t0(contador iniciado em 0) for igual a t5(tamanho do vetor) ir para fim_for_5
   		slli t1, t0, 2         #4xt0(contador)
    		add s10, s9, t1        #inicio+4xt0(contador)

    		
    		li a7, 4        	   # syscall imprimir string
		la a0,entrada_de_valor_B   # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
		
		li a7,1                    # syscall imprimir inteiro
		mv a0,t0                   # move t0(contador) no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir inteiro
		
		li a7, 4        	   # syscall imprimir string
		la a0,final_saida_de_valor # carrega entrada_de_valor_A no endereço da memoria a0
		ecall                      # executa syscall no a7  imprimir string
    		
    		li a7,1                    # syscall imprimir inteiro
   		lb a0, 0(s10)              # carrega byte do s1(vetor_B)
   		ecall                      # executa syscall no a7  imprimir inteiro
   		
   		#imprimi nova linha
   		li a0, 10                  # carrega codigo ascii codigo de nova linha para a0
		li a7, 11                  # syscall imprimi caractere ascii
		ecall                      # executa syscall imprimi caractere ascii
   		
   		addi t0, t0, 1              # soma 1 ao t0(contador) e guarta no t0  
   		j for_5                     # pula para o for_5
   		
   	fim_for_5:
