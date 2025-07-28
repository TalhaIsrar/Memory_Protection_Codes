module hsiao_code_encoder(
    input  [7:0] input_data,
    output [12:0] output_code
);

    wire [12:0] code;

    // Assign the data bits
    assign code[12] = input_data[7];
    assign code[11] = input_data[6];
    assign code[10]  = input_data[5];
    assign code[9]  = input_data[4];
    assign code[7]  = input_data[3];
    assign code[6]  = input_data[2];
    assign code[5]  = input_data[1];
    assign code[3]  = input_data[0];

    // Compute parity bits
    assign code[8] = code[12] ^ code[11] ^ code[10] ^ code[9];            
    assign code[4] = code[12] ^ code[7]  ^ code[6]  ^ code[5];             
    assign code[2] = code[11] ^ code[10] ^ code[7]  ^ code[6] ^ code[3]; 
    assign code[1] = code[11] ^ code[9]  ^ code[7]  ^ code[5] ^ code[3]; 

    // Calculate overall parity bit (even parity over all 12 bits)
    assign code[0] = ^code[12:1];

    // Assign to output
    assign output_code = code;

endmodule