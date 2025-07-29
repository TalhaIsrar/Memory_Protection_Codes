module mem_crc_code (
    input         clk,
    input         rst,
    input         wr_en,
    input  [3:0]  addr,
    input  [11:0] data_in,
    output [11:0] data_out
);

    reg [11:0] mem [0:15];

    assign data_out = mem[addr];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[addr] <= data_in;
        end
    end

endmodule
