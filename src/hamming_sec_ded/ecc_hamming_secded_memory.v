module ecc_hamming_secded_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    output [7:0] output_data,
    output single_bit_error_corrected
);

    // Memory stores 12-bit codewords (8 data bits + 4 ECC)
    reg [11:0] mem [0:15];

    wire [11:0] encoded;
    wire [11:0] codeword_read;

    // Encoder instantiation
    hamming_secded_encoder encoder (
        .input_data(input_data),
        .output_code(encoded)
    );

    // Memory module
    mem_secded memory(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr(input_addr),
        .data_in(encoded),
        .data_out(codeword_read)
    );

    // Decoder instantiation
    hamming_secded_decoder decoder (
        .in_code(codeword_read),
        .out_data(output_data),
        .error_corrected(single_bit_error_corrected)
    );

endmodule