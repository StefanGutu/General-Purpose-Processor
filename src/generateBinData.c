#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// 1 , 2, 3, 4
const char* mem_instr[4] = {"LDR", "STR", "STA", "LDA"};

// 5, 6, 7, 8, 9, 10, 11
const char* branch_instr[7] = {"BRZ", "BRN", "BRC", "BRO", "BRA", "JMP", "RET"};

//12 - 29
const char* alu_instr[18] = {"ADD", "SUB", "LSR", "LSL", "RSR", "RSL", "MOV", "MUL", "DIV",
                "MOD", "AND", "OR", "XOR", "NOT", "CMP", "TST", "INC", "DEC"};

//30
const char* crypto = {"CRP"};

//31
const char* end = {"HLT"};

//For reg X and Y
const char *reg = {"X"};

//Function to convert from decimal to binary
void decimalToBinaryString(int num,int decimal_num, char *binary_str) {

        // Inițializăm șirul de caractere cu zerouri pentru 6 biți și terminatorul de șir
        for (int i = 0; i < num; i++) {
            binary_str[i] = '0';
        }
        binary_str[num] = '\0'; // Terminatorul de șir

        // Construim șirul binar de la dreapta la stânga
        int index = num-1; // Ultimul index al șirului
        while (decimal_num > 0 && index >= 0) {
            binary_str[index] = (decimal_num % 2) ? '1' : '0';
            decimal_num /= 2;
            index--;
        }
}



int main() {
    FILE *file;

    if((file = fopen("assembly.txt", "r")) == NULL){
        printf("Error to open assembly.txt to read!");
        exit(EXIT_FAILURE);
    }

    FILE *out;

    if((out = fopen("res_in_bin.txt","w")) == NULL){
        printf("Error to open res_in_bin.txt to write!");
        exit(EXIT_FAILURE);
    }

    char assembly_line[256];  // Citirea unei linii
    char instruction[10];     // Instrucțiunea
    char registerName[10];    // Registrul (X sau Y)
    int value;
    int address; // adresa pt branch

    char val_for_instr[7];    // Șir binar pentru instrucțiune (6 biți)
    char val_for_reg[2];      // Valoare binară pentru registre (1 bit)
    char val_for_imd[10];     // Valoare binară pentru numere (9 biți)
    char val_for_address[11]; // valoare binara pentru adresa (10 biti)

    char end[17] = "0000000000000000";  //Valoare binara pentru end file (16 biti)

    while ((fgets(assembly_line, sizeof(assembly_line), file)) != NULL) {
        assembly_line[strcspn(assembly_line, "\n")] = '\0';

        
        char final_bin_line[17] = ""; 
        int branch_or_no = 0;

        if (sscanf(assembly_line, "%s %s #%d", instruction, registerName, &value) == 3) {
            branch_or_no = 1;
            decimalToBinaryString(9, value, val_for_imd);
            
            if (strcmp(registerName, reg) == 0) {
                val_for_reg[0] = '0'; 
            }else {
                val_for_reg[0] = '1';
            }

            val_for_reg[1] = '\0';

            
            if (strcmp(instruction, mem_instr[0]) == 0) { // Pt LDR
                decimalToBinaryString(6, 1, val_for_instr);
            } else if (strcmp(instruction, mem_instr[1]) == 0) { //PT STR
                decimalToBinaryString(6, 2, val_for_instr);
            } else {
                for (int i = 0; i < 18; i++) { //Aici is alu instruction si le scrie codu
                    if (strcmp(alu_instr[i], instruction) == 0) {
                        decimalToBinaryString(6, i + 12, val_for_instr);
                        break;
                    }
                }
            }
        } else if (sscanf(assembly_line, "%s #%d", instruction, &address) == 2) {
            branch_or_no = 2;
            
            decimalToBinaryString(10,address,val_for_address);


            for (int i = 0; i < 7; i++) { //Pt branch instruction 
                if (strcmp(branch_instr[i], instruction) == 0) {
                    decimalToBinaryString(6, i + 5, val_for_instr);
                    break;
                }
            }
        } else if (sscanf(assembly_line, "%s", instruction) == 1) {

            branch_or_no = 3;

            
        }else {   
            printf("Error: Line format is incorrect.\n");
            continue;
        }

        if(branch_or_no == 1){

            strcat(final_bin_line, val_for_instr);
            strcat(final_bin_line, val_for_reg);
            strcat(final_bin_line, val_for_imd);
        }else if(branch_or_no == 2){

            strcat(final_bin_line, val_for_instr);
            strcat(final_bin_line, val_for_address);
        }else if ( branch_or_no == 3){
            strcat(final_bin_line, end);
        }

        printf("Final: %s\n", final_bin_line);
        fprintf(out,"%s\n",final_bin_line);
    }

    fclose(file);
    fclose(out);
    return 0;
}