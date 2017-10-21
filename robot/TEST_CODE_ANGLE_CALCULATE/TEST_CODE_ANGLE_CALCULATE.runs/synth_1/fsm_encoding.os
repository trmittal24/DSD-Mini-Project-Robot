
 add_fsm_encoding \
       {ALL_IN_ONE.state} \
       { }  \
       {{00000000 000000} {00000001 000001} {00000010 000010} {00000011 000011} {00010010 000100} {00010011 000101} {00100000 000110} {00100001 000111} {00110000 001000} {00110001 001001} {01000000 001010} {01000001 001011} {01010000 001100} {01010001 001101} {01010010 001110} {01010011 001111} {01010100 010000} {01110000 010001} {01110001 010010} {01110010 010011} {10000010 010100} {10000011 010101} {10010010 010110} {10010011 010111} {11000000 011001} {11000001 011010} {11010000 011011} {11010001 100000} {11010010 011100} {11010011 011101} {11010100 011110} {11010101 011111} {11101110 011000} }

 add_fsm_encoding \
       {UART_TX.r_SM_Main} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {MAIN.STATE} \
       { }  \
       {{00000 00011} {00001 00100} {00010 00101} {00011 00110} {00100 00111} {00101 01000} {00110 01001} {00111 01010} {01000 01011} {01001 01100} {01010 01101} {01011 01110} {01100 01111} {01101 10000} {01110 10001} {01111 00000} {10000 00001} {10001 00010} }
