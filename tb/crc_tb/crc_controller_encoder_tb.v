`timescale 1ns/1ps

module crc_controller_encoder_tb();

    reg clk;
    reg rst;

    reg write;
    reg [7:0] data_in;
    reg [3:0] addr_in;

    wire shift_en;
    wire load_en;
    wire write_mem_en;
    wire write_mem_busy;

    wire [11:0] data_out;
    wire [3:0] addr_out;

    // Instantiate DUT
    crc_code_controller dut_controller (
        .clk(clk),
        .rst(rst),
        .write(write),
        .shift_en(shift_en),
        .load_en(load_en),
        .write_mem_en(write_mem_en),
        .write_mem_busy(write_mem_busy)
    );

    crc_code_encoder dut_encoder (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr_in(addr_in),
        .load(load_en),
        .shift_en(shift_en),
        .data_out(data_out),
        .addr_out(addr_out)
    ); 

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #20

        rst = 0;
        write = 0;
        data_in = 8'hff;
        addr_in = 4'h0;
        $display("\nReset complete.");
        #20

        write = 1;
        data_in = 8'b10100101;
        addr_in = 4'h2;
        #10

        write = 0;
        data_in = 8'b11100111;
        addr_in = 4'h3;
        #40

        write = 1;
        data_in = 8'b00010011;
        addr_in = 4'h4;
        #20

        write = 0;
        data_in = 8'b11100111;
        addr_in = 4'h5;
        #300

        write = 1;
        data_in = 8'b10001011;
        addr_in = 4'h6;
        #10

        write = 0;
        #200

        // Done
        $display("\nSimulation complete.");
        #20;
        $finish;

    end

endmodule
