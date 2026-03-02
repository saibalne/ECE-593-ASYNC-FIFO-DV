module sender_control #(
    parameter ADDR_WIDTH = 9,
    parameter M_VAL = 1,
    parameter N_VAL = 2
) (
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    input  logic [ADDR_WIDTH:0]   wq2_rptr,
    output logic                  wfull,
    output logic                  w_three_fourth_full,
    output logic                  w_m_n_full,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic [ADDR_WIDTH:0]   wptr
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

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            bin_ptr  <= '0;
            gray_ptr <= '0;
        end else begin
            bin_ptr  <= next_bin_ptr;
            gray_ptr <= next_gray_ptr;
        end
    end

    assign next_bin_ptr  = bin_ptr + (winc & ~wfull);
    assign next_gray_ptr = bin2gray(next_bin_ptr);

    assign waddr = bin_ptr[ADDR_WIDTH-1:0];
    assign wptr  = gray_ptr;

    // Full detection
    // Full if MSB differs, MSB-1 differs, and rest are same
    logic wfull_val;
    // Full condition for Gray code:
    // MSB and MSB-1 are inverted, the rest are the same.
    // Correct Gray code full detection:
    // MSB and MSB-1 are inverted, the rest are the same.
    assign wfull_val = (next_gray_ptr == {~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1], wq2_rptr[ADDR_WIDTH-2:0]});
    
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) wfull <= 1'b0;
        else         wfull <= wfull_val;
    end
    
    // Debug print
    // Debug print removed

    // Advanced Flag Generation
    // Calculate current occupancy in write domain
    logic [ADDR_WIDTH:0] rptr_bin;
    logic [ADDR_WIDTH:0] occupancy;
    
    assign rptr_bin = gray2bin(wq2_rptr);
    assign occupancy = bin_ptr - rptr_bin;

    localparam DEPTH = 1 << ADDR_WIDTH;
    assign w_three_fourth_full = (occupancy >= (3 * DEPTH / 4));
    assign w_m_n_full          = (occupancy >= (M_VAL * DEPTH / N_VAL));

endmodule
