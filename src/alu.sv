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

    flags,
    result
);

    import gate_boy_pkg::*;

    // clock interface
    input logic clk;
    input logic phi; // <- still not sure about this

    input logic [DATA_WIDTH-1:0] operand_A;
    input logic [DATA_WIDTH-1:0] operand_B;
    input alu_ops_t opcode;

    output logic [FLAG_WIDTH-1:0] flags;
    output logic [DATA_WIDTH-1:0] result;

    logic [DATA_WIDTH-1:0] next_result;
    logic [FLAG_WIDTH-1:0] next_flags;

    logic [HALF_DATA_WIDTH:0] tmp;

    always_comb begin
        next_result = result;
        next_flags = {flags[HALF_DATA_WIDTH-1:0], 4'b0000};
        case (opcode)
            ADD: begin
                {next_flags[C], next_result} = operand_A + operand_B; // add
                
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                tmp = operand_A[HALF_DATA_WIDTH-1:0] + operand_B[HALF_DATA_WIDTH-1:0];
                next_flags[H] = tmp[HALF_DATA_WIDTH];
            end
            ADC: begin
                {next_flags[C], next_result} = operand_A + operand_B + flags[C]; // add width carry

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                tmp = operand_A[HALF_DATA_WIDTH-1:0] + operand_B[HALF_DATA_WIDTH-1:0] + flags[C];
                next_flags[H] = tmp[HALF_DATA_WIDTH];
            end
            SUB: begin
                {next_flags[C], next_result} = operand_A - operand_B; // subtract

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b1;
                tmp = operand_A[HALF_DATA_WIDTH-1:0] - operand_B[HALF_DATA_WIDTH-1:0];
                next_flags[H] = tmp[HALF_DATA_WIDTH];                
            end
            SBC: begin
                {next_flags[C], next_result} = operand_A - operand_B - flags[C]; // subtract with carry

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b1;
                tmp = operand_A[HALF_DATA_WIDTH-1:0] - operand_B[HALF_DATA_WIDTH-1:0] - flags[C];;
                next_flags[H] = tmp[HALF_DATA_WIDTH];                
            end
            // CP (just sub but the result is not registered, so it's not worth duplicating SUB)
            // skipping INC and DEC for now (I think they should be part of the IDU)
            AND: begin
                next_result = operand_A & operand_B; // bitwise and

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b1;
                next_flags[C] = 1'b0;
            end
            OR: begin
                next_result = operand_A | operand_B; // bitwise or

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
                next_flags[C] = 1'b0;
            end
            XOR: begin
                next_result = operand_A ^ operand_B; // bitwise xor

                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
                next_flags[C] = 1'b0;
            end
            RLC: begin
                {next_flags[C], next_result} = {operand_A, operand_A[DATA_WIDTH-1]};
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            RL: begin
                {next_flags[C], next_result} = {operand_A, next_flags[C]};
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            RRC: begin
                {next_result, next_flags[C]} = {operand_A[0], operand_A};
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            RR: begin
                {next_result, next_flags[C]} = {next_flags[C], operand_A};
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            SL: begin
                {next_flags[C], next_result} = operand_A << 1;
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            SR: begin
                {next_result, next_flags[C]} = signed'(operand_A) >>> 1;
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            SRL: begin
                {next_result, next_flags[C]} = operand_A >> 1;
                next_flags[Z] = !next_result;
                next_flags[N] = 1'b0;
                next_flags[H] = 1'b0;
            end
            // stopping here for now
        endcase        
    end

    always_ff @(posedge phi) begin
        result <= next_result[DATA_WIDTH-1:0];
        flags <= next_flags;
    end

endmodule