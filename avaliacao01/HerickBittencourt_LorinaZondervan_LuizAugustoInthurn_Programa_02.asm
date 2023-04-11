.data
# Array de 16 valores (dias), cada um contendo um int de 32 bits (aluno)
# Por padrão, todos estão presentes (definidos como 1)
# 0xFFFFFFFF = 1111 1111 1111 1111 1111 1111 1111 1111
arrayAulas:
  .word 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF

# Mensagens de solicitarValores
texto_fornecaAula: .asciz "Forneça o dia da aula (entre 0 e 15): "
texto_fornecaAluno: .asciz "Escolha um aluno (entre 0 e 31): "
texto_fornecaPresenca: .asciz "Este aluno esta/esteve presente?\n1- Sim\n0- Não\n"
texto_sucesso: .asciz "Operação concluida com sucesso\n"

# Mensagens de solicitarValoresFailsafe
texto_solicitarValoresFailsafe: .asciz "Um dos valores fornecidos é invalido, tente novamente\n\n"

.text

.globl main
main:
	li s0, 16 # Maximo de dias permitidos
	li s1, 32 # Maximo de alunos permitidos
	jal loop
 
# Loop principal
loop:
# Reset dos parametros
	li a0, 0 # Dia de aula escolhido
	li a1, 0 # Aluno escolhido
	li a2, 0 # Registro de presença ou ausência
	
# Jump-and-link para a solicitação de valores
	jal solicitarValores # Solicitação dos valores p/ o usuario
	
# Aplicação da alteração desejada
	jal editarAluno
	
# Voltando para o começo do loop
	j loop # jal (jump and link aumenta stack, jump aparentemente não)
	
# Solicita o dia, aluno e registro de presença/falta
solicitarValores:
# Obtem data da aula
	li a7, 4 # Carrega PrintString
	la a0, texto_fornecaAula # Fornece a string
	ecall # executa PrintString
	
	li a7, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t0, a0 # temp0 = dia
	
	# branches de Failsafe para o dia
	blt a0, zero, solicitarValoresFailsafe # dia < 0
	bge a0, s0,solicitarValoresFailsafe # dia >= totalDias

# Obtem aluno
	li a7, 4 # Carrega PrintString
	la a0, texto_fornecaAluno # Fornece a string
	ecall # executa PrintString
	
	li a7, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t1, a0# temp1 = aluno
	
	# branches de Failsafe para o aluno
	blt a0, zero, solicitarValoresFailsafe # aluno < 0
	bge a0, s1,solicitarValoresFailsafe # aluno >= totalAlunos
	
# Obtem presenca
	li a7, 4 # Carrega PrintString
	la a0, texto_fornecaPresenca # Fornece a string
	ecall # executa PrintString
	
	li a7, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t2, a0# temp2 = presença
	
	# branches de Failsafe para a presença
	blt a0, zero, solicitarValoresFailsafe # presença < 0
	
	li t6, 1 # Carrega 1 temporariamente p/ proxima branch
	bgt a0, t6,solicitarValoresFailsafe # presença > 1
	
# Preparações p/ retornar os 3 valores
	mv a0, t0 # arg0 = temp0
	mv a1, t1 # arg1 = temp1
	mv a2, t2 # arg2 = temp2
ret # Retorna a origem da chamada

# Um dos valores fornecidos está fora dos parametros, então a solicitação continua	
solicitarValoresFailsafe:
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_solicitarValoresFailsafe # Fornece a string
	ecall # executa PrintString
j solicitarValores # retorna p/ SolicitarValores, mantendo o retorno ainda em loop

# Com os valores prontos, já é possível modificar o bit do aluno p/ o desejado
editarAluno:
# Parametros:
# a0 = dia
# a1 = aluno
# a2 = presença

# Carregamento do array no dia correto
	slli t1, a0, 2 # multiplica o dia por 4 p/ obter o valor em bytes
	la t0, arrayAulas # Endereço de arrayAulas é carregado
	add t0, t0, t1 # t0 = endereço de arrayAulas[t4]
	lw t6, arrayAulas # t6 = conteudo de arrayAulas[t4]
	
	li t1, 1 # carrega o valor 1 em t1
	sll t1, t1, a1 # t1 = mascara binária
	xori t1, t1, -1 # Inversão da mascara binária, valor padrão é -1
	
	and t2, t6, t1 # Limpa o valor do aluno
	sll t3, a2, a1 # Prepara t3 para ser o novo valor final
	or t2, t2, t3 # Aplica o valor de presença (t3) no resultado final

# Salvamento do resultado para o arrayAulas
	sw t2,(t0)

# Mensagem de conclusão
	li a7, 4 # Carrega PrintString
	la a0, texto_sucesso # Fornece a string
	ecall # executa PrintString

ret # Retorna a origem da chamada

# Encerra o programa com codigo 0 (sucesso)
exit:
	addi a7, zero, 10 # Carrega Saida
	ecall # Fim
