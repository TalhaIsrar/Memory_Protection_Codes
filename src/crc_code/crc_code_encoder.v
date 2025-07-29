module crc_code_encoder(
    input  clk,
    input  rst,
    input  [7:0] data_in,
    input  [3:0] addr_in,

    input load,
    input shift_en,

    output [11:0] data_out,
    output [3:0] addr_out
);

    reg [7:0] data_reg, data_shift_reg;
    reg [3:0] addr_reg;

    reg [3:0] lfsr;
    
    wire lsfr_input;

    // Internal Registers to store data & address
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg        <= 8'b00000000;
            addr_reg        <= 4'b0000;
        end else begin
            if (load) begin
                data_reg        <= data_in;
                addr_reg        <= addr_in;
            end
        end 
    end

    // Shift register for LFSR
    always @(posedge clk or posedge rst) begin
        if (rst)
            data_shift_reg  <= 8'b00000000;
        else begin
            if (load)
                data_shift_reg  <= data_in;
            else if (shift_en)
                data_shift_reg  <= {data_shift_reg[6:0] , 1'b0};
        end 
    end

    // MSB of input to pass to LFSR
    assign lsfr_input = data_shift_reg[7];
    
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

    // Assign the outputs
    assign addr_out = addr_reg;
    assign data_out[11:4] = data_reg;
    assign data_out[3:0] = lfsr;

endmodule