module read_ctrl #(
    parameter ADDR_W = 8
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic [ADDR_W:0]      wptr_gray,
    output logic [ADDR_W-1:0]    addr,
    output logic [ADDR_W:0]      ptr_gray,
    output logic                 empty
);

    logic [ADDR_W:0] bin, bin_next, gray_next;

    assign bin_next  = bin + (en && !empty);
    assign gray_next = (bin_next >> 1) ^ bin_next;
    assign addr      = bin[ADDR_W-1:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bin      <= '0;
            ptr_gray <= '0;
            empty    <= 1'b1;
        end else begin
            bin      <= bin_next;
            ptr_gray <= gray_next;
            empty    <= (gray_next == wptr_gray);
        end
    end

endmodule
