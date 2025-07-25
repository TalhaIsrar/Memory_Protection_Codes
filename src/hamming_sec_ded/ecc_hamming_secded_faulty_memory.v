module ecc_hamming_secded_faulty_memory(
    input clk,
    input rst,

    input [7:0] input_data,
    input [3:0] input_addr,
    input wr_en,

    input [3:0] fault_addr1,
    input [3:0] fault_addr2,
    input fault_enable,
    input two_bit_fault_enable,

    output [7:0] output_data,
    output single_bit_error_corrected,
    output double_bit_error_detected
);

    wire [12:0] encoded;
    wire [12:0] codeword_read;
    wire [12:0] corrupted;

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

    // Fault injector for single bit flip
    two_bit_fault_injector injector (
        .in_code(codeword_read),
        .fault_bit_addr1(fault_addr1),
        .fault_bit_addr2(fault_addr2),
        .fault_en(fault_enable),
        .is_two_bit_fault(two_bit_fault_enable),
        .out_error_code(corrupted)
    );

    // Decoder instantiation
    hamming_secded_decoder decoder (
        .in_code(corrupted),
        .out_data(output_data),
        .single_error_corrected(single_bit_error_corrected),
        .double_error_detected(double_bit_error_detected)
    );

endmodule