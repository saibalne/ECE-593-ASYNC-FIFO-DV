`include "async_generator.sv"
`include "async_driver.sv"
`include "async_imonitor.sv"
`include "async_omonitor.sv"
`include "async_sb.sv"
`include "async_coverage.sv"



class async_env;

	async_generator gen;
	async_driver drvr;
	async_imonitor imon;
	async_omonitor omon;
	async_scoreboard scb;
	async_coverage cov;
	bit [31:0] total_trnxs;
	
	mailbox #(async_trnx) mbx;
	mailbox #(async_trnx) imbx;
	mailbox #(async_trnx) ombx;
	mailbox #(async_trnx) cmbx;
	virtual async_if vif;
	
	string name = "ENVIRONMENT";
	
	
	function new(virtual async_if vif, bit [31:0] total_trnxs);
		this.total_trnxs = total_trnxs;
		this.vif = vif;
	endfunction
	
	
	function void build();
		
		mbx = new(1);
		imbx = new(1);
		ombx = new(1);
		cmbx = new(1);
		
		gen = new(mbx,total_trnxs);
		drvr = new(vif,mbx);
		imon = new(vif,imbx,cmbx);
		omon = new(vif,ombx);
		scb = new(imbx,ombx);
		cov = new(cmbx);
	endfunction


	task run();
		
		fork
			gen.run();
			drvr.run();
			imon.run();
			omon.run();
			scb.run();
			cov.run();
		join_any
		
		report();
		$display("%0s Run completed",name);
		$finish;
	endtask
	
	
	function void report();
		gen.report();
		drvr.report();
		imon.report();
		omon.report();
		scb.report();
		cov.report();
	endfunction
endclass