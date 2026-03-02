`include "async_env.sv"
class async_test;
	
	bit [31:0] total_trnxs;
	async_env env;
	virtual async_if vif;
	string name = "TEST";
	
	function new(virtual async_if vif); 
		this.vif = vif;
	endfunction
	
	
	function void build();
		total_trnxs = 100;
		env = new(vif,total_trnxs); 
		env.build();
		
	endfunction
	
	
	task run();
		build();
		env.run();
		
	endtask
	
endclass