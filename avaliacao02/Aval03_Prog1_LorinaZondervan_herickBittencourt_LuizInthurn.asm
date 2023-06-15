# Disciplina: Arquitetura e Organização de Computadores

# Atividade: Avaliação 03 - Programa 1 - Programação de Procedimentos

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
	jal	obterValores		# Chamada p/ for loop obterValores
	
	jal	somaValores		# Chamada p/ for loop somaValores
	
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
					# Parametros
					# s0 = index
					
					# t0 = endereço base
					# t1 = index * 4
					# t2 = endereço base + (index * 4)
					
					# a0 = endereço base do vetor (movido p/ t0 durante exec. até loop)
					# a1 = tamanho do vetor
					
	mv 	t0, a0			# Carregamento temp. de arg. 0 (endereço base) em t0
	
	addi 	sp, sp, -4 		# Aumenta stack pointer em 4 bytes (1 instrução)
	sw	s0, 0(sp)		# Armazena s0 (index) em sp (sem offset)
	
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
	blt	s0, a1, obterValores	# Volta para o loop caso index < maxTamVetor
	jal	zero, obterValoresFim	# Inicia o final do for loop
	
obterValoresFim:
	bgtz	s0, obterValoresRet	# Restaura o registrador S até que volte ao valor original
	jalr	zero, ra, 0		# Retorno p/ o main
obterValoresRet:
	lw	s0, 0(sp)		# Carrega index anterior em s0
	addi 	sp, sp, 4 		# Diminui stack pointer em 4 bytes (1 instrução)
	jal	zero, obterValoresFim	# Volta p/ obterValoresFim e tenta denovo
	
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
					
	mv 	t0, a0			# Carregamento temp. de arg. 0 (endereço base) em t0
	
	addi 	sp, sp, -4 		# Aumenta stack pointer em 4 bytes (1 instrução)
	sw	s0, 0(sp)		# Armazena s0 (index) em sp (sem offset)
	
	slli	t1, s0, 2		# t1 = (index * 4)
	add	t2, t0, t1		# t2 = endereço base + (index * 4)
	lw	t3, (t2)		# t3 = valor na posição do vetor
	
	add	t4, t4, t3		# t4 += t3
	
	mv 	a0, t0			# Movendo t0 (endereço base) devolta para o registrador de arg.
	addi	s0, s0, 1		# i++
	blt	s0, a1, somaValores	# Volta para o loop caso index < maxTamVetor
	jal	zero, somaValoresFim	# Inicia o final do for loop
	
somaValoresFim:
	bgtz	s0, somaValoresRet
	mv	a0, t4			# Move t4 (somatorio) p/ retorno
	jalr	zero, ra, 0		# Retorna p/ o main
	
somaValoresRet:
	lw	s0, 0(sp)		# Carrega index anterior em s0
	addi 	sp, sp, 4 		# Diminui stack pointer em 4 bytes (1 instrução)
	jal	zero, somaValoresFim	# Volta p/ somaValoresFim e tenta denovo
#	*************************************************************************

end:
	li 	a7, 10
	ecall			# Finalização do programa com código 0
