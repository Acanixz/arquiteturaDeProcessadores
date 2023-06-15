# Disciplina: Arquitetura e Organização de Computadores

# Atividade: Avaliação 03 - Programa 2 - Programação de Procedimentos

# Grupo:
# - Lorina Zondervan
# - Hérick Vitor Vieira Bittencourt
# - Luiz Augusto Inthurn

.data
	vetor:	.space 400	# Cria um vetor de 400 bytes (100 espaços * 4 bytes = 400 bytes)
	
	msgPedirTam:	.asciz 
		"Insira o tamanho do vetor (MIN: 2, MAX: 100)\n"
		
	msgTamInvalido:	.asciz 
		"Tamanho invalido, tente novamente!\n\n"

	msgFornecerVal_1: .asciz
		"Forneça um valor para o indice "
		
	msgFornecerVal_2: .asciz
		" do vetor: "
		
	msgResultado: .asciz
		"O resultado do somatório dos valores do vetor é: "
.text
#	*************************************************************************
	jal	zero, main		# Jump para a função main
	
main:
					# Obtenção do tamanho do vetor desejado (MIN: 2, MAX: 100)
	li	a7, 4
	la	a0, msgPedirTam 	# Mensagem pedindo o tamanho do vetor
	ecall
	
	li	a7, 5			# Leitura de integer p/ tamanho
	ecall
	
					# Preparação de branch pra main_tamInvalido em caso de entrada invalida
	li	t0, 2 			# t0 = 2
	li	t1, 100 		# t1 = 100
	
					# Branch se a0 < 2
	blt	a0, t0, main_tamInvalido
		
					# Branch se a0 > 100
	bgt	a0, t1, main_tamInvalido
	
					# Carregamento dos valores para a próxima operação nos registradores de argumento
	mv	a1, a0			# a1 = tamanho maximo do vetor, fornecido pelo usuario
	la	a0, vetor		# a0 = vetor
	li 	s0, 0			# Preparação do index p/ ser 0 no começo do loop
	
					# Obtenção dos valores de cada posição	
	jal	obterValores		# Chamada p/ função recursiva obterValores
	
	addi 	s0, zero, 0		# Reset do index antes da proxima recursão
	jal	somaValores		# Chamada p/ função recursiva somaValores
	
	mv	t0, a0			# Move temp. do somatório p/ t0
	li	a7, 4
	la	a0, msgResultado	# Mensagem de resultado final
	ecall
	
	li	a7, 1
	mv	a0, t0			# Display do resultado do somatório
	ecall
	
	jal	zero, end		# Jump para o final do código
	
main_tamInvalido:
					# Carregamento da string, seguido do retorno pro main
	li	a7, 4
	la	a0, msgTamInvalido
	ecall				# Mensagem de entrada invalida
	
	jal	zero, main		# Jump para o main
#	*************************************************************************
obterValores:
					# Parametros:
					# s0 = index
					
					# t0 = endereço base do vetor
					# t1 = index * 4
					# t2 = endereço base + (index * 4)
					
					# a0 = endereço base do vetor (movido p/ t0 durante exec. até cham. rec.)
					# a1 = tamanho do vetor
					
	bge	s0, a1,obterValoresFim 	# Branch se index >= maxTamVetor
	mv 	t0, a0			# Carregamento temp. de arg. 0 (endereço base) em t0
	
	addi 	sp, sp, -8 		# Aumenta stack pointer em 8 bytes (2 instruções)
	sw	ra, 0(sp)		# Armazena return address em sp (sem offset)
	sw	s0, 4(sp)		# Armazena s0 (index) em sp + 4
	
					# Envio da mensagem "Forneça um valor"
	li 	a7, 4
	la 	a0, msgFornecerVal_1	# Trecho 1 da mensagem
	ecall
	
	li 	a7, 1
	mv 	a0, s0			# Mostra o indice atual no meio da mensagem
	ecall
	
	li 	a7, 4
	la 	a0, msgFornecerVal_2	# Trecho 2 da mensagem
	ecall
	
	li 	a7, 5			# Entrada de um inteiro p/ colocar no vetor
	ecall
	
	slli	t1, s0, 2		# t1 = (index * 4)
	add	t2, t0, t1		# t2 = endereço base + (index * 4)
	
	sw	a0, (t2)		# Armazena a entrada no vetor utilizando o endereço em t2
	
	mv 	a0, t0			# Movendo t0 (endereço base) devolta para o registrador de arg.
	addi	s0, s0, 1		# i++
	jal 	obterValores
	
	lw	s0, 4(sp)		# Carrega o index anterior
	lw	ra, 0(sp)		# Carrega o return address anterior
	addi	sp, sp, 8		# Diminui stack pointer em 8 bytes (2 instruções)
	
	jalr	zero, ra, 0		# Retorno recursivo

obterValoresFim:
	jalr	zero, ra, 0		# Inicia retorno recursivo
#	*************************************************************************
somaValores:
					# Parametros:
					# s0 = index
					
					# t0 = endereço base do vetor
					# t1 = index * 4
					# t2 = endereço base + (index * 4)
					# t3 = valor em [endereço base + (index * 4)]
					# t4 = somatório
					
					# a0 = endereço base do vetor (movido p/ t0 durante exec. até cham. rec.)
					# a1 = tamanho do vetor
					
	bge	s0, a1,somaValoresFim 	# Branch se index >= maxTamVetor
	mv 	t0, a0			# Carregamento temp. de arg. 0 (endereço base) em t0
	
	addi 	sp, sp, -12 		# Aumenta stack pointer em 12 bytes (3 instruções)
	sw	ra, 0(sp)		# Armazena return address em sp (sem offset)
	sw	s0, 4(sp)		# Armazena s0 (index) em sp + 4
	
	slli	t1, s0, 2		# t1 = (index * 4)
	add	t2, t0, t1		# t2 = endereço base + (index * 4)
	lw	t3, (t2)		# t3 = valor na posição do vetor
	
	sw	t3, 8(sp)		# Armazena t3 em sp + 8
	
	mv 	a0, t0			# Movendo t0 (endereço base) devolta para o registrador de arg.
	addi	s0, s0, 1		# i++
	jal 	somaValores		# Chamada recursiva
	
	lw	t3, 8(sp)		# Carrega o valor no index anterior
	add	t4, t4, t3		# t4 += t3
	
	lw	s0, 4(sp)		# Carrega o index anterior
	lw	ra, 0(sp)		# Carrega o return address anterior
	addi	sp, sp, 12		# Diminui stack pointer em 12 bytes (3 instruções)
	
	mv	a0, t4			# Move o somatório p/ o retorno
	jalr	zero, ra, 0		# Retorno recursivo
somaValoresFim:
	jalr	zero, ra, 0		# Inicia retorno recursivo
#	*************************************************************************

end:
	li 	a7, 10
	ecall			# Finalização do programa com código 0
