`timescale 1ns/1ps

module berger_code_tb();

    reg         clk;
    reg         rst;
    reg  [7:0]  input_data;
    reg  [3:0]  input_addr;
    reg         wr_en;
    reg  [11:0] fault_mask;
    reg         fault_enable;
    reg         error_detected;

    wire [7:0]  output_data;
    wire        error_detected;

    // Instantiate DUT
    berger_zero_faulty_memory dut (
        .clk(clk),
        .rst(rst),
        .input_data(input_data),
        .input_addr(input_addr),
        .wr_en(wr_en),
        .unidirectional_fault_mask(fault_mask),
        .fault_enable(fault_enable),
        .fault_zero_to_one(error_detected),
        .output_data(output_data),
        .error_detected(error_detected)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Sample data for memory initialization
    reg [7:0] test_data [0:7];
    integer i, bit_pos, mask_idx;

    // Multi-bit fault masks with multiple bits set
    reg [11:0] multi_fault_masks [0:9];
    initial begin
        multi_fault_masks[0] = 12'b0000_0000_1101; // bits 0, 2, 3
        multi_fault_masks[1] = 12'b0000_0011_0011; // bits 0, 1, 4, 5
        multi_fault_masks[2] = 12'b0000_1111_0000; // bits 4, 5, 6, 7
        multi_fault_masks[3] = 12'b1111_0000_0000; // bits 8, 9, 10, 11
        multi_fault_masks[4] = 12'b1010_1010_1010; // alternating bits 1,3,5,7,9,11
        multi_fault_masks[5] = 12'b0101_0101_0101; // alternating bits 0,2,4,6,8,10
        multi_fault_masks[6] = 12'b1111_1111_0000; // upper 8 bits set
        multi_fault_masks[7] = 12'b0000_1111_1111; // lower 8 bits set
        multi_fault_masks[8] = 12'b1000_1000_1000; // bits 11, 8, 5 set
        multi_fault_masks[9] = 12'b0110_0110_0110; // bits 1,2,5,6,9,10 set
    end

    initial begin
        // Initialize test data
        test_data[0] = 8'hA5;
        test_data[1] = 8'h3D;
        test_data[2] = 8'hFB;
        test_data[3] = 8'h00;
        test_data[4] = 8'h5A;
        test_data[5] = 8'hC3;
        test_data[6] = 8'h1E;
        test_data[7] = 8'hB4;

        // Initialize inputs
        rst = 1; wr_en = 0; input_data = 0; input_addr = 0; 
        fault_mask = 12'b0; fault_enable = 0; error_detected = 1'b1; 
        #12; rst = 0;

        // Write data to memory
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i[3:0];
            input_data = test_data[i];
            wr_en = 1;
            #10;
            wr_en = 0;
            #10;
        end

        // Read back without faults
        $display("Reading back without any faults:");
        for (i = 0; i < 8; i = i + 1) begin
            input_addr = i[3:0];
            fault_enable = 0;
            fault_mask = 12'b0;
            #10;
            $display("Addr %0d: Data = 0x%h, Error Detected = %b", i, output_data, error_detected);
        end

        // Inject single-bit faults one-by-one (0->1 errors)
        $display("\nInjecting single 0->1 bit faults at various bit positions:");
        for (i = 0; i < 2; i = i + 1) begin
            input_addr = i[3:0];
            for (bit_pos = 0; bit_pos < 12; bit_pos = bit_pos + 1) begin
                fault_mask = 12'b0;
                fault_mask[bit_pos] = 1'b1;  // Inject fault at bit_pos
                fault_enable = 1;
                #10;
                $display("Addr %0d, Fault @ bit %0d: Data = 0x%h, Error Detected = %b", i, bit_pos, output_data, error_detected);
                fault_enable = 0;
                #10;
            end
        end

        // Inject multi-bit faults with multiple bits set
        $display("\nInjecting multi-bit faults with multiple bits set:");
        for (i = 0; i < 2; i = i + 1) begin
            input_addr = i[3:0];
            for (mask_idx = 0; mask_idx < 10; mask_idx = mask_idx + 1) begin
                fault_mask = multi_fault_masks[mask_idx];
                fault_enable = 1;
                #10;
                $display("Addr %0d, Fault Mask %b: Data = 0x%h, Error Detected = %b", i, fault_mask, output_data, error_detected);
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
