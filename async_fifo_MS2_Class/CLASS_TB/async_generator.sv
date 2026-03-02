
import async_pkg::*;
class async_generator;
    
    //import async_pkg::*;

    int num_of_packets;
    int pkt_index = 0;
    async_trnx pkt;
	async_trnx new_pkt;
    
	int num_burst;
	int burst_id;
	
	mailbox #(async_trnx) mbx;
    string name = "GENERATOR";

    function new(mailbox #(async_trnx) mbx, bit [31:0] num_of_packets);
        this.mbx = mbx;
		this.num_of_packets = num_of_packets;
		num_burst = 50;
    endfunction

    function void build();
        pkt = new();
		pkt.kind = DRIVE;
    endfunction

    function async_trnx generate_reset_trnx();
        async_trnx temppkt = new();
        temppkt.kind = RESET;
        return temppkt;
    endfunction

	task generate_single_packet();
		
		void'(pkt.randomize());
		new_pkt = new();
		new_pkt.copy(pkt);
		new_pkt.kind = DRIVE;
		mbx.put(new_pkt);
		if(pkt_index%100==0) begin
		print_info(name,$sformatf("Generated packet %0d", pkt_index));
		print_info(name,new_pkt.get_write_info());
		end
	endtask
	
	task generate_reset_packet();
		async_trnx resetpkt;
		resetpkt = generate_reset_trnx();
        print_info(name,$sformatf("Reset Packet Generated %0d", pkt_index));
		mbx.put(resetpkt);
	endtask
	
    task run();
		
        build();
		generate_reset_packet();
        repeat(num_of_packets) begin
            
			generate_single_packet();
            pkt_index++;
        end
		
		for(int idx =0;idx<num_burst;idx++) begin
			for(int bidx=0;bidx< BURST_LENGTH;bidx++) begin
				void'(pkt.randomize());
				new_pkt = new();
				new_pkt.copy(pkt);
				new_pkt.wen = 1;
				new_pkt.ren = 1;
				mbx.put(new_pkt);
			end
			burst_id++;
			//generate_reset_packet();
			
		end
		

		$display("%0s completed",name);
    endtask
	
	
	function void report();
		$display("%0s  ---- Report ----",name);
        $display("%0s  Generated Transaction Count : %0d",name, pkt_index);
	endfunction

endclass