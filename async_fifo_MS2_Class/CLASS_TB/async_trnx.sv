
typedef enum {RESET,DRIVE } trnx_type;

class async_trnx;

    rand bit wen;
    rand bit [DATA_W-1:0]wdata_in;
    rand bit ren;
    trnx_type  kind;
	bit [DATA_W-1:0] rdata_out; 
	
    constraint valid{
		wen inside {0,1};
		ren inside {0,1};
        wdata_in inside {[0:$]};
    }

    function void print();
        $display("[Transaction] Wen : %0d, WData_in : %0d, ren : %0d",wen,wdata_in,ren);
    endfunction

    function void copy(async_trnx pkt);
        this.wen = pkt.wen;
        this.wdata_in = pkt.wdata_in;
        this.ren = pkt.ren;
        this.kind = pkt.kind;
    endfunction
	
	function string get_write_info();
		return $sformatf("Wen = %0d, Wdata_in = %0d",this.wen, this.wdata_in);
	endfunction
	
	function string get_read_info();
		
		return $sformatf("Ren = %0d, Rdata_out = %0d",this.ren, this.rdata_out);
	endfunction
	
endclass