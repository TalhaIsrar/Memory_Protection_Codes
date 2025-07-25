`timescale 1ns/1ps

module hamming_secded_tb();

    reg         clk;
    reg         rst;
    reg  [7:0]  input_data;
    reg  [3:0]  input_addr;
    reg         wr_en;
    reg  [3:0]  fault_addr;
    reg         fault_enable;

    wire [7:0]  output_data;
    wire        single_bit_error_corrected;

    // Instantiate DUT
    ecc_hamming_secded_faulty_memory dut (
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

    // Initialize memory with sample values
    reg [7:0] test_data [0:7];
    integer i, b;

    initial begin
        // Sample data
        test_data[0] = 8'hA5;
        test_data[1] = 8'h3C;
        test_data[2] = 8'hFF;
        test_data[3] = 8'h00;
        test_data[4] = 8'h5A;
        test_data[5] = 8'hC3;
        test_data[6] = 8'h1E;
        test_data[7] = 8'hB4;

        // Init
        rst = 1; wr_en = 0; input_data = 0; input_addr = 0; fault_enable = 0; fault_addr = 0;
        #12; rst = 0;

        // Write phase
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i;
            input_data = test_data[i];
            wr_en = 1;
            #10 wr_en = 0;
            #10;
        end

        // Read back without faults
        $display("Reading back without any faults:");
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i;
            fault_enable = 0;
            #10;
            $display("Addr %0d: Data = 0x%h, Corrected = %b", i, output_data, single_bit_error_corrected);
        end

        // Inject single-bit faults one-by-one
        $display("\nInjecting single-bit faults at various positions:");
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i;
            for (b = 0; b < 12; b = b + 1) begin
                fault_addr = b;
                fault_enable = 1;
                #10;
                $display("Addr %0d, Fault @ bit %0d: Data = 0x%h, Corrected = %b", i, b, output_data, single_bit_error_corrected);
                fault_enable = 0;
                #10;
            end
        end

        // Done
        $display("\nSimulation complete.");
        #20;
        $finish;
    end

endmodule
