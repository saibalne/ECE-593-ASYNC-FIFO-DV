package async_pkg;
    parameter ADDR_W = 9;
    parameter DATA_W = 8;
	parameter BURST_LENGTH = 450;
	
	parameter M_VAL = 1;
    parameter N_VAL = 2;
	
    `include "async_trnx.sv"

    function void print_info(string parent, string format);
        $display("[%0s][%0t] %0s",parent,$time,format);
    endfunction

endpackage