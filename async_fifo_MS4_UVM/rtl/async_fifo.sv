`include "fifo_mem.sv"
`include "receiver_control.sv"
`include "sender_control.sv"
`include "sync_ptr.sv"
`include "control_unit.sv"

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 9, // 2^9 = 512, meets > 360 requirement
    parameter M_VAL = 1,
    parameter N_VAL = 2
) (
    // Write Interface
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic                  wfull,
    output logic                  w_three_fourth_full,
    output logic                  w_m_n_full,

    // Read Interface
    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  rempty,
    output logic                  r_one_fourth_empty
);

    logic [ADDR_WIDTH-1:0] waddr, raddr;
    logic [ADDR_WIDTH:0]   wptr, rptr;

    // Control Unit (Synchronizer + sender_control + receiver_control)
    control_unit #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .M_VAL(M_VAL),
        .N_VAL(N_VAL)
    ) ctrl_inst (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .wfull(wfull),
        .w_three_fourth_full(w_three_fourth_full),
        .w_m_n_full(w_m_n_full),
        .waddr(waddr),
        .wptr(wptr),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rempty(rempty),
        .r_one_fourth_empty(r_one_fourth_empty),
        .raddr(raddr),
        .rptr(rptr)
    );

    // FIFO Memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) mem_inst (
        .wclk(wclk),
        .wclken(winc & !wfull),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule
