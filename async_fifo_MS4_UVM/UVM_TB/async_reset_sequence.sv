class reset_sequence extends uvm_sequence#(trnx);

	`uvm_object_utils(reset_sequence)
	
	function new(string name= "RESET_SEQ");
		super.new(name);
		
		set_automatic_phase_objection(1);
	endfunction
	
	
	task body();
		
		`uvm_info("RST","Reset sequence is Started",UVM_MEDIUM)
		req = trnx::type_id::create("RST");
		start_item(req);
		
		req.kind = RESET;
		req.reset_cycles = 2;
		
		finish_item(req);
		
		`uvm_info("RST","Reset sequence is finished",UVM_MEDIUM)
		
	endtask
	
endclass