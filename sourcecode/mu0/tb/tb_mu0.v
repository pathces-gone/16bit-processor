module tb_mu0;
    reg reset, clk;
    wire [11:0] addr;
    wire [15:0] data;

    initial clk =0;
    always #5 clk = !clk;

    initial begin
        reset = 1;
        #35
        reset = 0;
    end

    mu0 dut(.reset(reset), .clk(clk), .addr(addr), .data(data), .memrq(memrq), .rnw(rnw));
    mem_model mem(.clk(clk), .addr(addr), .data(data), .memrq(memrq), .rnw(rnw));

endmodule