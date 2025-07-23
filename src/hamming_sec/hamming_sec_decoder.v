module hamming_sec_decoder(
    input  [11:0] in_code,
    output [7:0] out_data,
    output error_corrected
);

    wire [11:0] code;
    wire [3:0]  syndrome;

    assign code = in_code;

    // Compute syndrome bits
    assign syndrome[3] = code[11] ^ code[10] ^ code[9] ^ code[8]; 
    assign syndrome[2] = code[11] ^ code[6]  ^ code[5] ^ code[4];
    assign syndrome[1] = code[10] ^ code[9]  ^ code[6] ^ code[5] ^ code[2];
    assign syndrome[0] = code[10] ^ code[8]  ^ code[6] ^ code[4] ^ code[2];

    // Check if there is syndrome
    if (syndrome != 4'b0000) begin
        // Fix bit flip
        code[syndrome] = ~code[syndrome];
        error_corrected = 1;

    end else begin
        error_corrected = 0;
    end

    // Extract data
    out_data[0] = code[2];
    out_data[1] = code[4];
    out_data[2] = code[5];
    out_data[3] = code[6];
    out_data[4] = code[8];
    out_data[5] = code[9];
    out_data[6] = code[10];
    out_data[7] = code[11];

endmodule