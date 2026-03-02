//import async_pkg::*;
class async_coverage;
	
	mailbox #(async_trnx) mbx;
	async_trnx pkt;
	real coverage_score;
		
	string name = "COVERGROUP";
	
	covergroup fcov with function sample(async_trnx pkt);
	
		cp_wen: coverpoint pkt.wen{
			bins only_wen = {1};
		}
		
		//cp_ren: coverpoint pkt.ren{
		//	bins only_ren = {1};
		//}
		
		//cross pkt.wen,pkt.ren;
		
		cp_wdata_in: coverpoint pkt.wdata_in{
			//bins minimum = {'0};
			//bins maximum = {'1};
			bins short = {[0:100]};
			bins mid = {[101:200]};
			bins long = {[201:255]};
		}
	
		//cross pkt.wen,pkt.wdata_in;
		
	endgroup
	
	function new(mailbox #(async_trnx) mbx);
		fcov = new;
		this.mbx = mbx;
	endfunction
	
	task run();
		forever begin
			mbx.get(pkt);
			#0;
			fcov.sample(pkt);
			
			coverage_score = fcov.get_coverage();
			print_info(name,$sformatf("Coverage Score : %0f",coverage_score));
			$display("[Coverage] Coverage Score : %0f",coverage_score);
		end
	endtask
	
	function void report();
	
		$display("");
        $display("============================================");
        $display("        Coverage FINAL REPORT            ");
        $display("============================================");
		$display("        Final Coverage Score : %0f          ",coverage_score);
        $display("============================================");
        $display("");
		
		
	endfunction

endclass
