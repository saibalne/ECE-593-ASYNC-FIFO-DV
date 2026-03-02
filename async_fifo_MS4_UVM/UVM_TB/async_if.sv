import async_pkg::*;

interface async_if(input logic wclk,rclk);

    // Write Signals
    logic wrst_n;
    logic wen;
    logic [DATA_W-1:0]wdata_in;
    logic full;
    logic full_3_4th;
    logic w_m_n_full;
	
    // Read Signals
    logic rrst_n;
    logic ren;
    logic [DATA_W-1:0]rdata_out;
    logic empty;
    logic empty_1_4th;

    clocking wcb@(posedge wclk);
        output wen,wdata_in;
        input full, full_3_4th,w_m_n_full;
    endclocking

    clocking rcb@(posedge rclk);
        output ren;
        input empty,empty_1_4th;
    endclocking 
	
	clocking mw_cb@(posedge wclk);
		input wen,wdata_in;
        input full, full_3_4th,w_m_n_full;
	endclocking
	
	clocking mr_cb@(posedge rclk);
        input ren,rdata_out;
        input empty,empty_1_4th;
    endclocking
    
	
	modport w_tb(clocking wcb,output wrst_n);
	modport r_tb(clocking rcb,output rrst_n);
	
	modport tb_mon(clocking mw_cb,mr_cb,input wrst_n,rrst_n);
	
endinterface