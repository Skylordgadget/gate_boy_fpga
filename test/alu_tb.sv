`timescale 1ns / 1ns

module alu_tb ();
    import gate_boy_pkg::*;

    localparam CLK_PERIOD = 250; // 250 ns -> 1/250ns = 4MHz

    logic clk;
    logic phi;
    // logic rst; 

    logic [DATA_WIDTH-1:0] operand_A;
    logic [DATA_WIDTH-1:0] operand_B;

    alu_ops_t opcode;

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

    mailbox op_mbx = new(100);
    mailbox fl_mbx = new(100);

    logic [DATA_WIDTH-1:0] tb_result;
    logic [FLAG_WIDTH-1:0] tb_flags;
    logic [HALF_DATA_WIDTH:0] tb_tmp;

    initial begin
        opcode = ADD;
        for (int i=0; i<{DATA_WIDTH{1'b1}}; i++) begin
            for (int j=0; j<{DATA_WIDTH{1'b1}}; j++) begin

                #(CLK_PERIOD*4);
                tb_flags = {FLAG_WIDTH{1'b0}};
                operand_A <= i;
                operand_B <= j;

                case (opcode)
                    ADD: begin
                        {tb_flags[C], tb_result} = i + j;
                        tb_flags[N] = 0;
                        tb_flags[Z] = !tb_result;
                        tb_tmp = i[HALF_DATA_WIDTH-1:0] + j[HALF_DATA_WIDTH-1:0];
                        tb_flags[H] = tb_tmp[HALF_DATA_WIDTH];
                    end
                endcase

                op_mbx.put(tb_result);
                fl_mbx.put(tb_flags);
            end
        end
        $display("Test completed successfully");
        $stop;
    end

    initial begin
        logic [DATA_WIDTH-1:0] op_mbx_received;
        logic [FLAG_WIDTH-1:0] fl_mbx_received;
        static bit err = 1'b0;
        #((CLK_PERIOD*4)*2); // delay by two cycles of phi
        forever begin
            #(CLK_PERIOD*4);
            op_mbx.get(op_mbx_received);
            fl_mbx.get(fl_mbx_received);
             
            if (op_mbx_received != result) begin
                $display("discrepency between expected result: %d, and received result: %d", op_mbx_received, result);
                err = 1'b1;
            end

            if (fl_mbx_received != flags) begin
                $display("discrepency between expected flags: %b, and received flags: %b", fl_mbx_received, flags);
                err = 1'b1;
            end

            if (err) begin
                err = 1'b0;
                $stop;
            end
            
        end
    end

endmodule