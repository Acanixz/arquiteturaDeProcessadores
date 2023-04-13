// Disciplina: Arquitetura e Organização de Computadores

// Atividade: Avaliação 01 – Programação em Linguagem de Montagem

// Programa 02

// Grupo: - Hérick Vitor Vieira Bittencourt
// - Lorina Zondervan
// - Luiz Augusto Inthurn

#include <iostream>
#include <string>
using namespace std;

// Definição das variaveis
int arrayAulas[16];
string texto_fornecaAula = "Forneca o dia da aula (entre 0 e 15): ";
string texto_fornecaAluno = "Escolha um aluno (entre 0 e 31): ";
string texto_fornecaPresenca = "Este aluno esta/esteve presente?\n1- Sim\n0- Nao\n";
string texto_sucesso = "Operacao concluida com sucesso\n";
string texto_solicitarValoresFailsafe = "Um dos valores fornecidos eh invalido, tente novamente\n\n";
int diasMax = 16;
int alunosMax = 32;

void solicitarValores(int &aula, int &aluno,int &registro){
inicio: // label para inicio da solicitação
    cout << texto_fornecaAula; // Mensagem solicitando indice
    cin >> aula;

    // branches para a label failsafe
    if (aula < 0) goto failsafe;
    if (aula >= diasMax) goto failsafe;

    cout << texto_fornecaAluno; // Mensagem solicitando bit
    cin >> aluno;

    // branches para a label failsafe
    if (aluno < 0) goto failsafe;
    if (aluno >= alunosMax) goto failsafe;

    cout << texto_fornecaPresenca; // Mensagem solicitando valor do bit
    cin >> registro;

    // branches para a label failsafe
    if (registro < 0) goto failsafe;
    if (registro > 1) goto failsafe;

    return; // Caso não tenha caido no failsafe, função é concluida

failsafe: // label failsafe, código pula aqui caso a entrada seja invalida
    cout << texto_solicitarValoresFailsafe << endl; // Mensagem de erro

    // Reset da entrada de dados
    cin.clear();
    cin.ignore(10000, '\n');

    goto inicio; // Volta para o começo da função sem incrementar stack
}

void editarAluno(int &aula,int &aluno,int &registro){
    int resultado;
    
    // Move 1 até o bit de aluno desejado e inverte os bits da mascara
    int mascaraBinaria = ~(1 << aluno);

    // Mascara binária reseta o bit do aluno
    resultado = (arrayAulas[aula] & mascaraBinaria);

    // registroFinal é o valor desejado movido até o bit do aluno
    int registroFinal = (registro << aluno);

    // Bit do aluno é modificado para o valor desejado
    resultado = (resultado | registroFinal);

    // resultado é salvo no arrayAulas
    arrayAulas[aula] = resultado;
    cout << texto_sucesso << endl; // Mensagem de operação concluida
    return;
}

void loop(){
    while (true){
        // Reset dos valores a cada iteração do loop, seguido das operações
        int aulaEscolhida = 0;
        int alunoEscolhido = 0;
        int registroPresenca = 0;
        solicitarValores(aulaEscolhida, alunoEscolhido, registroPresenca);
        editarAluno(aulaEscolhida, alunoEscolhido, registroPresenca);
    }
    
}

int main(){
    // Define todos os valores de arrayAulas para 0XFFFFFFFF
    for (int i = 0; i < diasMax; i++){
        arrayAulas[i] = -1;
    }
    loop(); // Entrada do loop
    return 0;
}