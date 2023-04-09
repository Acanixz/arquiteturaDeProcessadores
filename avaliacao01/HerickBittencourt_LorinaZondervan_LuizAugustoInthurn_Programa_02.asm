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

# Mensagens de solicitarValoresFailsafe
texto_solicitarValoresFailsafe: .asciz "Um dos valores fornecidos é invalido, tente novamente\n\n"

.text

.globl main
main:
	addi s0, zero, 16 # Maximo de dias permitidos
	addi s1, zero, 32 # Maximo de alunos permitidos
	addi s2, zero, 1 # 1 (usado p/ opção de sim/não na presença)
	jal loop
 
# Loop principal
loop:
	addi a0, zero, 0 # Dia de aula escolhido
	addi a1, zero, 0 # Aluno escolhido
	addi a2, zero, 0 # Registro de presença ou ausência
	jal solicitarValores # Solicitação dos valores p/ o usuario
	j exit # Finalização do programa
	
# Solicita o dia, aluno e registro de presença/falta
solicitarValores:
#  blt a1, 0, loop # número do aluno não pode ser negativo
#  blt a1, t1 # número do aluno não pode ser maior ou igual ao número máximo de alunos
#  blt a2, 0, loop # registro deve ser 0 ou 1
#  bge a2, 2, loop # registro deve ser 0 ou 1

# Obtem data da aula
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_fornecaAula # Fornece a string
	ecall # executa PrintString
	
	addi a7, zero, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t0, a0# Armazena resultado da operação
	
	# branches de Failsafe para o dia
	blt a0, zero, solicitarValoresFailsafe # dia < 0
	bge a0, s0,solicitarValoresFailsafe # dia >= totalDias

# Obtem aluno
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_fornecaAluno # Fornece a string
	ecall # executa PrintString
	
	addi a7, zero, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t1, a0# Armazena resultado da operação
	
	# branches de Failsafe para o aluno
	blt a0, zero, solicitarValoresFailsafe # aluno < 0
	bge a0, s1,solicitarValoresFailsafe # aluno >= totalAlunos
	
# Obtem presenca
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_fornecaPresenca # Fornece a string
	ecall # executa PrintString
	
	addi a7, zero, 5 # Carrega ReadInt
	ecall # Executa ReadInt
	mv t2, a0# Armazena resultado da operação
	
	# branches de Failsafe para a presença
	blt a0, zero, solicitarValoresFailsafe # presença < 0
	bgt a0, s2,solicitarValoresFailsafe # presença > 1
	
ret # Retorna a origem da chamada

# Um dos valores fornecidos está fora dos parametros, então a solicitação continua	
solicitarValoresFailsafe:
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_solicitarValoresFailsafe # Fornece a string
	ecall # executa PrintString
j solicitarValores # retorna p/ SolicitarValores, mantendo o retorno ainda em loop

# Encerra o programa com codigo 0 (sucesso)
exit:
	addi a7, zero, 10 # Carrega Saida
	ecall # Fim