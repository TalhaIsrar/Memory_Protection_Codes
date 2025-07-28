module hsiao_code_decoder(
    input  [12:0] in_code,
    output reg [7:0] out_data,
    output reg single_error_corrected,
    output reg double_error_detected
);

    wire [3:0] syndrome;
    reg  [12:0] corrected_code;
    wire syndrome_parity_odd;

    // Compute syndrome
    assign syndrome[4] = in_code[12] ^ in_code[11] ^ in_code[10] ^ in_code[9] ^ in_code[4];
    assign syndrome[3] = in_code[12] ^ in_code[8]  ^ in_code[7]  ^ in_code[6] ^ in_code[3];
    assign syndrome[2] = in_code[11] ^ in_code[10] ^ in_code[7]  ^ in_code[6] ^ in_code[5] ^ in_code[2];
    assign syndrome[1] = in_code[10] ^ in_code[9]  ^ in_code[8]  ^ in_code[6] ^ in_code[5] ^ in_code[1];
    assign syndrome[0] = in_code[12] ^ in_code[10] ^ in_code[9]  ^ in_code[8] ^ in_code[7] ^ in_code[5] ^ in_code[0];

    // XOR of all 5 syndrome bits
    assign syndrome_parity_odd = ^syndrome;  

    always @(*) begin
        corrected_code = in_code;
        single_error_corrected = 0;
        double_error_detected  = 0;

        if (syndrome == 5'b00000) begin
            // No error
            corrected_code = in_code;
        end else if (syndrome != 5'b00000 && syndrome_parity_odd) begin
            // Single-bit error -> correctable
            single_error_corrected = 1;
            case (syndrome)
                5'd0: corrected_code[0]  = ~corrected_code[0];
                5'd1: corrected_code[1]  = ~corrected_code[1];
                5'd2: corrected_code[2]  = ~corrected_code[2];
                5'd3: corrected_code[3]  = ~corrected_code[3];
                5'd4: corrected_code[4]  = ~corrected_code[4];
                5'd5: corrected_code[5]  = ~corrected_code[5];
                5'd6: corrected_code[6]  = ~corrected_code[6];
                5'd7: corrected_code[7]  = ~corrected_code[7];
                5'd8: corrected_code[8]  = ~corrected_code[8];
                5'd9: corrected_code[9]  = ~corrected_code[9];
                5'd10: corrected_code[10] = ~corrected_code[10];
                5'd11: corrected_code[11] = ~corrected_code[11];
                5'd12: corrected_code[12] = ~corrected_code[12];
                default: ;
            endcase
        end else if (!syndrome_parity_odd) begin
            // Double-bit error -> detected but not correctable
            double_error_detected = 1;
        end

        // Assign to output data
        out_data[0] = corrected_code[5];
        out_data[1] = corrected_code[6];
        out_data[2] = corrected_code[7];
        out_data[3] = corrected_code[8];
        out_data[4] = corrected_code[9];
        out_data[5] = corrected_code[10];
        out_data[6] = corrected_code[11];
        out_data[7] = corrected_code[12];
    end

endmodule
