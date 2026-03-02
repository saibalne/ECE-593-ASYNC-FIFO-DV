module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 9
) (
    input  logic                  wclk,
    input  logic                  wclken,
    input  logic [ADDR_WIDTH-1:0] waddr,
    input  logic [DATA_WIDTH-1:0] wdata,
    input  logic                  rclk,
    input  logic [ADDR_WIDTH-1:0] raddr,
    output logic [DATA_WIDTH-1:0] rdata
);

    localparam DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always_ff @(posedge wclk) begin
        if (wclken) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation (Asynchronous for FIFO logic simplicity, can be registered if needed)
    assign rdata = mem[raddr];


	
	
endmodule
