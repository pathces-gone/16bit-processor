module ir_reg(
    clk,
    irce, 
    data, 
    ir
    );

    input clk, irce;
    input [15:0] data;
    output [15:0] ir;

    reg [15:0] ir;

    always @(negedge clk) begin
        if(irce) ir <= data[15:0];
    end

endmodule