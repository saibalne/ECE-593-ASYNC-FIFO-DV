class master_agent extends uvm_agent;
	`uvm_component_utils(master_agent)
	
	sequencer seqr;
	driver drvr;
	iMonitor iMon;
	
	uvm_analysis_port#(trnx) pass_through_ap_port;
	
	function new(string name="M_AGENT", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pass_through_ap_port= new("pass_through_ap_port",this);
		
		if(is_active == ACTIVE) begin
			seqr = sequencer::type_id::create("seqr",this);
			drvr = driver::type_id::create("drvr",this);
		end
		iMon = iMonitor::type_id::create("iMon",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == ACTIVE) begin
			drvr.seq_item_port.connect(seqr.seq_item_export);
		end
		iMon.analysis_port.connect(this.pass_through_ap_port);

	endfunction
	
endclass