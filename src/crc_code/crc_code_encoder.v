module crc_code_encoder(
    input  clk,
    input  rst,
    input  [7:0] data_in,
    input  [3:0] addr_in,

    input load,
    input shift_en,

    output [11:0] data_out,
    output [3:0] addr_out
);

endmodule