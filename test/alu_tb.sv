`timescale 1ns / 1ns

module alu_tb ();
    import gate_boy_pkg::*;

    localparam CLK_PERIOD = 250; // 250 ns -> 1/250ns = 4MHz

    logic clk;
    logic phi;
    // logic rst; 

    logic [DATA_WIDTH-1:0] operand_A;
    logic [DATA_WIDTH-1:0] operand_B;

    instruction_t opcode;

    logic [FLAG_WIDTH-1:0] flags;
    logic [DATA_WIDTH-1:0] result;


    initial clk = 1'b1;
    initial phi = 1'b1;
    always #(CLK_PERIOD/2) clk = ~clk; // start clonking the clonk and don't stop the clonk
    always #(CLK_PERIOD*2) phi = ~phi; 

    alu alu (
        .clk    (clk),
        .phi    (phi),

        .operand_A  (operand_A),
        .operand_B  (operand_B),

        .opcode     (opcode),

        .result     (result),
        .flags      (flags)
    );

    initial begin
        opcode = ADD;
        for (int i=0; i<{DATA_WIDTH{1'b1}}; i++) begin
            for (int j=0; j<{DATA_WIDTH{1'b1}}; j++) begin
                #(CLK_PERIOD*4);
                operand_A <= i;
                operand_B <= j;
            end
        end
        $display("Test completed successfully");
        $stop;
    end

endmodule