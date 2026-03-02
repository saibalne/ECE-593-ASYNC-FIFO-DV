class async_imonitor;
	
	//import async_pkg::*;
	
	virtual async_if vif;
	mailbox#(async_trnx) mbx;
	mailbox#(async_trnx) mbx2;
	async_trnx pkt,pkt2;
	bit[31:0] write_count;
	bit[31:0] full_write_attempt;
	
	string name = "IMONITOR";
	
	function new(virtual async_if vif,mailbox#(async_trnx) mbx,mbx2);// Get interface and the mailbox to connect it to the scoreboard
		this.mbx= mbx;
		this.mbx2= mbx2;
		this.vif = vif;
	endfunction
	
	task run();
		forever begin
			//Capturing Writes here
			@(vif.mw_cb);
			//if(vif.mw_cb.wen) 
			begin
				if(!vif.mw_cb.full) begin
					pkt = new();
					pkt.wen = vif.mw_cb.wen;
					pkt.wdata_in = vif.mw_cb.wdata_in;
					
					pkt2 = new();
					pkt2.copy(pkt);
					
					mbx.put(pkt);
					mbx2.put(pkt2);
					write_count++;
					print_info(name,pkt.get_write_info());
					
					
				end else begin
					full_write_attempt++;
				end
			end
		end
	endtask
	
	function void report();
        $display("%0s  ---- Input Monitor Report ----",name);
        $display("%0s  Valid writes captured : %0d",name, write_count);
        $display("%0s  Write-on-full attempts: %0d",name, full_write_attempt);
    endfunction
	
endclass