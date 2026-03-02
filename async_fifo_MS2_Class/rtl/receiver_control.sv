module receiver_control #(
    parameter ADDR_WIDTH = 9
) (
    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    input  logic [ADDR_WIDTH:0]   rq2_wptr,
    output logic                  rempty,
    output logic                  r_one_fourth_empty,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic [ADDR_WIDTH:0]   rptr
);

    logic [ADDR_WIDTH:0] bin_ptr;
    logic [ADDR_WIDTH:0] gray_ptr;
    logic [ADDR_WIDTH:0] next_bin_ptr;
    logic [ADDR_WIDTH:0] next_gray_ptr;

    // Gray code conversion
    function automatic logic [ADDR_WIDTH:0] bin2gray(input logic [ADDR_WIDTH:0] bin);
        return (bin >> 1) ^ bin;
    endfunction

    // Gray code back to binary for flag calculations
    function automatic logic [ADDR_WIDTH:0] gray2bin(input logic [ADDR_WIDTH:0] gray);
        logic [ADDR_WIDTH:0] bin;
        bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
        for (int i = ADDR_WIDTH-1; i >= 0; i--) begin
            bin[i] = bin[i+1] ^ gray[i];
        end
        return bin;
    endfunction

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            bin_ptr  <= '0;
            gray_ptr <= '0;
        end else begin
            bin_ptr  <= next_bin_ptr;
            gray_ptr <= next_gray_ptr;
        end
    end

    assign next_bin_ptr  = bin_ptr + (rinc & ~rempty);
    assign next_gray_ptr = bin2gray(next_bin_ptr);

    assign raddr = bin_ptr[ADDR_WIDTH-1:0];
    assign rptr  = gray_ptr;

    // Empty detection
    logic rempty_val;
    assign rempty_val = (next_gray_ptr == rq2_wptr);

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) rempty <= 1'b1;
        else         rempty <= rempty_val;
    end

    // Advanced Flag Generation
    logic [ADDR_WIDTH:0] wptr_bin;
    logic [ADDR_WIDTH:0] occupancy;
    
    assign wptr_bin = gray2bin(rq2_wptr);
    assign occupancy = wptr_bin - bin_ptr;

    localparam DEPTH = 1 << ADDR_WIDTH;
    // 1/4 empty means occupancy is <= 3/4 depth (since 1/4 is empty, 3/4 is full)
    // Or more accurately, if we define "1/4 empty" as "at most 3/4 full"
    assign r_one_fourth_empty = (occupancy <= (3 * DEPTH / 4));


	
	
	
	
	
	
endmodule
