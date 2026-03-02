class environment extends uvm_env;
	`uvm_component_utils(environment)
	
	master_agent m_agent;
	slave_agent s_agent;
	scoreboard scb;
	
	int unsigned matche,mis_matched,exp_pkt_count;
	function new(string name = "Environment",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function build_phase;
		
		m_agent = master_agent::type_id::create("m_agent",this);
		s_agent = slave_agent::type_id::create("s_agent",this);
		scb = scoreboard::type_id::create("scb",this);
		
	
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_agent.pass_through_ap_port.connect(scb.mon_in);
		s_agent.pass_through_ap_port.connect(scb.mon_out);
	endfunction
	
	function void extract_phase(uvm_phase phase);
		//super.extract_phase(phase);
		
		uvm_config_db#(int)::get(this,"m_agent.seqr","item_count",exp_pkt_count);
		
		uvm_config_db#(int)::get(this,"","m_matched",matched);
		uvm_config_db#(int)::get(this,"","mis_matched",mis_matched);		
		
	endfunction
	
	
	function void report_phase(uvm_phase phase);
	//
		int tot_scb_cnt;
		tot_scb_cnt = matched + mis_matched;
		if(exp_pkt_count != tot_scb_cnt) begin
			`uvm_info("FAIL",$sformatf("Test Fail cause matched = %0d, mis_matched = %0d",matched,mis_matched),UMV_NONE);
		end else if(mis_matched !=0) begin
			`uvm_info("FAIL",$sformatf("Test Fail cause matched = %0d, mis_matched = %0d",matched,mis_matched),UVM_NONE);
		
		end else begin
			`uvm_info("PASS","Test PASS",UVM_NONE);
		
		end
		
	endfunction
endclass