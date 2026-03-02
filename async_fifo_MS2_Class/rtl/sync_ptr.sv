module sync_ptr #(
    parameter ADDR_WIDTH = 9
) (
    input  logic                  dest_clk,
    input  logic                  dest_rst_n,
    input  logic [ADDR_WIDTH:0]   ptr_in,
    output logic [ADDR_WIDTH:0]   ptr_out
);

    logic [ADDR_WIDTH:0] sync_reg [0:1];

    always_ff @(posedge dest_clk or negedge dest_rst_n) begin
        if (!dest_rst_n) begin
            sync_reg[0] <= '0;
            sync_reg[1] <= '0;
        end else begin
            sync_reg[0] <= ptr_in;
            sync_reg[1] <= sync_reg[0];
        end
    end

    assign ptr_out = sync_reg[1];

endmodule
