module berger_code_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    output [7:0] output_data,
    output zero_to_one_error
);

    wire [11:0] encoded;
    wire [11:0] codeword_read;

    // Encoder instantiation
    berger_code_encoder encoder (
        .input_data(input_data),
        .output_code(encoded)
    );

    // Memory module
    mem_berger_code memory(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .addr(input_addr),
        .data_in(encoded),
        .data_out(codeword_read)
    );

    // Decoder instantiation
    berger_code_decoder decoder (
        .in_code(codeword_read),
        .out_data(output_data),
        .error_detected(zero_to_one_error)
    );

endmodule