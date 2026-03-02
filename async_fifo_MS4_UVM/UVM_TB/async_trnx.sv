typedef enum {NONE,RESET,STIMULUS} trnx_type;

class trnx extends uvm_sequence_item;

	rand bit wen;
    rand bit [DATA_W-1:0]wdata_in;
    rand bit ren;
    trnx_type  kind;
    bit [DATA_W-1:0] rdata_out; 
	
	bit [31:0] reset_cycles;
	
	
	constraint wen_valid{
		wen inside {0,1};
	}
	
	constraint ren_valid{
		ren inside {0,1};
	}
	
	constraint wdata_in_valid{
		wdata_in inside {[0:$]};
	}
	
	function new(string name = "Trnx");
		super.new(name);
	endfunction
	
	`uvm_object_utils_begin(trnx)
	`uvm_field_int(wen,UVM_ALL_ON | UVM_DEC)
	`uvm_field_int(ren,UVM_ALL_ON | UVM_DEC)
	`uvm_field_int(wdata_in,UVM_ALL_ON | UVM_DEC)
	`uvm_field_enum(trnx_type,kind,UVM_ALL_ON | UVM_DEC)
	`uvm_object_utils_end
	
	function string convert2string();
		return $sformatf("Wen = %0d, Wdata = %0d, Ren = %0d",wen,wdata_in,ren);
	endfunction	
	
	// function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	// 	bit status = 1;
	// 	
	// 	
	// 	
	// 	return status;
	// endfunction
	
endclass