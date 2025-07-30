module crc_code_controller_top(
    input clk,
    input rst,
    input read,
    input write,

    output write_shift_en,
    output write_load_en,

    output read_shift_en,
    output read_load_en,

    output write_mem_en,
    output write_mem_busy,

    output read_data_valid,
    output read_controller_busy
);
    // Controller module for encoder - Write
    crc_code_controller encoder_controller (
        .clk(clk),
        .rst(rst),
        .start(write),
        .shift_en(write_shift_en),
        .load_en(write_load_en),
        .data_valid(write_mem_en),
        .controller_busy(write_mem_busy)
    );

    // Controller module for decoder - Read
    crc_code_controller decoder_controller(
        .clk(clk),
        .rst(rst),
        .start(read),
        .shift_en(read_shift_en),
        .load_en(read_load_en),
        .data_valid(read_data_valid),
        .controller_busy(read_controller_busy)
    );


endmodule