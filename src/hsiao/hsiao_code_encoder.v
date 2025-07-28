module hsiao_code_encoder(
    input  [7:0] input_data,
    output [12:0] output_code
);

    wire [12:0] code;

    // Assign the data bits
    assign code[12] = data_in[7];
    assign code[11] = data_in[6];
    assign code[10] = data_in[5];
    assign code[9]  = data_in[4];
    assign code[8]  = data_in[3];
    assign code[7]  = data_in[2];
    assign code[6]  = data_in[1];
    assign code[5]  = data_in[0];

    // Compute parity bits
    assign code[4] = code[12] ^ code[11] ^ code[10] ^ code[9];
    assign code[3] = code[12] ^ code[8]  ^ code[7]  ^ code[6];
    assign code[2] = code[11] ^ code[10] ^ code[7]  ^ code[6] ^ code[5];
    assign code[1] = code[10] ^ code[9]  ^ code[8]  ^ code[6] ^ code[5];
    assign code[0] = code[12] ^ code[10] ^ code[9]  ^ code[8] ^ code[7] ^ code[5];

    // Assign to output
    assign output_code = code;

endmodule