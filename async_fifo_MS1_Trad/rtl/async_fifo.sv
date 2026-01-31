`include "fifo_mem.sv"
`include "synchronizer.sv"
`include "sender_cntrl.sv"
`include "receiver_cntrl.sv"


module async_fifo #(
    parameter DATA_W = 8,
    parameter ADDR_W = 8
)(
    // Write domain
    input  logic                 wclk,
    input  logic                 wrst_n,
    input  logic                 wen,
    input  logic [DATA_W-1:0]    wdata,
    output logic                 wfull,

    // Read domain
    input  logic                 rclk,
    input  logic                 rrst_n,
    input  logic                 ren,
    output logic [DATA_W-1:0]    rdata,
    output logic                 rempty
);

    logic [ADDR_W-1:0] waddr, raddr;
    logic [ADDR_W:0]   wptr_gray, rptr_gray;
    logic [ADDR_W:0]   wptr_gray_sync, rptr_gray_sync;

    //------------------------------------
    // Memory
    //------------------------------------
    fifo_mem #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) mem_i (
        .wclk   (wclk),
        .wen   (wen && !wfull),
        .waddr  (waddr),
        .wdata  (wdata),
        .raddr  (raddr),
        .rdata  (rdata)
    );

    //------------------------------------
    // Pointer Synchronizers
    //------------------------------------
    ptr_sync #(.WIDTH(ADDR_W+1)) sync_r2w (
        .clk    (wclk),
        .rst_n  (wrst_n),
        .din    (rptr_gray),
        .dout   (rptr_gray_sync)
    );

    ptr_sync #(.WIDTH(ADDR_W+1)) sync_w2r (
        .clk    (rclk),
        .rst_n  (rrst_n),
        .din    (wptr_gray),
        .dout   (wptr_gray_sync)
    );

    //------------------------------------
    // Write Pointer & Full Logic
    //------------------------------------
    write_ctrl #(.ADDR_W(ADDR_W)) wctrl (
        .clk        (wclk),
        .rst_n      (wrst_n),
        .en        (wen),
        .rptr_gray  (rptr_gray_sync),
        .addr       (waddr),
        .ptr_gray   (wptr_gray),
        .full       (wfull)
    );

    //------------------------------------
    // Read Pointer & Empty Logic
    //------------------------------------
    read_ctrl #(.ADDR_W(ADDR_W)) rctrl (
        .clk        (rclk),
        .rst_n      (rrst_n),
        .en        (ren),
        .wptr_gray  (wptr_gray_sync),
        .addr       (raddr),
        .ptr_gray   (rptr_gray),
        .empty      (rempty)
    );

endmodule
