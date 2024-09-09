`timescale 1ns / 1ns

module adc_tb ();
    import gate_boy_pkg::*;

    localparam CLK_PERIOD = 250; // 250 ns -> 1/250ns = 4MHz

    logic clk;
    logic phi;
    // logic rst; 

    logic [DATA_WIDTH-1:0] operand_A;
    logic [DATA_WIDTH-1:0] operand_B;

    logic [OPCODE_WIDTH-1:0] opcode;

    logic [DATA_WIDTH-1:0] result;

    initial clk = 1'b1;
    initial phi = 1'b1;
    always #(CLK_PERIOD/2) clk = ~clk; // start clonking the clonk and don't stop the clonk
    always #(CLK_PERIOD*2) phi = ~phi; 

    adc adc (
        .clk    (clk),
        .phi    (phi),

        .operand_A  (operand_A),
        .operand_B  (operand_B),

        .opcode     (opcode),

        .result     (result)
    );

    initial begin
        operand_A = {DATA_WIDTH{1'b0}};
        operand_B = {DATA_WIDTH{1'b0}};
        opcode = {OPCODE_WIDTH{1'b0}};
        #100; // 100ns (this is naughty we should really advance by multiples of the clock period--I will do this when I write a proper TB)
        operand_A = 8'd1;
        operand_B = 8'd1;

    end

endmodule