`timescale 1ns / 1ns

module idu_tb ();
    import gate_boy_pkg::*;

    localparam CLK_PERIOD = 250; // 250 ns -> 1/250ns = 4MHz

    logic clk;
    logic phi;
    // logic rst; 

    logic [2*DATA_WIDTH-1:0] operand;

    idu_ops_t opcode;

    logic [2*DATA_WIDTH-1:0] result;


    initial clk = 1'b1;
    initial phi = 1'b1;
    always #(CLK_PERIOD/2) clk = ~clk; // start clonking the clonk and don't stop the clonk
    always #(CLK_PERIOD*2) phi = ~phi; 

    idu idu (
        .clk    (clk),
        .phi    (phi),

        .operand  (operand),

        .opcode     (opcode),

        .result     (result)
    );

    mailbox op_mbx = new(100);

    logic [DATA_WIDTH-1:0] tb_result;

    initial begin
        opcode = opcode.first();
        for (int k=0; k<2'b11; k++) begin
            for (int i=0; i<{2*DATA_WIDTH{1'b1}}; i++) begin

                #(CLK_PERIOD*4);
                operand <= i;

                case (opcode)
                    INC16: begin
                        tb_result = i + 1'b1; // Will be 0 extended?
                    end
                    DEC16: begin
                        tb_result = i - 1'b1; // Will be 0 extended?
                    end
                endcase

                op_mbx.put(tb_result);
            end
            opcode = opcode.next();
        end
        $display("Test completed successfully");
        $stop;
    end

    initial begin
        logic [DATA_WIDTH-1:0] op_mbx_received;
        static bit err = 1'b0;
        #((CLK_PERIOD*4)*2); // delay by two cycles of phi
        forever begin
            #(CLK_PERIOD*4);
            op_mbx.get(op_mbx_received);
             
            if (op_mbx_received != result) begin
                $display("discrepency between expected result: %d, and received result: %d", op_mbx_received, result);
                err = 1'b1;
            end

            if (err) begin
                err = 1'b0;
                $stop;
            end
            
        end
    end

endmodule