module write_ctrl #(
    parameter ADDR_W = 8
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic [ADDR_W:0]      rptr_gray,
    output logic [ADDR_W-1:0]    addr,
    output logic [ADDR_W:0]      ptr_gray,
    output logic                 full
);

    logic [ADDR_W:0] bin, bin_next, gray_next;

    assign bin_next  = bin + (en && !full);
    assign gray_next = (bin_next >> 1) ^ bin_next;
    assign addr      = bin[ADDR_W-1:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bin      <= '0;
            ptr_gray <= '0;
            full     <= 1'b0;
        end else begin
            bin      <= bin_next;
            ptr_gray <= gray_next;
            full     <= (gray_next == {~rptr_gray[ADDR_W:ADDR_W-1],
                                       rptr_gray[ADDR_W-2:0]});
        end
    end

endmodule
