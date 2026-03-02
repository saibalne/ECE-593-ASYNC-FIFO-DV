class async_omonitor;
	virtual async_if vif;
	mailbox #(async_trnx) mbx;
	async_trnx pkt;
	
	bit [31:0] read_count;
	bit [31:0] empty_read_attempt;
	
	string name = "OMONITOR";
	
	function new(virtual async_if vif,mailbox#(async_trnx) mbx);
		this.mbx = mbx;
		this.vif = vif;
	endfunction
	
	task run();
		forever begin
			// Capture the read packets
			@(vif.mr_cb);
			//if(vif.mr_cb.ren) 
			begin
				if(!vif.mr_cb.empty) begin
					pkt = new();
					pkt.ren = vif.mr_cb.ren;
					pkt.rdata_out = vif.mr_cb.rdata_out;
					mbx.put(pkt);
					read_count++;
					print_info(name,pkt.get_read_info());
				end else begin
					empty_read_attempt++;
				end
			end
		end
	endtask
	
	
	function void report();
        $display("%0s ---- Output Monitor Report ----",name);
        $display("%0s Valid reads  captured  : %0d",name, read_count);
        $display("%0s Read-on-empty attempts : %0d",name, empty_read_attempt);
    endfunction
	
endclass