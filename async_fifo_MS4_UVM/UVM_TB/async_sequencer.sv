class sequencer extends uvm_sequencer;
	
	`uvm_component_utils(seqr)

	function new(string name="SEQR",uvm_component parent = null);
		super.new(name,parent);
	endfunction
		
endclass