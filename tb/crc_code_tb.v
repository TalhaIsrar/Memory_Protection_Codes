`timescale 1ns/1ps

module crc_code_tb();
    reg         clk;
    reg         rst;

    reg         write;
    reg         read;
    reg [7:0]   data_in;
    reg [3:0]   addr_in;

    reg [3:0]   fault_addr;
    reg [1:0]   burst_error_length;
    reg         fault_enable;

    wire        mem_write_busy;
    wire        read_busy;
    wire        data_valid;
    wire        error_detected;
    wire        completed;
    wire [7:0]  data_out;

    // Instantiate DUT
    crc_code_faulty_memory dut (
        .clk(clk),
        .rst(rst),
        .write(write),
        .read(read),
        .data_in(data_in),
        .addr_in(addr_in),
        .fault_addr(fault_addr),
        .burst_error_length(burst_error_length),
        .fault_enable(fault_enable),
        .mem_write_busy(mem_write_busy),
        .read_busy(read_busy),
        .data_valid(data_valid),
        .error_detected(error_detected),
        .completed(completed),
        .data_out(data_out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    task write_data(input [3:0] addr, input [7:0] value);
    begin
        @(negedge clk);
        addr_in = addr;
        data_in = value;
        write = 1;
        @(negedge clk);
        write = 0;
        repeat (12) @(negedge clk); // wait remaining cycles
    end
    endtask

    task read_data(input [3:0] addr, input [3:0] fault_bit, input [1:0] burst_len, input enable_fault);
    begin
        @(negedge clk);
        addr_in = addr;
        fault_addr = fault_bit;
        burst_error_length = burst_len;
        fault_enable = enable_fault;
        read = 1;
        @(negedge clk);
        read = 0;
        repeat (12) @(negedge clk); // wait remaining cycles

        if (data_valid) begin
            $display("Read Addr: %0d | Data: %0h | Error Detected: %b", addr, data_out, error_detected);
        end
    end
    endtask

    initial begin
        // Init
        rst = 1;
        write = 0;
        read = 0;
        fault_enable = 0;
        addr_in = 0;
        data_in = 0;
        fault_addr = 0;
        burst_error_length = 0;

        @(negedge clk);
        rst = 0;

        $display("Writing data...");
        write_data(0, 8'hA5);
        write_data(1, 8'h3C);
        write_data(2, 8'h7E);

        $display("Reading data without faults...");
        read_data(0, 0, 0, 0);
        read_data(1, 0, 0, 0);
        read_data(2, 0, 0, 0);

        $display("Reading data with 1-bit error...");
        read_data(0, 0, 2'd0, 1);
        read_data(1, 3, 2'd0, 1);
        read_data(2, 7, 2'd0, 1);

        $display("Reading data with 2-bit burst error...");
        read_data(0, 0, 2'd1, 1);
        read_data(1, 2, 2'd1, 1);
        read_data(2, 6, 2'd1, 1);

        $display("Reading data with 3-bit burst error...");
        read_data(0, 0, 2'd2, 1);
        read_data(1, 1, 2'd2, 1);
        read_data(2, 5, 2'd2, 1);

        $display("Reading data with 4-bit burst error...");
        read_data(0, 0, 2'd3, 1);
        read_data(1, 1, 2'd3, 1);
        read_data(2, 4, 2'd3, 1);

        $display("\nSimulation complete.");
        #20;
        $finish;
    end

endmodule
