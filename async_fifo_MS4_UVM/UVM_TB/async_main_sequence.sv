class main_seq extends uvm_sequence#(trnx);
	`uvm_object_utils(main_seq)
	
	bit [31:0] item_count;
	
	function new(string name = "MAIN_SEQ");
		super.new(name);
		
		set_automatic_phase_objection(1);
	endfunction

	function void pre_start();
		uvm_config_db#(int)::get(this,"env.m_agent","item_count",item_count);
	endfunction
	
	task body();
		`uvm_info("MAIN_SEQ","Main Sequence is Started",UVM_MEDIUM)
		for(int idx =0;idx<item_count;idx++) begin
			
			req = trnx::type_id::create("main_seq");
			start_item(req);
			req.randomize();
			finish_item(req);
			`uvm_info("MAIN_SEQ",$sformatf("Generation of Transaction id = %0d is finished",idx),UVM_MEDIUM)
		end
		
		`uvm_info("MAIN_SEQ","Main Sequence is finished",UVM_MEDIUM)
	endtask
endclass