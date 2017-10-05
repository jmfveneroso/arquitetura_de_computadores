#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int readandparse(const char* fileIn, const char* fileOut);
int parseInstr(char* header, char* opC, char* opB, char* opA, char* parsed);
int regtoint(char* reg);
void intToBit(int a, char *buffer, int res);

typedef struct
{
	char mnemonic[10];
	int code;
	int isImm;
} InstrCode;

#define		NMAXINSTR	11

/* Instruction table */
InstrCode instrtable[11] = { {.mnemonic = "ADD",  .code = 0, .isImm = 0 },
						 	 {.mnemonic = "SUB",  .code = 1, .isImm = 0 },
					 		 {.mnemonic = "STLI", .code = 2, .isImm = 1 },
							 {.mnemonic = "AND",  .code = 3, .isImm = 0 },
							 {.mnemonic = "OR",   .code = 4, .isImm = 0 },
							 {.mnemonic = "XOR",  .code = 5, .isImm = 0 },
							 {.mnemonic = "ANDI", .code = 6, .isImm = 1 },
							 {.mnemonic = "ORI",  .code = 7, .isImm = 1 },
							 {.mnemonic = "XORI", .code = 8, .isImm = 1 },
							 {.mnemonic = "ADDI", .code = 9, .isImm = 1 },
							 {.mnemonic = "SUBI", .code = 10, .isImm = 1}
					};

int main(int nargs, char** args)
{
	if ( nargs < 2 || nargs > 3 )
	{
		printf("Wrong argument number!\n");
		return -1;
	}

	readandparse(args[1], args[2]);

	return 0;
}

char* startmsg = "# Iniciando máquina\nforce -freeze sim:/TesteULA/CLK 1 0, 0 {50 ps} -r 100\nforce -freeze sim:/TesteULA/RST 1 0\nrun\nforce -freeze sim:/TesteULA/RST 0 0\nrun\n## Execução de instruções. Forma: INSTR	DST, IMM|REGB, REGA\n";

char* msgpt1 = "# ";
char* msgpt2 = "force -freeze sim:/TesteULA/Instr ";
char* msgpt3 = " 0\nrun 400\n";

/* Opens the file and get all the lines */
int readandparse(const char* fileIn, const char* fileOut)
{
	FILE *f = fopen(fileIn, "r");
	if ( f == NULL )
	{
		printf("Cannot read the file %s!!\n", fileIn);
		return 0;
	}

	FILE *out = fopen(fileOut, "w");
	if ( out == NULL )
	{
		printf("Cannot create the file %s!!\n", fileOut);
		return 0;
	}	

	char buffer[64];
	char outbuffer[17];
	int nlines = 0;

	fwrite(startmsg, sizeof(char), strlen(startmsg), out);

	while (1)
	{
		if ( fgets(buffer, 64, f) != NULL )
		{
			printf("Parsing Instruction line(%d) %s", nlines, buffer);
			nlines++;

			char inst[64];
			char header[20];
			char opC[20];
			char opB[20];
			char opA[20];

			strcpy(inst, buffer);
			strcpy(header, strtok(buffer, ","));		// Header + first op
			strcpy(opB, strtok(NULL, ","));
			strcpy(opA, strtok(NULL, ","));
			strtok(header, " ");
			strcpy(opC, strtok(NULL, " "));

			strcpy(opB, strtok(opB, " "));
			strcpy(opA, strtok(opA, " "));

			if ( header == NULL || opB == NULL || opA == NULL || opC == NULL )
			{
				/* Something went wrong... */
				printf("Something went wrong..\n");
				break;
			}

			/* Start to parse the instruction */
			if ( parseInstr(header, opC, opB, opA, outbuffer) ) {
				printf("FORMAT ERROR, VERIFY YOUR CODE!\n");
				break;
			}

			fwrite(msgpt1, sizeof(char), strlen(msgpt1), out);
			fwrite(inst, sizeof(char), strlen(inst), out);
			fwrite(msgpt2, sizeof(char), strlen(msgpt2), out);
			fwrite(outbuffer, sizeof(char), strlen(outbuffer), out);
			fwrite(msgpt3, sizeof(char), strlen(msgpt3), out);
		}
		else
		{
			break;
		}
	}

	printf("Total lines: %d\n", nlines);

	fclose(f);
	fclose(out);
}

int parseInstr(char* header, char* opC, char* opB, char* opA, char* parsed)
{
	int i;
	for ( i = 0; i < NMAXINSTR; i++ )
	{
		if ( !strcmp(header, instrtable[i].mnemonic) ) {
			break;
		}
	}

	if ( i == NMAXINSTR )
	{
		return -1;
	}

	intToBit(instrtable[i].code, parsed, 4);

	char tmp[5];
	int regA, regB, regC;

	switch (instrtable[i].isImm)
	{
		case 0:			// ADD
			regC = regtoint(opC);
			regB = regtoint(opB);
			regA = regtoint(opA);

			if ( regC < 0 || regB < 0 || regA < 0 ) {
				printf("problem parsing regs\n");
				return -1;
			}

			intToBit(regC, tmp, 4);
			strncpy(parsed + 4, tmp, 4);
			intToBit(regB, tmp, 4);
			strncpy(parsed + 8, tmp, 4);
			intToBit(regA, tmp, 4);
			strncpy(parsed + 12, tmp, 4);
			break;
		case 1:
			regC = regtoint(opC);
			regB = atoi(opB);
			regA = regtoint(opA);

			if ( regC < 0 || regB < 0 || regA < 0 ) {
				printf("problem parsing regs imm\n");
				return -1;
			}

			intToBit(regC, tmp, 4);
			strncpy(parsed + 4, tmp, 4);
			intToBit(regB, tmp, 4);
			strncpy(parsed + 8, tmp, 4);
			intToBit(regA, tmp, 4);
			strncpy(parsed + 12, tmp, 4);
			break;
		default:
			return -1;
			break;
	}

	parsed[16] = 0;

	return 0;
}

/* Return register number in integer form */
int regtoint(char* reg)
{
	if ( strcmp(strtok(reg, "["), "r") )
		return -1;
	return atoi(strtok(NULL, "]"));
}

/* Int to binary string */
void intToBit(int a, char *buffer, int res)
{
	for ( int i = 0; i < res; i++ )
	{
		buffer[i] = ((a >> (res - 1 - i)) & 1) + '0';
	}
	buffer[res] = '0';
}