module sync_rst(
    input reset,
    input clk,
    output sreset
);
    reg sreset, sreset1;

    always @(negedge clk) begin
        {sreset, sreset1} <= {sreset1 , reset};
    end
endmodule