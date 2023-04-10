.data
# Array de 16 valores (dias), cada um contendo um int de 32 bits (aluno)
# Por padr�o, todos est�o presentes (definidos como 1)
# 0xFFFFFFFF = 1111 1111 1111 1111 1111 1111 1111 1111
arrayAulas:
  .word 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF

# Mensagens de solicitarValores
texto_fornecaAula: .asciz "Forne�a o dia da aula (entre 0 e 15): "
texto_fornecaAluno: .asciz "Escolha um aluno (entre 0 e 31): "
texto_fornecaPresenca: .asciz "Este aluno esta/esteve presente?\n1- Sim\n0- N�o\n"

# Mensagens de solicitarValoresFailsafe
texto_solicitarValoresFailsafe: .asciz "Um dos valores fornecidos � invalido, tente novamente\n\n"

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
	li a2, 0 # Registro de presen�a ou aus�ncia
	
# Jump-and-link para a solicita��o de valores
	jal solicitarValores # Solicita��o dos valores p/ o usuario
	
# Aplica��o da altera��o desejada
	jal editarAluno

# TODO: REMOVER AP�S CONCLUS�O
	j exit # Finaliza��o do programa
	
# Voltando para o come�o do loop
	j loop # jal (jump and link aumenta stack, jump aparentemente n�o)
	
# Solicita o dia, aluno e registro de presen�a/falta
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
	mv t2, a0# temp2 = presen�a
	
	# branches de Failsafe para a presen�a
	blt a0, zero, solicitarValoresFailsafe # presen�a < 0
	
	li t6, 1 # Carrega 1 temporariamente p/ proxima branch
	bgt a0, t6,solicitarValoresFailsafe # presen�a > 1
	
# Prepara��es p/ retornar os 3 valores
	mv a0, t0 # arg0 = temp0
	mv a1, t1 # arg1 = temp1
	mv a2, t2 # arg2 = temp2
ret # Retorna a origem da chamada

# Um dos valores fornecidos est� fora dos parametros, ent�o a solicita��o continua	
solicitarValoresFailsafe:
	addi a7, zero, 4 # Carrega PrintString
	la a0, texto_solicitarValoresFailsafe # Fornece a string
	ecall # executa PrintString
j solicitarValores # retorna p/ SolicitarValores, mantendo o retorno ainda em loop

# Com os valores prontos, j� � poss�vel modificar o bit do aluno p/ o desejado
editarAluno:

# Transforma��o de parametros p/ valores temporarios
mv t0, a0 # t0 = a0 (dia)
mv t1, a1 # t1 = a1 (aluno)
mv t2, a2 # t2 = a2 (presen�a)

# Cria��o da mascara bin�ria
 # 0 ou 1, como definido pela presen�a do aluno em t2, � movido para a
 # esquerda (t1, aluno escolhido) vezes, criando assim uma bitmask
 # onde 31 bits s�o zero, unica exce��o � o do aluno escolhido, sendo 0 ou 1
 
sll t2, t2, t1 # move o valor desejado (t2) pela quantidade de indices (t1)
mv t3, t2 # Mascara binaria normal armazenada em t3
xori t2, t2, 0xFFFFFFFF # Inverte a mascara bin�ria, valor padr�o agora � 1

# Carregamento do array no dia correto
# t4 vai ser o indice no formato acessivel para carregar t5!

slli t4, t0, 2 # multiplica o dia por 4 p/ obter o valor em bytes
la t5, arrayAulas # carrega o arrayAulas no registrador temp5
add t5, t5, t4 # t5 = arrayAulas[t4]

# Aplica��o da mascara binaria

and t4, t4, t2 # Zera o aluno escolhido usando a mascara binaria invertida em AND
or t4, t4, t3 # Define o aluno escolhido com a mascara binaria

# Salvamento dos resultados para o arrayAulas
sw t4,(t5)

ret # Retorna a origem da chamada

# Encerra o programa com codigo 0 (sucesso)
exit:
	addi a7, zero, 10 # Carrega Saida
	ecall # Fim
