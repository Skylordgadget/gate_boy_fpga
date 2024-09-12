////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Filename:       idu.sv                                                    //
//  Author:         Harry Kneale-Roby & Alex Marshall                         //
//  Description:    Game Boy IDU                                              //
//  TODO:           Everything                                                //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

module idu (
    clk,    // 4MHz clock
    phi,    // 1MHz clock <- not sure if we should use two clock lines
    // rst <- idk if we're using a reset

    operand,

    opcode,

    result
);

    import gate_boy_pkg::*;

    // clock interface
    input logic clk;
    input logic phi; // <- still not sure about this

    input logic [2*DATA_WIDTH-1:0] operand;
    input idu_ops_t opcode;

    output logic [2*DATA_WIDTH-1:0] result;
    logic [2*DATA_WIDTH-1:0] next_result;

    always_comb begin
        next_result = {1'b0, result};
        case (opcode)
            INC16: begin
                next_result = operand + 1'b1; // Will be 0 extended?
            end DEC16: begin
                next_result = operand - 1'b1; // Will be 0 extended?
            end
        endcase        
    end

    always_ff @(posedge phi) begin
        result <= next_result[2*DATA_WIDTH-1:0];
    end

endmodule