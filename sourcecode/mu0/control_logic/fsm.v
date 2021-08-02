`define LDA 4'b0000
`define STO 4'b0001
`define ADD 4'b0010
`define SUB 4'b0011
`define JMP 4'b0100
`define JGE 4'b0101
`define JNE 4'b0110
`define STP 4'b0111

module fsm(
    input reset,
    input clk,
    input accz,
    input acc15,
    input [3:0] opcode,
    output asel, bsel, accce, pcce, irce, accoe, memrq, rnw,
    output [1:0] alufs
    );

    reg exft;
    reg [10:0] outs;

    always @(opcode or reset or exft or accz or acc15) begin
        if (reset) outs = {1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 2'bxx, 1'b1, 1'b1, 1'b0};
        else begin
            case(opcode)
            `LDA: begin
                if(!exft) outs = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b1};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `STO: begin
                if(!exft) outs = {1'b1, 1'bx, 1'b0, 1'b0, 1'b0, 1'b1, 2'bxx, 1'b1, 1'b0, 1'b1};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `ADD: begin
                if(!exft) outs = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b1, 1'b1, 1'b1};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `SUB: begin
                if(!exft) outs = {1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'b11, 1'b1, 1'b1, 1'b1};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `JMP: outs = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0};
            `JGE: begin
                if(!acc15) outs = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `JNE: begin
                if(!accz) outs = {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0};
                else outs = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b01, 1'b1, 1'b1, 1'b0}; end

            `STP: outs = {1'b1, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 2'bxx, 1'b0, 1'b1, 1'b0};

            default: outs = {1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 2'bxx, 1'bx, 1'bx, 1'bx};
            endcase
        end /*end of else*/
    end /*end of always*/

    assign asel = outs[10];
    assign bsel = outs[9];
    assign accce = outs[8];
    assign pcce = outs[7];
    assign irce = outs[6];
    assign accoe = outs[5];
    assign alufs = outs[4:3];
    assign memrq = outs[2];
    assign rnw = outs[1];
    assign nextexft = outs[0];

    // State register
    always @(negedge clk or posedge reset) begin
        if(reset) exft <= 1'b1;
        else exft <= nextexft;
    end

endmodule