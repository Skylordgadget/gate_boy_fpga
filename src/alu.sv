////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Filename:       alu.sv                                                    //
//  Author:         Harry Kneale-Roby & Alex Marshall                         //
//  Description:    Game Boy ALU                                              //
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

    // do we want a separate output port for flags?
    result
);

    import gate_boy_pkg::*;

    // clock interface
    input logic clk;
    input logic phi; // <- still not sure about this

    input logic [DATA_WIDTH-1:0] operand_A;
    input logic [DATA_WIDTH-1:0] operand_B;
    input logic [OPCODE_WIDTH-1:0] opcode;

    output logic [DATA_WIDTH-1:0] result;

    // typedef or state machine ?
    // I reckon state machine since, opcodes can have dont-care bits

    always_ff @(posedge clk) begin
        result <= operand_A + operand_B; // placeholder
    end

endmodule