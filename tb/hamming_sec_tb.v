`timescale 1ns/1ps

module hamming_sec_tb();

    reg         clk;
    reg         rst;
    reg  [7:0]  input_data;
    reg  [3:0]  input_addr;
    reg         wr_en;
    reg  [3:0]  fault_addr;
    reg         fault_enable;

    wire [7:0]  output_data;
    wire        single_bit_error_corrected;

    // Instantiate the DUT
    ecc_hamming_faulty_memory dut (
        .clk(clk),
        .rst(rst),
        .input_data(input_data),
        .input_addr(input_addr),
        .wr_en(wr_en),
        .fault_addr(fault_addr),
        .fault_enable(fault_enable),
        .output_data(output_data),
        .single_bit_error_corrected(single_bit_error_corrected)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        rst = 1;
        input_data = 0;
        input_addr = 0;
        wr_en = 0;
        fault_addr = 0;
        fault_enable = 0;

        // Hold reset for 2 clock cycles
        #12;
        rst = 0;

        // Write some data to address 0
        #10
        input_data = 8'hA5;
        input_addr = 4'd0;
        wr_en = 1;
        #10
        wr_en = 0;

        // Read back without fault injection
        #10
        fault_enable = 0;
        input_addr = 4'd0;

        #10
        $display("Read data: 0x%h, Error corrected: %b", output_data, single_bit_error_corrected);

        // Inject single-bit fault at bit 2 of the codeword
        fault_addr = 4'd2;
        fault_enable = 1;

        #10
        $display("After fault injection: Read data: 0x%h, Error corrected: %b", output_data, single_bit_error_corrected);

        // Remove fault injection
        fault_enable = 0;

        #10
        $display("Fault removed: Read data: 0x%h, Error corrected: %b", output_data, single_bit_error_corrected);

        // Write different data to address 1
        #10
        input_data = 8'h3C;
        input_addr = 4'd1;
        wr_en = 1;
        #10
        wr_en = 0;

        // Read back without fault injection
        #10
        input_addr = 4'd1;
        #10
        $display("Read data addr1: 0x%h, Error corrected: %b", output_data, single_bit_error_corrected);

        // Finish simulation
        #20;
        $finish;
    end

endmodule
