`include "async_pkg.sv"
`include "async_if.sv"
`include "async_test.sv"

module top;

	
	import async_pkg::*;
	
	logic wclk,rclk;
	
	always #5 wclk =!wclk;
	always #4 rclk = !rclk;
	
	async_test test;
	
	async_if vif(wclk,rclk);
	
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
		wclk = 0;
		rclk =0;
		vif.rrst_n <= 0;
		vif.wrst_n <= 0;
		vif.wen<=0;
		vif.ren<=0;
		//test = new();
		test = new(vif);
		test.run();
		
	end
	
	
	initial begin
		$dumpfile("abcd.vcd");
		$dumpvars();
	end

endmodule