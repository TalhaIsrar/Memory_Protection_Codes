module mem_crc_code (
    input         clk,
    input         rst,
    input         wr_en,
    input  [3:0]  write_addr,
    input  [3:0]  read_addr,
    input  [11:0] write_data,
    output reg [11:0] read_data
);

    reg [11:0] mem [0:15];

    // Write to memory
    always @(posedge clk) begin
        if (wr_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // If read and write address are same pass input data to output
    always @(*) begin
        if (write_addr == read_addr)
            read_data = write_data;
        else
            read_data = mem[read_addr];
    end

endmodule
