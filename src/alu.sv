////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Filename:       alu.sv                                                    //
//  Author:         Harry Kneale-Roby & Alex Marshall                         //
//  Description:    Game Boy ALU and IDU                                      //
//  TODO:           Everything                                                //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

module alu (
    clk,    // 4MHz clock
    phi,    // 1MHz clock <- not sure if we should use two clock lines
    // rst <- idk if we're using a reset

    operand_A,
    operand_B,

    opcode,

    flags,
    result
);

    import gate_boy_pkg::*;

    // clock interface
    input logic clk;
    input logic phi; // <- still not sure about this

    input logic [DATA_WIDTH-1:0] operand_A;
    input logic [DATA_WIDTH-1:0] operand_B;
    input instruction_t opcode;

    output logic [FLAG_WIDTH-1:0] flags;
    output logic [DATA_WIDTH-1:0] result;

    logic [DATA_WIDTH:0] next_result;
    logic [FLAG_WIDTH-1:0] next_flags;
    logic [4:0] bottom;

    always_comb begin
        next_result = {1'b0, result};
        next_flags = {flags, 4'b0000};
        case (opcode)
            ADD: begin
                next_result = operand_A + operand_B;
                next_flags[Z] = !(next_result[DATA_WIDTH-1:0]);
                next_flags[N] = 1'b0;

                bottom = operand_A[3:0] + operand_B[3:0];
                next_flags[H] = bottom[4];

                next_flags[C] = next_result[DATA_WIDTH-1];
            end
        endcase        
    end

    always_ff @(posedge phi) begin
        result <= next_result[DATA_WIDTH-1:0];
        flags <= next_flags;
    end

endmodule