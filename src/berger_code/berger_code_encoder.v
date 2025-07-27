module berger_code_encoder(
    input  [7:0] input_data,
    output [11:0] output_code
);

    wire [11:0] code;
    wire [3:0] ones_count;

    // Assign the data bits
    assign code [11:4] = input_data;

    // Compute sum bits
    assign ones_count = input_data[0] + input_data[1] + input_data[2] + input_data[3] +
                        input_data[4] + input_data[5] + input_data[6] + input_data[7]; 
    
    assign code [3:0] = 4'd8 - ones_count;

    // Assign to output
    assign output_code = code;

endmodule