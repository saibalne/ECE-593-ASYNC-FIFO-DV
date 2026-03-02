class iMonitor extends uvm_monitor;
	`uvm_component_utils(iMonitor)
	
	int unsigned no_of_pkts_recvd;
	int unsigned write_count;
	int unsigned full_write_attempt;
	virtual async_if.tb_mon vif;
	uvm_analysis_port#(trnx) analysis_port;
	
	function new(string name="iMon",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysis_port = new("ap",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		if(!uvm_config_db#(virtual async_if.tb_mon)::get(this,"env.*","mon_vif",vif))
			`uvm_fatal("VIF_ERR","Monitor vif interface is not set")
	
	endfunction
	
	
	task run_phase(uvm_phase phase);
		trnx pkt,pkt2;
		`uvm_info("OMon","OMonitor Started",UVM_MEDIUM)
		
		forever begin
			@(vif.mw_cb);
			no_of_pkts_recvd++; 
			begin
				if(!vif.mw_cb.full) begin
					
					pkt = trnx::type_id::create("Pkt");
					pkt.wen = vif.mw_cb.wen;
					pkt.wdata_in = vif.mw_cb.wdata_in;
					
					pkt2 = trnx::type_id::create("Pkt");
					pkt2.copy(pkt); // Future use
					analysis_port.write(pkt);
					write_count++;
				
				end else begin
					full_write_attempt++;
				end
			end
		
		end // end of forever
	
	endtask
	
endclass