module mem (
    input         clk,
    input         rst,
    input         wr_en,
    input  [3:0]  addr,
    input  [11:0] data_in,
    output [11:0] data_out
);

    reg [12:0] mem [0:15];

    assign data_out = mem[addr];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1)
                mem[i] <= 12'd0;
        end else if (wr_en) begin
            mem[addr] <= data_in;
        end
    end

endmodule
