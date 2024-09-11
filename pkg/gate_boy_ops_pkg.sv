
// synopsys translate_off
`timescale 1ns / 1ns
// synopsys translate_on

package gate_boy_ops_pkg;

    localparam NUM_ALU_OPS = 19;
    localparam ALU_OPS_T_WIDTH = clog2(NUM_ALU_OPS);
    typedef enum logic[ALU_OPS_T_WIDTH:0] { 
        // 8 & 16 bit arithmetic
        ADD,
        INC,
        DEC,

        // 8 bit arithmetic
        ADC,
        SUB,
        SBC,
        CP

        // 8 bit logical
        AND,
        OR,
        XOR,

        // Shift operations
        RL,
        RLC,
        RLCA,
        RR,
        RRC,
        RRCA,        
        SLA,
        SRA,
        SRL
    } alu_ops_t;

    typedef enum {
        // Loads, jumps, subroutines, stack-tomfoolery, misc
    } control_ops_t;
endpackage