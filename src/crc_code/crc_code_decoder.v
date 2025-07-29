module crc_code_decoder(
    input  clk,
    input  rst,
    input  [11:0] encoded_data,

    input load,
    input shift_en,
    input processing_complete,

    output [7:0] decoded_data,
    output data_valid,
    output error_detected;
);

    reg [11:0] data_shift_reg;
    reg [7:0] data_reg;

    reg [3:0] lfsr;
    
    wire lsfr_input;
    wire error;

    // Internal Registers to store data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 8'h00;
        end else begin
            if (load) begin
                data_reg <= encoded_data[11:4];
            end
        end 
    end

    // Shift register for LFSR
    always @(posedge clk or posedge rst) begin
        if (rst)
            data_shift_reg  <= 12'h000;
        else begin
            if (load)
                data_shift_reg  <= encoded_data;
            else if (shift_en)
                data_shift_reg  <= {encoded_data[10:0] , 1'b0};
        end 
    end

    // MSB of input to pass to LFSR
    assign lsfr_input = data_shift_reg[11];
    
    // LFSR to calculate the remainder
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 4'b0000;
        else if (load) 
            lfsr <= 4'b0000;
        else if (shift_en)
            // Implements CRC-4 with polynomial x^4 + x + 1
            lfsr <= {lfsr[2:1] , lfsr[3] ^ lfsr[0], lfsr[3] ^ lsfr_input};
    end

    assign error = |lfsr;

    // Assign the outputs
    assign data_out = data_reg;
    assign error_detected = error;

    // Data is valid if processing complete & no error
    assign data_valid = !error & !processing_complete;

endmodule