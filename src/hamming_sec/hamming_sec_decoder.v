module hamming_sec_decoder(
    input  [11:0] in_code,
    output reg [7:0] out_data,
    output reg error_corrected
);

    wire [3:0] syndrome;
    reg  [11:0] corrected_code;

    // Compute syndrome
    assign syndrome[3] = in_code[11] ^ in_code[10] ^ in_code[9] ^ in_code[8]; 
    assign syndrome[2] = in_code[11] ^ in_code[6]  ^ in_code[5] ^ in_code[4];
    assign syndrome[1] = in_code[10] ^ in_code[9]  ^ in_code[6] ^ in_code[5] ^ in_code[2];
    assign syndrome[0] = in_code[10] ^ in_code[8]  ^ in_code[6] ^ in_code[4] ^ in_code[2];

    always @(*) begin
        // Default assignment to avoid latch
        corrected_code = in_code;
        error_corrected = 0; 

        if (syndrome != 4'b0000 && syndrome <= 4'd11) begin
            case (syndrome)
                4'd0:  corrected_code[0]  = ~corrected_code[0];
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
                default: ; // Do nothing
            endcase
            error_corrected = 1;
        end

        // Assign to output data
        out_data[0] = corrected_code[2];
        out_data[1] = corrected_code[4];
        out_data[2] = corrected_code[5];
        out_data[3] = corrected_code[6];
        out_data[4] = corrected_code[8];
        out_data[5] = corrected_code[9];
        out_data[6] = corrected_code[10];
        out_data[7] = corrected_code[11];
    end

endmodule
