`timescale 1ns/1ps

module crc_controller_tb();

    reg clk;
    reg rst;

    reg write;

    wire shift_en;
    wire load_en;
    wire write_mem_en;
    wire write_mem_busy;

    // Instantiate DUT
    crc_code_controller dut (
        .clk(clk),
        .rst(rst),
        .write(write),
        .shift_en(shift_en),
        .load_en(load_en),
        .write_mem_en(write_mem_en),
        .write_mem_busy(write_mem_busy)
    );


    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #20

        rst = 0;
        write = 0;
        $display("\nReset complete.");
        #20

        write = 1;
        #10

        write = 0;
        #40

        write = 1;
        #20

        write = 0;
        #300

        write = 1;
        #10

        write = 0;
        #200

        // Done
        $display("\nSimulation complete.");
        #20;
        $finish;

    end

endmodule
