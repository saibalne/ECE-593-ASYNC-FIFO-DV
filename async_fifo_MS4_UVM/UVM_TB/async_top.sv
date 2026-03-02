`include "async_pkg.sv"

module top;
	import uvm_pkg::*;
	
	import async_pkg::*;
	
	`include "uvm_macros.svh"
	`include "async_test.sv"
	
	logic wclk,rclk;
	
	always #5 wclk = !wclk;
	always #4 rclk = !rclk;
	
	async_test test;
	async_if  vif(wclk,rclk);
	
	initial clk = 0;
	
	async_fifo #(.DATA_WIDTH(DATA_W),.ADDR_WIDTH(ADDR_W),.M_VAL(M_VAL),.N_VAL(N_VAL)) dut(
		.wclk(wclk),
		.wrst_n(vif.wrst_n),
		.winc(vif.wen),
		.wdata(vif.wdata_in),
		.wfull(vif.full),
		.w_three_fourth_full(vif.full_3_4th),
		.w_m_n_full(vif.w_m_n_full),
		.rclk(rclk),
		.rrst_n(vif.rrst_n),
		.rinc(vif.ren),
		.rdata(vif.rdata_out),
		.rempty(vif.empty),
		.r_one_fourth_empty(vif.empty_1_4th)
	);
	
	
	initial begin
		uvm_config_db#(virtual async_if)::set(this,"","vif",vif);
		
		run_test();
	end
	
endmodule