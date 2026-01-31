module fifo_mem #(
    parameter DATA_W = 8,
    parameter ADDR_W = 8
)(
    input  logic                 wclk,
    input  logic                 wen,
    input  logic [ADDR_W-1:0]    waddr,
    input  logic [DATA_W-1:0]    wdata,
    input  logic [ADDR_W-1:0]    raddr,
    output logic [DATA_W-1:0]    rdata
);

    localparam DEPTH = 1 << ADDR_W;
    logic [DATA_W-1:0] mem [0:DEPTH-1];

    always_ff @(posedge wclk)
        if (wen)
            mem[waddr] <= wdata;

    assign rdata = mem[raddr];

endmodule
