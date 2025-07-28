`timescale 1ns/1ps

module hsiao_code_tb();

    reg         clk;
    reg         rst;
    reg  [7:0]  input_data;
    reg  [3:0]  input_addr;
    reg         wr_en;
    reg  [3:0]  fault_addr1;
    reg  [3:0]  fault_addr2;
    reg         fault_enable;
    reg         two_bit_fault_enable;

    wire [7:0]  output_data;
    wire        single_bit_error_corrected;
    wire        double_bit_error_detected;

    // Instantiate DUT
    hsiao_code_faulty_memory dut (
        .clk(clk),
        .rst(rst),
        .input_data(input_data),
        .input_addr(input_addr),
        .wr_en(wr_en),
        .fault_addr1(fault_addr1),
        .fault_addr2(fault_addr2),
        .fault_enable(fault_enable),
        .two_bit_fault_enable(two_bit_fault_enable),
        .output_data(output_data),
        .single_bit_error_corrected(single_bit_error_corrected),
        .double_bit_error_detected(double_bit_error_detected)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Initialize memory with sample values
    reg [7:0] test_data [0:7];
    integer i, b1, b2;

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

        // Reset and init
        rst = 1; wr_en = 0; input_data = 0; input_addr = 0;
        fault_enable = 0; fault_addr1 = 0; fault_addr2 = 0; two_bit_fault_enable = 0;
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
        $display("\nReading back without any faults:");
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i;
            fault_enable = 0;
            two_bit_fault_enable = 0;
            #10;
            $display("Addr %0d: Data = 0x%h | Corrected: %b | Double error: %b",
                i, output_data, single_bit_error_corrected, double_bit_error_detected);
        end

        // Inject single-bit faults
        $display("\nInjecting single-bit faults at all positions:");
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i;
            for (b1 = 0; b1 < 13; b1 = b1 + 1) begin
                fault_addr1 = b1;
                fault_enable = 1;
                two_bit_fault_enable = 0; // 1-bit fault
                #10;
                $display("Addr %0d, Fault@%0d: Data=0x%h | Corrected=%b | DoubleErr=%b",
                    i, b1, output_data, single_bit_error_corrected, double_bit_error_detected);
                fault_enable = 0;
                #5;
            end
        end

        // Inject double-bit faults
        $display("\nInjecting double-bit faults:");
        for (i = 0; i < 2; i = i + 1) begin // limit for brevity
            input_addr = i;
            for (b1 = 0; b1 < 13; b1 = b1 + 1) begin
                for (b2 = b1 + 1; b2 < 13; b2 = b2 + 1) begin
                    fault_addr1 = b1;
                    fault_addr2 = b2;
                    fault_enable = 1;
                    two_bit_fault_enable = 1;
                    #10;
                    $display("Addr %0d, Fault@%0d,%0d: Data=0x%h | Corrected=%b | DoubleErr=%b",
                        i, b1, b2, output_data, single_bit_error_corrected, double_bit_error_detected);
                    fault_enable = 0;
                    #5;
                end
            end
        end

        $display("\nSimulation complete.");
        #20;
        $finish;
    end

endmodule
