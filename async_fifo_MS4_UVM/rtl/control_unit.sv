module control_unit #(
    parameter ADDR_WIDTH = 9,
    parameter M_VAL = 1,
    parameter N_VAL = 2
) (
    // Write Domain
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    output logic                  wfull,
    output logic                  w_three_fourth_full,
    output logic                  w_m_n_full,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic [ADDR_WIDTH:0]   wptr,

    // Read Domain
    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    output logic                  rempty,
    output logic                  r_one_fourth_empty,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic [ADDR_WIDTH:0]   rptr
);

    logic [ADDR_WIDTH:0] wq2_rptr, rq2_wptr;

    // Synchronizers
    sync_ptr #(.ADDR_WIDTH(ADDR_WIDTH)) sync_r2w (
        .dest_clk(wclk),
        .dest_rst_n(wrst_n),
        .ptr_in(rptr),
        .ptr_out(wq2_rptr)
    );

    sync_ptr #(.ADDR_WIDTH(ADDR_WIDTH)) sync_w2r (
        .dest_clk(rclk),
        .dest_rst_n(rrst_n),
        .ptr_in(wptr),
        .ptr_out(rq2_wptr)
    );

    // Sender Control
    sender_control #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .M_VAL(M_VAL),
        .N_VAL(N_VAL)
    ) sender_ctrl_inst (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .wq2_rptr(wq2_rptr),
        .wfull(wfull),
        .w_three_fourth_full(w_three_fourth_full),
        .w_m_n_full(w_m_n_full),
        .waddr(waddr),
        .wptr(wptr)
    );

    // Receiver Control
    receiver_control #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) receiver_ctrl_inst (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rq2_wptr(rq2_wptr),
        .rempty(rempty),
        .r_one_fourth_empty(r_one_fourth_empty),
        .raddr(raddr),
        .rptr(rptr)
    );
	
	
	covergroup cg_write@(posedge wclk);
		
	 cp_wen_asserted: coverpoint winc {
		bins wen_0 = {0};
		bins wen_1 = {1};
	  }
	  
	  cp_waddr: coverpoint waddr {
		bins addr_low   = {[0:127]};
		bins addr_mid   = {[128:383]};
		bins addr_high  = {[384:511]};
	  }
	  
	  trans_wfull: coverpoint wfull {
		bins empty_to_full = (0 => 1);
		bins full_to_empty = (1 => 0);
		bins sustained_full = (1 => 1);
		bins sustained_empty = (0 => 0);
	  }
	  
	  trans_w_three_fourth_full: coverpoint w_three_fourth_full {
		bins empty_to_full = (0 => 1);
		bins full_to_empty = (1 => 0);
		bins sustained_full = (1 => 1);
		bins sustained_empty = (0 => 0);
	  }
	  
	endgroup
	
	covergroup cg_addr@(posedge rclk); 
	  cp_raddr: coverpoint raddr {
		bins addr_low   = {[0:127]};
		bins addr_mid   = {[128:383]};
		bins addr_high  = {[384:511]};
	  }
	  
	  cp_rempty_edge: coverpoint rempty {
		bins not_empty = {0};
		bins empty = {1};
	  }
	  
	  cp_r_one_fourth_empty_edge: coverpoint r_one_fourth_empty {
		bins not_empty = {0};
		bins empty = {1};
	  }
	  
	  
	endgroup
	
	cg_write cw_inst;
	
	initial begin
		cw_inst = new();
	end
	
endmodule
