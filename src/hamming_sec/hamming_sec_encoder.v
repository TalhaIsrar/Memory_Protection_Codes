module hamming_sec_encoder(
    input  [7:0] input_data,
    output [11:0] output_code
);

    wire [11:0] code;

    // Assign the data bits
    assign code[11] = input_data[7];
    assign code[10] = input_data[6];
    assign code[9]  = input_data[5];
    assign code[8]  = input_data[4];
    assign code[6]  = input_data[3];
    assign code[5]  = input_data[2];
    assign code[4]  = input_data[1];
    assign code[2]  = input_data[0];

    // Compute parity bits
    assign code[8] = code[11] ^ code[10] ^ code[9] ^ code[8]; 
    assign code[3] = code[11] ^ code[6]  ^ code[5] ^ code[4];
    assign code[1] = code[10] ^ code[9]  ^ code[6] ^ code[5] ^ code[2];
    assign code[0] = code[10] ^ code[8]  ^ code[6] ^ code[4] ^ code[2];

    // Assign to output
    assign output_code = code;

endmodule