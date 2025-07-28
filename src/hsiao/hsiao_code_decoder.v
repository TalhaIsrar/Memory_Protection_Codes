module hsiao_code_decoder(
    input  [12:0] in_code,
    output reg [7:0] out_data,
    output reg single_error_corrected,
    output reg double_error_detected
);

    wire [3:0] syndrome;
    wire parity_check;
    reg  [12:0] corrected_code;

    // Compute syndrome
    assign syndrome[3] = in_code[12] ^ in_code[11] ^ in_code[10] ^ in_code[9] ^ in_code[8]; 
    assign syndrome[2] = in_code[12] ^ in_code[7]  ^ in_code[6]  ^ in_code[5] ^ in_code[4];
    assign syndrome[1] = in_code[11] ^ in_code[10] ^ in_code[7]  ^ in_code[6] ^ in_code[3] ^ in_code[2];
    assign syndrome[0] = in_code[11] ^ in_code[9]  ^ in_code[7]  ^ in_code[5] ^ in_code[3] ^ in_code[1];

    // Check overall parity (should be even parity of bits [12:1])
    assign parity_check = ^in_code[12:1] ^ in_code[0]; // 1 if error in parity, 0 if OK

    always @(*) begin
        corrected_code = in_code;
        single_error_corrected = 0;
        double_error_detected  = 0;

        if (syndrome == 4'b0000 && parity_check == 0) begin
            // No error
            corrected_code = in_code;
        end else if (syndrome != 4'b0000 && parity_check == 1) begin
            // Single-bit error -> correct
            single_error_corrected = 1;
            case (syndrome)
                4'd1:  corrected_code[1]  = ~corrected_code[1];
                4'd2:  corrected_code[2]  = ~corrected_code[2];
                4'd3:  corrected_code[3]  = ~corrected_code[3];
                4'd4:  corrected_code[4]  = ~corrected_code[4];
                4'd5:  corrected_code[5]  = ~corrected_code[5];
                4'd6:  corrected_code[6]  = ~corrected_code[6];
                4'd7:  corrected_code[7]  = ~corrected_code[7];
                4'd8:  corrected_code[8]  = ~corrected_code[8];
                4'd9:  corrected_code[9]  = ~corrected_code[9];
                4'd10: corrected_code[10] = ~corrected_code[10];
                4'd11: corrected_code[11] = ~corrected_code[11];
                4'd12: corrected_code[12] = ~corrected_code[12];
                default: ;
            endcase
        end else if (syndrome != 4'b0000 && parity_check == 0) begin
            // Double-bit error -> detected but not correctable
            double_error_detected = 1;
        end else if (syndrome == 4'b0000 && parity_check == 1) begin
            // Error in the overall parity bit only
            single_error_corrected = 1;
            corrected_code[0] = ~corrected_code[0]; // Flip overall parity bit
        end

        // Assign to output data
        out_data[0] = corrected_code[3];
        out_data[1] = corrected_code[5];
        out_data[2] = corrected_code[6];
        out_data[3] = corrected_code[7];
        out_data[4] = corrected_code[9];
        out_data[5] = corrected_code[10];
        out_data[6] = corrected_code[11];
        out_data[7] = corrected_code[12];
    end

endmodule
