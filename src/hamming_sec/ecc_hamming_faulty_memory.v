module ecc_hamming_faulty_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    input [3:0] fault_addr,
    input fault_enable,

    output [7:0] output_data,
    output single_bit_error_corrected
);

    // Memory stores 12-bit codewords (8 data bits + 4 ECC)
    reg [11:0] mem [0:15];

    wire [11:0] encoded;
    wire [11:0] codeword_read;
    wire [11:0] corrupted;

    // Encoder instantiation
    hamming_sec_encoder encoder (
        .input_data(input_data),
        .output_code(encoded)
    );

    // Memory module
    mem memory(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr(input_addr),
        .data_in(encoded),
        .data_out(codeword_read)
    );

    // Fault injector for single bit flip
    one_bit_flip_simulator injector (
        .in_code(codeword_read),
        .fault_bit_addr(fault_addr),
        .fault_en(fault_enable),
        .out_error_code(corrupted)
    );

    // Decoder instantiation
    hamming_sec_decoder decoder (
        .in_code(corrupted),
        .out_data(output_data),
        .error_corrected(single_bit_error_corrected)
    );

endmodule