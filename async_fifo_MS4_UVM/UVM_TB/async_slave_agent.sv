class slave_agent extends uvm_agent;
	`uvm_component_utils(slave_agent)

	oMonitor oMon;
	
	uvm_analysis_port#(trnx) pass_through_ap_port;
	
	function new(string name="S_AGENT", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pass_through_ap_port= new("pass_through_ap_port",this);
		
		oMon = oMonitor::type_id::create("oMon",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		oMon.analysis_port.connect(this.pass_through_ap_port);

	endfunction
	
endclass