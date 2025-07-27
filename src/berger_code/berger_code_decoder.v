module berger_code_decoder(
    input  [11:0] in_code,
    output [7:0] out_data,
    output error_detected
);

    wire [3:0] ones_count;
    wire [3:0] zeros_count;

    // in_code[11:4] = original data (8 bits)
    // in_code[3:0]  = Berger checksum (number of 0s in data)

    assign ones_count = in_code[4] + in_code[5] + in_code[6]  + in_code[7] +
                        in_code[8] + in_code[9] + in_code[10] + in_code[11];

    assign zeros_count = 4'd8 - ones_count;
    
    assign error_detected = zeros_count != in_code[3:0];
    assign out_data = in_code[11:4];

endmodule
