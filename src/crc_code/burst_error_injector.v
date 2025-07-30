module burst_error_injector (
    input  [11:0] in_code,
    input  [3:0]  fault_start_addr,        // 0 to 11
    input  [1:0]  burst_error_length,      // 0 = 1-bit, 3 = 4-bit
    input         fault_en,
    output reg [11:0] out_error_code
);

    always @(*) begin
        out_error_code = in_code;

        if (fault_en) begin
            case (burst_error_length)
                2'd0: begin
                    if (fault_start_addr < 12)
                        out_error_code[fault_start_addr] = ~in_code[fault_start_addr];
                end

                2'd1: begin
                    if (fault_start_addr < 12)
                        out_error_code[fault_start_addr] = ~in_code[fault_start_addr];
                    if ((fault_start_addr + 1) < 12)
                        out_error_code[fault_start_addr + 1] = ~in_code[fault_start_addr + 1];
                end

                2'd2: begin
                    if (fault_start_addr < 12)
                        out_error_code[fault_start_addr] = ~in_code[fault_start_addr];
                    if ((fault_start_addr + 1) < 12)
                        out_error_code[fault_start_addr + 1] = ~in_code[fault_start_addr + 1];
                    if ((fault_start_addr + 2) < 12)
                        out_error_code[fault_start_addr + 2] = ~in_code[fault_start_addr + 2];
                end

                2'd3: begin
                    if (fault_start_addr < 12)
                        out_error_code[fault_start_addr] = ~in_code[fault_start_addr];
                    if ((fault_start_addr + 1) < 12)
                        out_error_code[fault_start_addr + 1] = ~in_code[fault_start_addr + 1];
                    if ((fault_start_addr + 2) < 12)
                        out_error_code[fault_start_addr + 2] = ~in_code[fault_start_addr + 2];
                    if ((fault_start_addr + 3) < 12)
                        out_error_code[fault_start_addr + 3] = ~in_code[fault_start_addr + 3];
                end

                default: ; // Do nothing
            endcase
        end
    end

endmodule
