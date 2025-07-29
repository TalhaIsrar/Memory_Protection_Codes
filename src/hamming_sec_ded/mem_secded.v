module mem_secded (
    input         clk,
    input         rst,
    input         wr_en,
    input  [3:0]  addr,
    input  [12:0] data_in,
    output [12:0] data_out
);

    reg [12:0] mem [0:15];

    assign data_out = mem[addr];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[addr] <= data_in;
        end
    end

endmodule
