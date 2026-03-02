class driver extends uvm_driver;
	
	`uvm_component_utils(driver)
	
	virtual fifo_if.w_tb wvif;
	virtual fifo_if.r_tb rvif;
	
	int unsigned no_of_trnxs_recvd;
	
	function new(string name="DRVR",uvm_component parent = null);
		super.new(name,parent);
		
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		if(!uvm_config_db#(virtual fifo_if)::get(this,"env.*","wvif",wvif))
			`uvm_fatal("VIF_ERR","Wvif interface is not set")
		if(!uvm_config_db#(virtual fifo_if)::get(this,"env.*","rvif",rvif))
			`uvm_fatal("VIF_ERR","Rvif interface is not set")
	
	endfunction
	
	task run_phase(uvm_phase phase);
		
		seq_item_port.get_next_item(req);
		drive(req);
		seq_item_port.item_done(req);
	
	endtask
	
	
	task drive(trnx pkt);
		no_of_trnxs_recvd++;
		case(pkt.kind)
			NONE: `uvm_info("UNKNOWN_PKT","Received Unknown transaction",UVM_MEDIUM)
			RESET: drive_reset(pkt);
			STIMULUS: drive_stimulus(pkt);
			default: `uvm_info("UNKNOWN_PKT","Received Unknown transaction",UVM_MEDIUM)
		endcase
	endtask
	
	task drive_reset(trnx pkt);
		`uvm_info("RESET","Driving Reset transaction Started.",UVM_DEBUG)
		wvif.wrst_n <= 0;
		rvif.rrst_n <= 0;
		repeat(pkt.reset_cycles) @(wvif.wcb);
		wvif.wrst_n <= 1;
		rvif.rrst_n <= 1;
		`uvm_info("RESET","Driving Reset transaction finished.",UVM_DEBUG)
	endtask
	
	task drive_stimulus(trnx pkt);
		`uvm_info("DRIVER",$sformatf("Driving transaction %0d Started.",no_of_trnxs_recvd),UVM_DEBUG)
		fork 
			begin
				@(wvif.wcb);
				wvif.wcb.wen <= pkt.wen;
				wvif.wcb.wdata_in <= pkt.wdata_in;
			end
			begin
				@(rvif.rcb);
				rvif.rcb.ren <= pkt.ren;
			end
		join
		`uvm_info("DRIVER",$sformatf("Driving transaction %0d finished.",no_of_trnxs_recvd),UVM_DEBUG)
	endtask
	
endclass