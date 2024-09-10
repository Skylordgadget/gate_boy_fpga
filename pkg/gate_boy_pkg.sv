// synopsys translate_off
`timescale 1ns / 1ns
// synopsys translate_on

package gate_boy_pkg;

    // project-wide localparams

    localparam DATA_WIDTH = 8;
    localparam OPCODE_WIDTH = 8;
    localparam ADDRESS_WIDTH = 16;



    /* simple clog2 for computing the minimum number of bits required for certain registers  
    ONLY USE THIS FUNCTION FOR DEFINING LOCALPARAMS AND PARAMETERS--IT IS NOT SYNTHESISABLE*/
    function integer clog2;
        input [31:0] value;
        integer i;
        begin
            clog2 = 32;
            for(i=31; i>0; i--) begin
                if (2**i >= value) begin
                    clog2 = i;
                end
            end
        end
    endfunction

    localparam NUM_INSTRUCTIONS = 46;
    localparam INSTRUCTION_T_WIDTH = clog2(NUM_INSTRUCTIONS);
    localparam FLAG_WIDTH = 8;

    typedef enum logic [2:0] { 
        Z = 3'd7,
        N = 3'd6,
        H = 3'd5,
        C = 3'd4
    } flag_t;

    typedef enum logic [INSTRUCTION_T_WIDTH-1:0] {
        LD,
        LDH,
        LD_INC,
        LD_DEC,
        PUSH,
        POP,
        ADD,
        ADC,
        SUB,
        SBC,
        CP,
        INC,
        DEC,
        AND,
        OR,
        XOR,
        CCF,
        SCF,
        DAA,
        CPL,
        RLCA,
        RRCA,
        RLA,
        RRA,
        RLC,
        RRC,
        RL,
        RR,
        SLA,
        SRA,
        SWAP,
        SRL,
        BIT,
        RES,
        SET,
        JP,
        JR,
        CALL,
        RET,
        RETI,
        RST,
        HALT,
        STOP,
        DI,
        EI,
        NOP
    } instruction_t;

endpackage