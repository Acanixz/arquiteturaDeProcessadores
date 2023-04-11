// Disciplina: Arquitetura e Organização de Computadores

// Atividade: Avaliação 01 – Programação em Linguagem de Montagem

// Programa 02

// Grupo: - Hérick Vitor Vieira Bittencourt
// - Lorina Zondervan
// - Luiz Augusto Inthurn

#include <iostream>
#include <string>
using namespace std;

int arrayAulas[16] = {-1};
string texto_fornecaAula = "Forneca o dia da aula (entre 0 e 15): ";
string texto_fornecaAluno = "Escolha um aluno (entre 0 e 31): ";
string texto_fornecaPresenca = "Este aluno esta/esteve presente?\n1- Sim\n0- Nao\n";
string texto_sucesso = "Operacao concluida com sucesso\n";
string texto_solicitarValoresFailsafe = "Um dos valores fornecidos eh invalido, tente novamente\n\n";
int diasMax = 16;
int alunosMax = 32;

void solicitarValores(int &aula, int &aluno,int &registro){
inicio:
    bool falha = false;
    cout << texto_fornecaAula;
    cin >> aula;

    if (aula < 0) goto failsafe;
    if (aula >= diasMax) goto failsafe;

    cout << texto_fornecaAluno;
    cin >> aluno;

    if (aluno < 0) goto failsafe;
    if (aluno >= alunosMax) goto failsafe;

    cout << texto_fornecaPresenca;
    cin >> registro;

    if (registro < 0) goto failsafe;
    if (registro > 1) goto failsafe;

    if (falha == false) return;

failsafe:
    cout << texto_solicitarValoresFailsafe << endl;

    cin.clear();
    cin.ignore(10000, '\n');

    goto inicio;
}

void editarAluno(int &aula,int &aluno,int &registro){
    int resultado;
    
    int mascaraBinaria = ~(1 << aluno);

    resultado = (arrayAulas[aula] && mascaraBinaria);
    int registroFinal = (registro << aula);
    resultado = (resultado || aula);

    arrayAulas[aula] = resultado;
    return;
}

void loop(){
    while (true){
        int aulaEscolhida = 0;
        int alunoEscolhido = 0;
        int registroPresenca = 0;
        solicitarValores(aulaEscolhida, alunoEscolhido, registroPresenca);
        editarAluno(aulaEscolhida, alunoEscolhido, registroPresenca);
    }
    
}

int main(){
    loop();
    return 0;
}