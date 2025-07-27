module berger_code_faulty_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    input [11:0] unidirectional_fault_mask,
    input fault_enable,
    input fault_zero_to_one,

    output [7:0] output_data,
    output zero_to_one_error
);

    wire [11:0] encoded;
    wire [11:0] codeword_read;
    wire [11:0] corrupted;

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

    // Fault injector for unidirectional errors
    unidirectional_error injector (
        .in_code(codeword_read),
        .error_mask(unidirectional_fault_mask),
        .fault_en(fault_enable),
        .zero_to_one_error(fault_zero_to_one),
        .out_error_code(corrupted)
    );

    // Decoder instantiation
    berger_code_decoder decoder (
        .in_code(corrupted),
        .out_data(output_data),
        .error_detected(zero_to_one_error)
    );

endmodule