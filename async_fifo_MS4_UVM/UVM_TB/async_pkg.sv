package async_pkg;
    parameter ADDR_W = 9;
    parameter DATA_W = 8;
	parameter BURST_LENGTH = 450;
	
	parameter M_VAL = 1;
    parameter N_VAL = 2;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	
    `include "async_trnx.sv"
	
	`include "async_reset_sequence.sv"
	`include "async_main_sequence.sv"
	`include "async_sequencer.sv"
	`include "async_driver.sv"
	`include "async_iMonitor.sv"
	`include "async_oMonitor.sv"
	`include "async_master_agent.sv"
	`include "async_slave_agent.sv"
	`include "async_scoreboard.sv"
	`include "async_env.sv"
	
endpackage