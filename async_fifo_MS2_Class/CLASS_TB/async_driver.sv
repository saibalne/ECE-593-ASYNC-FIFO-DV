import async_pkg::*;
class async_driver;
    //import async_pkg::*;

    virtual async_if vif;
    mailbox #(async_trnx) mbx;
    int pkt_index = 0;
    async_trnx pkt;
    string name = "DRIVER";

    function new(virtual async_if vif,mailbox #(async_trnx) mbx);
        this.vif = vif;
        this.mbx = mbx;
    endfunction


    task drive_reset(input async_trnx pkt);

        print_info(name,$sformatf("Driving of reset packet Started."));
        vif.wrst_n <= 1'b0;
        vif.rrst_n <= 1'b0;
        repeat(2) @(vif.wcb);

        vif.wrst_n <= 1'b1;
        vif.rrst_n <= 1'b1;

        print_info(name,$sformatf("Driving of reset packet completed."));
    
    endtask

    task automatic drive_pkt(async_trnx pkt);
        print_info(name,$sformatf("Driving Packet %0d started.",pkt_index));
        
        fork
            begin
				@(vif.wcb);
                vif.wcb.wen <= pkt.wen;
                vif.wcb.wdata_in <= pkt.wdata_in;
            end
            begin
				@(vif.rcb);
                vif.rcb.ren <= pkt.ren;
            end
        join

        print_info(name,$sformatf("Driving Packet %0d completed.",pkt_index));
    endtask


    task drive(input async_trnx pkt);
        if(pkt.kind == RESET) begin
            drive_reset(pkt);
        end else if(pkt.kind == DRIVE) begin
            pkt_index++;
            drive_pkt(pkt);
        end
    endtask

    task run();
        
        forever begin
            mbx.get(pkt);
            drive(pkt);
        end
		
    endtask
	
	
	function void report();
		$display("%0s  ---- Report ----",name);
        $display("%0s Number of Transaction Drived : %0d",name, pkt_index);
	
	endfunction

endclass