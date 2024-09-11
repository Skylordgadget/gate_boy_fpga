// synopsys translate_off
`timescale 1ns / 1ns
// synopsys translate_on

package gate_boy_pkg;

    // project-wide localparams

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

    function integer cdiv;
        input [31:0] x;
        input [31:0] y;
        begin
            cdiv = (x + y - 1) / y;
        end
    endfunction

    localparam DATA_WIDTH = 8;
    localparam HALF_DATA_WIDTH = cdiv(DATA_WIDTH, 2);
    localparam OPCODE_WIDTH = 8;
    localparam ADDRESS_WIDTH = 16;

    localparam NUM_INSTRUCTIONS = 46;
    localparam INSTRUCTION_T_WIDTH = clog2(NUM_INSTRUCTIONS);
    localparam FLAG_WIDTH = 8;

    typedef enum logic [2:0] { 
        Z = 3'd7,
        N = 3'd6,
        H = 3'd5,
        C = 3'd4
    } flag_t;

    localparam NUM_ALU_OPS = 19;
    localparam ALU_OPS_T_WIDTH = clog2(NUM_ALU_OPS);
    
    typedef enum logic[ALU_OPS_T_WIDTH-1:0] { 
        // 8 & 16 bit arithmetic
        ADD,
        INC,
        DEC,

        // 8 bit arithmetic
        ADC,
        SUB,
        SBC,
        CP,

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


endpackage