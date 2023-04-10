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

# TODO: REMOVER APÓS CONCLUSÃO
	j exit # Finalização do programa
	
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

# Transformação de parametros p/ valores temporarios
mv t0, a0 # t0 = a0 (dia)
mv t1, a1 # t1 = a1 (aluno)
mv t2, a2 # t2 = a2 (presença)

# Criação da mascara binária
 # 0 ou 1, como definido pela presença do aluno em t2, é movido para a
 # esquerda (t1, aluno escolhido) vezes, criando assim uma bitmask
 # onde 31 bits são zero, unica exceção é o do aluno escolhido, sendo 0 ou 1
 
sll t2, t2, t1 # move o valor desejado (t2) pela quantidade de indices (t1)
mv t3, t2 # Mascara binaria normal armazenada em t3
xori t2, t2, 0xFFFFFFFF # Inverte a mascara binária, valor padrão agora é 1

# Carregamento do array no dia correto
# t4 vai ser o indice no formato acessivel para carregar t5!

slli t4, t0, 2 # multiplica o dia por 4 p/ obter o valor em bytes
la t5, arrayAulas # carrega o arrayAulas no registrador temp5
add t5, t5, t4 # t5 = arrayAulas[t4]

# Aplicação da mascara binaria

and t4, t4, t2 # Zera o aluno escolhido usando a mascara binaria invertida em AND
or t4, t4, t3 # Define o aluno escolhido com a mascara binaria

# Salvamento dos resultados para o arrayAulas
sw t4,(t5)

ret # Retorna a origem da chamada

# Encerra o programa com codigo 0 (sucesso)
exit:
	addi a7, zero, 10 # Carrega Saida
	ecall # Fim
