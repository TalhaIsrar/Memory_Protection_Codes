module unidirectional_error
(
    input  [11:0] in_code,
    input  [11:0] error_mask,
    input  fault_en,
    input  zero_to_one_error,

    output reg[11:0] out_error_code
);

    always @(*) begin
        out_error_code = in_code;
        if (fault_en) begin
            /** 
            zero_to_one_error = 1 means unidirectional 0->1 errors are inserted based on where error_mask is 1
            zero_to_one_error = 0 means unidirectional 1->0 errors are inserted based on where error_mask is 1            
            **/
            if (zero_to_one_error) begin    
                out_error_code = in_code | error_mask;
            end else begin
                out_error_code = in_code & ~(error_mask);
            end
        end
    end

endmodule