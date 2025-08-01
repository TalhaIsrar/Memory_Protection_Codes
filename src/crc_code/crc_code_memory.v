module crc_code_memory(
    input clk,
    input rst,

    input write,
    input read,
    input [7:0] data_in,
    input [3:0] addr_in,

    output mem_write_busy,
    output read_busy,
    output data_valid,
    output error_detected,
    output completed,
    output [7:0] data_out
);

    wire control_encoder_shift;
    wire control_encoder_load;
    wire control_mem_write;

    wire control_decoder_shift;
    wire control_decoder_load;
    wire control_decoder_complete;
    
    wire [3:0] encoder_write_addr;
    wire [11:0] encoder_write_data;

    wire [11:0] mem_encoded_data;

    // Controller instantiation
    crc_code_controller_top controller (
        .clk(clk),
        .rst(rst),
        .write(write),
        .write_shift_en(control_encoder_shift),
        .write_load_en(control_encoder_load),
        .write_mem_en(control_mem_write),
        .write_mem_busy(mem_write_busy),
        .read(read),
        .read_shift_en(control_decoder_shift),
        .read_load_en(control_decoder_load),
        .read_data_valid(control_decoder_complete),
        .read_controller_busy(read_busy)
    );

    // Encoder instantiation
    crc_code_encoder encoder (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr_in(addr_in),
        .load(control_encoder_load),
        .shift_en(control_encoder_shift),        
        .data_out(encoder_write_data),
        .addr_out(encoder_write_addr)     
    );

    // Memory module
    mem_crc_code memory(
        .clk(clk),
        .rst(rst),
        .wr_en(control_mem_write),
        .write_addr(encoder_write_addr),
        .read_addr(addr_in),
        .write_data(encoder_write_data),
        .read_data(mem_encoded_data)
    );
    
    // Decoder instantiation
    crc_code_decoder decoder (
        .clk(clk),
        .rst(rst),
        .encoded_data(mem_encoded_data),
        .load(control_decoder_load),
        .shift_en(control_decoder_shift),
        .processing_complete(control_decoder_complete),      
        .decoded_data(data_out),
        .data_valid(data_valid),
        .error_detected(error_detected),
        .completed(completed)     
    );

endmodule