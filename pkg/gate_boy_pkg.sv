// synopsys translate_off
`timescale 1ns / 1ns
// synopsys translate_on

package gate_boy_pkg;

    // project-wide localparams


    localparam DATA_WIDTH = 8;
    localparam OPCODE_WIDTH = 8;
    localparam ADDRESS_WIDTH = 16;

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

endpackage