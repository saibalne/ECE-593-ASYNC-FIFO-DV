class oMonitor extends uvm_monitor;
	`uvm_component_utils(oMonitor)
	
	int unsigned no_of_pkts_recvd;
	int unsigned read_count;
	int unsigned empty_read_attempt;
	
	virtual async_if.tb_mon vif;
	uvm_analysis_port#(trnx) analysis_port;
	
	function new(string name="oMon",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysis_port = new("ap",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		if(!uvm_config_db#(virtual async_if.tb_mon)::get(this,"env.*","mon_vif",vif))
			`uvm_fatal("VIF_ERR","OMonitor vif interface is not set")
	
	endfunction
	
	
	task run_phase(uvm_phase phase);
		trnx pkt,pkt2;
		`uvm_info("OMon","OMonitor Started",UVM_MEDIUM)
		
		forever begin
			@(vif.mr_cb);
			no_of_pkts_recvd++; 
			begin
				if(!vif.mr_cb.empty) begin
					
					pkt = trnx::type_id::create("Pkt");
					pkt.ren = vif.mr_cb.ren;
					pkt.rdata_in = vif.mr_cb.rdata_in;
					
					pkt2 = trnx::type_id::create("Pkt");
					pkt2.copy(pkt); // Future use // it won't work
					analysis_port.write(pkt); // passing to scoreboard
					read_count++;
				
				end else begin
					empty_read_attempt++;
				end
			end
		
		end // end of forever
	
	endtask
	
endclass