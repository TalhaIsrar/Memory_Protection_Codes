module crc_code_controller(
    input clk,
    input rst,
    input write,

    output reg shift_en,
    output reg load_en,

    output reg write_mem_en,
    output reg write_mem_busy
);

    // State encoding using parameters
    parameter IDLE = 2'b00,
              SHIFT= 2'b01,
              DONE = 2'b10;

    reg [1:0] state, next_state;

    // 4-bit counter for 12 cycles
    reg [3:0] count;

    // FSM state register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (write) ? SHIFT : IDLE;
            SHIFT: next_state = (count == 11) ? DONE : SHIFT;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (state == SHIFT)
            count <= count + 1;
        else
            count <= 0;
    end

    // Output Logic
    always @(*) begin
        // Default values
        load_en       = 0;
        shift_en      = 0;
        write_mem_en  = 0;
        write_mem_busy= 0;

        case (state)
            IDLE: begin
                load_en = 1;
            end
            SHIFT: begin
                shift_en = 1;
                write_mem_busy = 1;
            end
            DONE: begin
                write_mem_en = 1;
            end
        endcase
    end

endmodule