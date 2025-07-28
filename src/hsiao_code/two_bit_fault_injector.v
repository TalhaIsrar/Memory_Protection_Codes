module two_bit_fault_injector
(
    input  [12:0] in_code,
    input  [3:0]  fault_bit_addr1,
    input  [3:0]  fault_bit_addr2,
    input         fault_en,
    input         is_two_bit_fault,  // 0 for 1-bit fault, 1 for 2-bit fault
    output reg [12:0] out_error_code
);

    always @(*) begin
        out_error_code = in_code;
        if (fault_en) begin
            case (fault_bit_addr1)
                4'd0:  out_error_code[0]  = ~in_code[0];
                4'd1:  out_error_code[1]  = ~in_code[1];
                4'd2:  out_error_code[2]  = ~in_code[2];
                4'd3:  out_error_code[3]  = ~in_code[3];
                4'd4:  out_error_code[4]  = ~in_code[4];
                4'd5:  out_error_code[5]  = ~in_code[5];
                4'd6:  out_error_code[6]  = ~in_code[6];
                4'd7:  out_error_code[7]  = ~in_code[7];
                4'd8:  out_error_code[8]  = ~in_code[8];
                4'd9:  out_error_code[9]  = ~in_code[9];
                4'd10: out_error_code[10] = ~in_code[10];
                4'd11: out_error_code[11] = ~in_code[11];
                4'd12: out_error_code[12] = ~in_code[12];
                default: ; // no change
            endcase
        end

        if (fault_en && is_two_bit_fault) begin
            case (fault_bit_addr2)
                4'd0:  out_error_code[0]  = ~in_code[0];
                4'd1:  out_error_code[1]  = ~in_code[1];
                4'd2:  out_error_code[2]  = ~in_code[2];
                4'd3:  out_error_code[3]  = ~in_code[3];
                4'd4:  out_error_code[4]  = ~in_code[4];
                4'd5:  out_error_code[5]  = ~in_code[5];
                4'd6:  out_error_code[6]  = ~in_code[6];
                4'd7:  out_error_code[7]  = ~in_code[7];
                4'd8:  out_error_code[8]  = ~in_code[8];
                4'd9:  out_error_code[9]  = ~in_code[9];
                4'd10: out_error_code[10] = ~in_code[10];
                4'd11: out_error_code[11] = ~in_code[11];
                4'd12: out_error_code[12] = ~in_code[12];
                default: ; // no change
            endcase
        end
    end

endmodule