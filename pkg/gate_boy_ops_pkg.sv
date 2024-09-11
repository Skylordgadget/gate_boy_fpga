
// synopsys translate_off
`timescale 1ns / 1ns
// synopsys translate_on

package gate_boy_ops_pkg;
    typedef enum { 
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
    } alu_ops;

    typedef enum {
        // Loads, jumps, subroutines, stack-tomfoolery, misc
    } control_ops;
endpackage