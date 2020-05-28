--- MOVIMENTACÕES ---

LOAD [REG] [MEM]
opcode reg mem
0000 xxxxxx xxxxxx

STORE [MEM] [REG]
opcode mem reg
0001 xxxxxx xxxxxx

MOVE [REG1] [REG2]
opcode reg reg
0010 xxxxxx xxxxxx


--- OPERAÇÕES ---

ADD [REG1] [REG2] [REG3]
opcode reg1 reg2 reg3
0011 xxxx xxxx xxxx

SUB [REG1] [REG2] [REG3]
opcode reg1 reg2 reg3
0100 xxxx xxxx xxxx

AND [REG1] [REG2] [REG3]
opcode reg1 reg2 reg3
0101 xxxx xxxx xxxx

OR [REG1] [REG2] [REG3]
opcode reg1 reg2 reg3
0110 xxxx xxxx xxxx


--- BRANCHES ---

BRANCH [MEM]
opcode mem
0111 xxxxxxxxxxxx

BZERO [MEM]
opcode mem
1000 xxxxxxxxxxxx

BNEG [MEM]
opcode mem
1001 xxxxxxxxxxxx


--- OUTROS ---
NOP 
1010 xxxxxxxxxxxx

HALT
1011 xxxxxxxxxxxx
1111 xxxxxxxxxxxx



