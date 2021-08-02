module mem_model (
    input clk,
    input memrq,
    input rnw,
    input [11:0] addr,
    inout [15:0] data
    );

reg [15:0] mem [4095:0];

assign data = memrq & rnw ? mem[addr]: 16'hz;

always @(negedge clk) begin
    if(memrq & !rnw) mem[addr] <= data;
end /*always*/

initial begin
    mem[0] = {`LDA, 12'h64};
    mem[1] = {`SUB, 12'h65};
    mem[2] = {`JNE, 12'h6};
    mem[3] = {`LDA, 12'h64};
    mem[4] = {`ADD, 12'h65};
    mem[5] = {`JMP, 12'h9};
    mem[6] = {`LDA, 12'h64};
    mem[7] = {`SUB, 12'h66};
    mem[8] = {`SUB, 12'h66};
    mem[9] = {`STO, 12'h64};
    mem[10] = {`STP, 12'h0};
    mem['h64] = 16'h4444;
    mem['h65] = 16'h2222;
    mem['h66] = 16'h1111;
end /*initial*/

endmodule