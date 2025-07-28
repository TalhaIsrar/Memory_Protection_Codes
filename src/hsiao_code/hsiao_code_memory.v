module hsiao_code_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    output [7:0] output_data,
    output single_bit_error_corrected,
    output double_bit_error_detected
);

    wire [12:0] encoded;
    wire [12:0] codeword_read;

    // Encoder instantiation
    hsiao_code_encoder encoder (
        .input_data(input_data),
        .output_code(encoded)
    );

    // Memory module
    mem_hsiao_code memory(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr(input_addr),
        .data_in(encoded),
        .data_out(codeword_read)
    );

    // Decoder instantiation
    hsiao_code_decoder decoder (
        .in_code(codeword_read),
        .out_data(output_data),
        .single_error_corrected(single_bit_error_corrected),
        .double_error_detected(double_bit_error_detected)
    );

endmodule