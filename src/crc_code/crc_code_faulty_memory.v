module crc_code_faulty_memory(
    input clk,
    input rst,

    input write,
    input read,
    input data_in,
    input addr_in,

    output mem_write_busy
);

    wire control_encoder_shift;
    wire control_encoder_load;
    wire control_mem_write;
    
    wire [3:0] encoder_write_addr;
    wire [11:0] encoder_write_data;

    // Controller instantiation
    crc_code_controller controller (
        .clk(clk),
        .rst(rst),
        .write(write),
        .shift_en(control_encoder_shift),
        .load_en(control_encoder_load),
        .write_mem_en(control_mem_write),
        .write_mem_busy(mem_write_busy)
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
        .read_data()
    );



endmodule