addi t0, zero, 1 # t0 = 1
addi t1, zero, 2 # t1 = 2
add t2, t0, t1 # t2 = t0(1) + t1(2) = 3
sub t1, t1, t0 # t1 = t1(2) - t1(1) = 1
and t3, t0, t1 # t3 = t0(1) AND t1(1) = 1
slli t3, t3, 2 # SLL t3 = 4
addi t4, zero, 15 # t4 = 15
addi t3, t3, 1 # t3++ = 5
xor t0, t3, t4 # t0 = t3(5) XOR t4(15) = 10
and t4, t0, t3 #t4 = t0(10) AND t3(5) = 0
addi t0, zero, 1 # t0 = 1
addi t1, zero, 2 # t1 = 2
addi t2, zero, 3 # t2 = 3
addi t3, zero, 4 # t3 = 4
addi t4, zero, 5 # t4 = 5
beq t0, t1, equal # pula adições +1 se t0 for igual a t1 (NÃO ACONTECE)
addi t0, t0, 1 # t0 += 1 (agora 2)
addi t1, t1, 1 # t1 += 1 (agora 3)
addi t2, t2, 1 # t2 += 1 (agora 4)
addi t3, t3, 1 # t3 += 1 (agora 5)
addi t4, t4, 1 # t4 += 1 (agora 6)
equal:
addi t0, t0, 5 # t0 += 5 (agora 7)
addi t1, t1, 4 # t1 += 4 (agora 7)
addi t2, t2, 5 # t2 += 5 (agora 9)
addi t3, t3, 5 # t3 += 5 (agora 10)
addi t4, t4, 5 # t4 += 5 (agora 11)
beq t0, t1, trueEqual # pula adicoes +10 se t0 for igual a t1 (ACONTECE)
addi t0, t0, 10 # t0 += 10
addi t1, t1, 10 # t1 += 10
addi t2, t2, 10 # t2 += 10
addi t3, t3, 10 # t3 += 10
addi t4, t4, 10 # t4 += 10
trueEqual:
addi t5, zero, 5 # t5 = 5
sub t0, t0, t5 # t0 -= 5 (agora 2)
sub t1, t1, t5 # t1 -= 5 (agora 2)
sub t2, t2, t5 # t2 -= 5 (agora 4)
sub t3, t3, t5 # t3 -= 5 (agora 5)
sub t4, t4, t5 # t4 -= 5 (agora 6)
bne t0, t0, notEqual # pula adicoes +1 se t0 for diferente de t0 (impossivel)
addi t0, t0, 1 # t0 += 1 (agora 3)
addi t1, t1, 2 # t1 += 2 (agora 4)
addi t2, t2, 1 # t2 += 1 (agora 5)
addi t3, t3, 1 # t3 += 1 (agora 6)
addi t4, t4, 1 # t4 += 1 (agora 7)
notEqual:
bne t0, t1, trueNotEqual # pula adicoes 20 se t0 for diferente de t1 (ACONTECE)
addi t0, t0, 20 # t0 += 20
addi t1, t1, 20 # t1 += 20
addi t2, t2, 20 # t2 += 20
addi t3, t3, 20 # t3 += 20
addi t4, t4, 20 # t4 += 20
trueNotEqual:
blt t1, t0, lessThan # pula contagem de 1 a 6 (NÃO ACONTECE)
addi t0, zero, 1 # t0 = 1
addi t1, zero, 2 # t1 = 2
addi t2, zero, 3 # t2 = 3
addi t3, zero, 4 # t3 = 4
addi t4, zero, 5 # t4 = 5
addi t5, zero, 6 # t5 = 6
lessThan:
blt t0, t1, trueLessThan # evita tudo 15 caso t0 < t1 (acontece)
addi t0, zero, 15 # t0 = 15
addi t1, zero, 15 # t1 = 15
addi t2, zero, 15 # t2 = 15
addi t3, zero, 15 # t3 = 15
addi t4, zero, 15 # t4 = 15
addi t5, zero, 15 # t5 = 15
trueLessThan:
bgeLoop:
addi t0, t0, 1 # t0 += 1
bge t5, t0, bgeLoop # Volta ao loop até que t0 seja maior que t5(6)