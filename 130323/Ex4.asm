####################################################################
# Exerc�cio 05 - Patterson pags. 67
# Mostra a compila��o de um la�o While
####################################################################
# Trecho em C:
# while (save[i] == k)
#     i = i + j;

      .data    # segmento de dados
# defini��o do array save[]. Coloca os valores de save[0]=3 at� save[8]=1 na mem�ria
Array_save: .word 3, 3, 3, 3, 3, 1, 4, 3, 1

      .text   # segmento de c�digo (programa)
main:    
      la s6, Array_save     # Conforme o exerc�cio, $s6 cont�m o endere�o-base de save[].
      addi s5, zero, 3      # inicializando k=3 por causa do array que foi definido (5 itera��es)
      addi s4, zero, 1      # inicializando j=1 para varrer o array de 1 em 1
      addi s3, zero, 0      # inicializando i=0 

Loop: add t1, s3, s3        # $t1 = 2.i  
      add t1, t1, t1        # $t1 = 4.i
      add t1, t1, s6        # $t1 = end.base + 4.i (deslocamento) = end. de save[i]
      lw  t0, 0(t1)         # $t0 = save[i]
      bne t0, s5, Exit      # se save[i] != k goto Exit
      add s3, s3, s4        # i = i + j
      j   Loop              # goto Loop
Exit: nop                   # n�o faz nada