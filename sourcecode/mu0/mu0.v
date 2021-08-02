module mu0(
    input reset,
    input clk,
    input [15:0] data,
    output [11:0] addr,
    output memrq,
    output rnw
    );

    wire [15:0] alu, ir, pc, b, acc;
    wire [1:0] alufs;

    sync_rst sync_rst(.reset(reset), .clk(clk), .sreset(sreset));

    pc_reg pc_reg(.clk(clk), .pcce(pcce), .alu(alu), .pc(pc));
    ir_reg ir_reg(.clk(clk), .irce(irce), .data(data), .ir(ir));
    
    mux12bit mux12(.a(ir[11:0]), .b(pc[11:0]), .s(asel), .out(addr));
    mux16bit mux16(.a(data), .b({4'b0000,addr}), .s(bsel), .out(b));
 
    alu16 alu16(.reset(sreset), .a(acc), .b(b), .alufs(alufs), .alu(alu));
    
    acc_reg acc_reg(.clk(clk), .accce(accce), .alu(alu), .acc(acc),.acc15(acc15),.accz(accz));
 
    tri16bit tri16(.in(acc), .oe(accoe), .out(data));



    fsm fsm(
        .reset(sreset), 
        .clk(clk), 
        .opcode(ir[15:12]),
        .accz(accz),
        .acc15(acc15),
        .asel(asel),
        .bsel(bsel),
        .accce(accce),
        .pcce(pcce),
        .irce(irce),
        .accoe(accoe),
        .alufs(alufs),
        .memrq(memrq),
        .rnw(rnw)
    );
endmodule