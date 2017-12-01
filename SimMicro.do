vsim -L altera_mf_ver -L lpm_ver -L cycloneiv_ver Microprocessor

add wave -position end  sim:/Microprocessor/CLK
add wave -position end  sim:/Microprocessor/RST
# add wave -position end  sim:/Microprocessor/FowardA
# add wave -position end  sim:/Microprocessor/FowardB
# add wave -position end  sim:/Microprocessor/DecExeBuffer_OpA
# add wave -position end  sim:/Microprocessor/DecExeBuffer_OpB
# add wave -position end  sim:/Microprocessor/DecExeBuffer_OpC
# add wave -position end  sim:/Microprocessor/DecExeBuffer_OpULA
add wave -position end  sim:/Microprocessor/DecExeBufferCtrl_AddrImm
add wave -position end  sim:/Microprocessor/DecExeBufferCtrl_IsImm
add wave -position end  sim:/Microprocessor/DecExeBufferCtrl_HasWB
add wave -position end  sim:/Microprocessor/DecExeBufferCtrl_HasStall
add wave -position end  sim:/Microprocessor/DecExeBufferCtrl_IsJump
add wave -position end  sim:/Microprocessor/ExeWBBuffer_Res
add wave -position end  sim:/Microprocessor/ExeWBBuffer_FlagReg
add wave -position end  sim:/Microprocessor/ExeWBBufferCtrl_RegDest
add wave -position end  sim:/Microprocessor/ExeWBBufferCtrl_AddrImm
add wave -position end  sim:/Microprocessor/ExeWBBufferCtrl_HasWB
add wave -position end  sim:/Microprocessor/ExeWBBufferCtrl_HasJumped
add wave -position 26  sim:/Microprocessor/updateJmpPC
add wave -position end  sim:/Microprocessor/instr
# add wave -position end  sim:/Microprocessor/progCounter
# add wave -position end  sim:/Microprocessor/opCode
# add wave -position end  sim:/Microprocessor/opA
# add wave -position end  sim:/Microprocessor/opB
# add wave -position end  sim:/Microprocessor/opC
# add wave -position end  sim:/Microprocessor/opULA
add wave -position end  sim:/Microprocessor/addrImm
add wave -position end  sim:/Microprocessor/isImm
add wave -position end  sim:/Microprocessor/hasWB
add wave -position end  sim:/Microprocessor/hasStall
add wave -position end  sim:/Microprocessor/isJump
add wave -position end  sim:/Microprocessor/decExeBufferWr
add wave -position end  sim:/Microprocessor/exeWBBufferWr
add wave -position end  sim:/Microprocessor/pcRegWr
add wave -position end  sim:/Microprocessor/regBankWr
add wave -position end  sim:/Microprocessor/isDecStall
add wave -position end  sim:/Microprocessor/clrStall
add wave -position end  sim:/Microprocessor/hasJumped
add wave -position end  sim:/Microprocessor/pcExtSrc
add wave -position end  sim:/Microprocessor/newPC
add wave -position end  sim:/Microprocessor/PC
add wave -position end  sim:/Microprocessor/regA
add wave -position end  sim:/Microprocessor/regB
add wave -position end  sim:/Microprocessor/operandA
add wave -position end  sim:/Microprocessor/operandB
add wave -position end  sim:/Microprocessor/res
add wave -position end  sim:/Microprocessor/flagReg
add wave -position end  sim:/Microprocessor/outMuxImm
add wave -position end  sim:/Microprocessor/ExeWBBuffer_HasJumped
add wave -position end  sim:/Microprocessor/ctrlDecode/DecodeState
add wave -position end  sim:/Microprocessor/ctrlExecute/ExecutionState
add wave -position end  sim:/Microprocessor/ctrlWriteback/WriteBackState

force -freeze sim:/Microprocessor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/Microprocessor/RST 1 0
run
force -freeze sim:/Microprocessor/RST 0 0

mem load -skip 0 -filltype value -filldata 1 -fillradix symbolic -startaddress 0 -endaddress 0 /Microprocessor/regBank/RegBank

mem load -skip 0 -filltype value -filldata 0 -fillradix symbolic -startaddress 0 -endaddress 0 /Microprocessor/regBank/RegBank
mem load -skip 0 -filltype value -filldata 100 -fillradix symbolic -startaddress 15 -endaddress 15 /Microprocessor/regBank/RegBank


ADDI R0, 1, R0			0
ADD R2, R0, R1 			1
ADD R3, R2, R1 			2
ADD R4, R3, R2			3
ADD R5, R4, R3			4
JMP 000000000000		5
ADD R15, R5, R0			6
ADDI R1, 1, R1 			7

1001000000010000
0000001000000001
0000001100100001
0000010000110010
0000010101000011
1011000000000000
0000111101010000
1001000100010001


0	ADDI R0, 1, R0
1	ADD R1, R0, R1
2	BEZ R15, R1
3	SUBI R1, 1, R1
4	ADDI R4, 3, R4
5	BEZ R14, R1

1001000000010000
0000000100000001
1100000011110001
1010000100010001
1001010000110100
1100000011100001

mem load -skip 0 -filltype value -filldata 101 -fillradix symbolic -startaddress 15 -endaddress 15 /Microprocessor/regBank/RegBank

R14 = 0
R15 = 5


0	ADDI R0, 1, R0
1	ADDI R1, 1, R1
2	ADDI R2, 1, R2
3	ADDI R3, 1, R3
4	BEZ R14, R4
5	ADDI R5, 1, R5
6	ADDI R6, 1, R6
7	BEZ R15, R7
8	ADD R8, 3, R8
9	ADD R9, 3, R9
10	JMP 000000001010


1001000000010000
1001000100010001
1001001000010010
1001001100010011
1100000011100100
1001010100010101
1001011000010110
1100000011110111
1001100000011000
1001100100011001
1011000000001010



mem load -skip 0 -filltype value -filldata 1111 -fillradix symbolic -startaddress 0 -endaddress 0 /Microprocessor/regBank/RegBank
mem load -skip 0 -filltype value -filldata 10100 -fillradix symbolic -startaddress 1 -endaddress 1 /Microprocessor/regBank/RegBank
mem load -skip 0 -filltype value -filldata 101 -fillradix symbolic -startaddress 15 -endaddress 15 /Microprocessor/regBank/RegBank

R0 = 15
R1 = 20
R15 = 5

MUL R1, R0
GHI R3
GLO R2
BEZ R15, R7
ADDI R6, 6, R6
JMP 000000000000

1101000000010000
1110001100000000
1111001000000000
1100000011110111
1001011001100110
1011000000000000

