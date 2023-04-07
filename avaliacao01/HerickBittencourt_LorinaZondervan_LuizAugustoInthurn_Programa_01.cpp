// Disciplina: Arquitetura e Organização de Computadores

// Atividade: Avaliação 01 – Programação em Linguagem de Montagem

// Programa 01

// Grupo: - Hérick Vitor Vieira Bittencourt
// - Lorina Zondervan
// - Luiz Augusto Inthurn

#include <iostream>

using namespace std;

int main(){
    int Vetor_A[8]; // Vetor A
    int Vetor_B[8]; // Vetor B
    int tamanhoVetores; // Tamanho maximo dos vetores, entre [1,8]
    int temp; // Buffer temporario para segurar um dos valores durante a troca

    do { // Loop p/ obter tamanho dos vetores
        cout << "Entre com o tamanho dos vetores (max = 8): ";
        cin >>  tamanhoVetores;

        if (tamanhoVetores < 1 || tamanhoVetores > 8){ // Caso falhe, havera um aviso
            cout << "Valor invalido\n" << endl;
        }
    } while (tamanhoVetores < 1 || tamanhoVetores > 8);

    for (int i = 0; i < tamanhoVetores; i++) // Entrada de dados do Vetor_A
    {
        cout << "Vetor_A[" << i+1 << "] = ";
        cin >> Vetor_A[i];
        cout << endl;
    }

    for (int i = 0; i < tamanhoVetores; i++) // Entrada de dados do Vetor_B
    {
        cout << "Vetor_B[" << i+1 << "] = ";
        cin >> Vetor_B[i];
        cout << endl;
    }
    
    for (int i = 0; i < tamanhoVetores; i++) // Troca de valores entre vetores
    {
        temp = Vetor_A[i]; // Buffer segura o valor de Vetor_A
        Vetor_A[i] = Vetor_B[i]; // Vetor_A copia o valor de Vetor_B
        Vetor_B[i] = temp; // Vetor_B obtém o valor do buffer
    }

    cout << "Valores substituidos: " << endl;
    for (int i = 0; i < tamanhoVetores; i++) // Display do Vetor_A modificado
    {
        cout << "Vetor_A[" << i+1 << "] = " << Vetor_A[i] << endl;
    }

    for (int i = 0; i < tamanhoVetores; i++) // Display do Vetor_B modificado
    {
        cout << "Vetor_B[" << i+1 << "] = " << Vetor_B[i] << endl;
    }

    cout << "\n"; system("pause"); // remover após completar tudo
    return 0;
}