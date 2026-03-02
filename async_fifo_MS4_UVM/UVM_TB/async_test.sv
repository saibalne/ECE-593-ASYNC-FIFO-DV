class test extends uvm_test;
	`uvm_component_utils(test)
	
	virtual async_if vif;
	
	environment env;
	
	function new(string name = "Test",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = environment::type_id::create("env",this);
		
		uvm_config_db#(virtual async_if)::get(this,"","vif",vif);
		
		uvm_config_db#(virtual async_if.w_tb)::set(this,"env.*","wvif",vif.w_tb);
		uvm_config_db#(virtual async_if.r_tb)::set(this,"env.*","rvif",vif.r_tb);
		
		uvm_config_db#(virtual async_if.tb_mon)::set(this,"env.*","mon_vif",vif.tb_mon)
		
		
		uvm_config_db#(int)::set(this,"env.*","item_count",10)
		
		// Implicit sequence phasing
		uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
		uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",main_sequence::get_type());
		
		
	endfunction
	
	task main_phase(uvm_phase phase);
		uvm_objection objection;
		super.main_phase(phase);
		
		objection = phase.get_objection();
		
		objection.drain_time(this,100ns);
		
	endtask
endclass