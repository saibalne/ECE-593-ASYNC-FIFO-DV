

class async_scoreboard;
	
	//import async_pkg::*;
	
	mailbox#(async_trnx) imbx;
	mailbox#(async_trnx) ombx;
	
	async_trnx ipkt;
	async_trnx opkt;
	
	bit [31:0] fifo_depth;
	bit [31:0] write_count;
	bit [31:0] read_count;
	bit [31:0] fail_count;
	bit [31:0] match_count;
	
	bit [DATA_W-1:0] mem[$];
	bit [DATA_W-1:0] expected;
	string name = "SCOREBOARD";
	
	
	function new(mailbox#(async_trnx) imbx,mailbox#(async_trnx) ombx);
		this.imbx = imbx;
		this.ombx = ombx;
		fifo_depth = 1<<ADDR_W;
	endfunction
	
	task run();
		print_info(name,"Run Started");
        fork
            run_write_side();
            run_read_side();
        join
    endtask
	
	task run_write_side();
		forever begin
			print_info(name,"About to receive the data");
			imbx.get(ipkt);
			print_info(name,"Received the data");
			#0;
			if(ipkt.wen) 
			begin
				if(mem.size() < fifo_depth) begin
					mem.push_back(ipkt.wdata_in);
					write_count++;
					print_info(name,ipkt.get_write_info());
				end else begin
					$display("[%0s] %0d Fifo Depth = %0d",name,mem.size(),fifo_depth);
					print_info(name,"DUT wrote past full");
				end
			
			end
        end
	endtask
	
	task run_read_side();
		forever begin
			
            ombx.get(opkt);
			read_count++;
			if(opkt.ren) 
			begin
				if(mem.size() == 0) begin
					fail_count++;
					print_info(name,$sformatf("[ERROR] %0s",opkt.get_read_info()));
				end else begin
					expected = mem.pop_front();
					if(expected == opkt.rdata_out) begin
						match_count++;
						print_info(name,$sformatf("[PASS] %0s",opkt.get_read_info()));
					end else begin
						fail_count++;
						print_info(name,$sformatf("[ERROR] %0s",opkt.get_read_info()));
					end
				end
				
			end
        end
			
	endtask


	function void report();
	
		$display("");
        $display("============================================");
        $display("        SCOREBOARD FINAL REPORT            ");
        $display("============================================");
        $display("  Total Writes  : %0d", write_count);
        $display("  Total Reads   : %0d", read_count);
        $display("  PASS          : %0d", match_count);
        $display("  FAIL          : %0d", fail_count);
        $display("  Leftover in FIFO : %0d", mem.size());
        $display("============================================");
        if (fail_count == 0 )
            $display("  *** TEST PASSED ***");
        else
            $display("  *** TEST FAILED – %0d mismatches ***", fail_count);
        $display("============================================");
        $display("");
		
		
	endfunction
	
endclass