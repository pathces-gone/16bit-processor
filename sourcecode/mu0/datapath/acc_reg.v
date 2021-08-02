module acc_reg(
    clk, 
    accce,
    alu,
    acc,
    acc15,
    accz
    );

    input clk, accce;
    input [15:0] alu;
    output acc15, accz;
    output [15:0] acc;
    reg [15:0] acc;

    assign acc15 = acc[15];
    assign accz = (acc == 16'h0);

    always @(negedge clk) begin
        if(accce) acc <= alu[15:0];
    end
endmodule