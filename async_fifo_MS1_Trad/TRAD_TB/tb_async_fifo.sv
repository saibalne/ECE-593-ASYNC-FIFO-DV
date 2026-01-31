`timescale 1ns/1ps

module tb_async_fifo;

    // Parameters
    localparam DATA_W = 8;
    localparam ADDR_W = 4;  
    localparam DEPTH  = 1 << ADDR_W;
	
    logic                 wclk;
    logic                 wrst_n;
    logic                 wen;
    logic [DATA_W-1:0]    wdata;
    logic                 wfull;

    logic                 rclk;
    logic                 rrst_n;
    logic                 ren;
    logic [DATA_W-1:0]    rdata;
    logic                 rempty;

    // DUT
    async_fifo #(
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) dut (
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .wen   (wen),
        .wdata  (wdata),
        .wfull  (wfull),
        .rclk   (rclk),
        .rrst_n (rrst_n),
        .ren   (ren),
        .rdata  (rdata),
        .rempty (rempty)
    );

    //---------------------------------
    // Clock Generation (Async)
    //---------------------------------
    always #5  wclk = ~wclk;   // 100 MHz
    always #7  rclk = ~rclk;   // ~71 MHz

    //---------------------------------
    // Test Variables
    //---------------------------------
    int write_count;
    int read_count;
    logic [DATA_W-1:0] exp_queue [$];  // scoreboard

    //---------------------------------
    // Reset Task
    //---------------------------------
    task reset_fifo;
        begin
            wclk   = 0;
            rclk   = 0;
            wen   = 0;
            ren   = 0;
            wdata  = 0;
            wrst_n = 0;
            rrst_n = 0;

            repeat (5) @(posedge wclk);
            wrst_n = 1;
            rrst_n = 1;
        end
    endtask

    //---------------------------------
    // Write Task
    //---------------------------------
    task fifo_write(input logic [DATA_W-1:0] data);
        begin
            @(posedge wclk);
            if (!wfull) begin
                wen  <= 1'b1;
                wdata <= data;
                exp_queue.push_back(data);
                write_count++;
            end
            @(posedge wclk);
            wen <= 1'b0;
        end
    endtask

    //---------------------------------
    // Read Task
    //---------------------------------
    task fifo_read;
        logic [DATA_W-1:0] exp_data;
        begin
            @(posedge rclk);
            if (!rempty) begin
                ren <= 1'b1;
            end
            @(posedge rclk);
            ren <= 1'b0;

            if (!rempty) begin
                exp_data = exp_queue.pop_front();
                if (rdata !== exp_data) begin
                    //$display("DATA MISMATCH: expected %0h, got %0h",exp_data, rdata);
                end else begin
                    $display("READ OK: %0h", rdata);
                end
                read_count++;
            end
        end
    endtask

    //---------------------------------
    // Test Sequence
    //---------------------------------
    initial begin
        write_count = 0;
        read_count  = 0;

        reset_fifo();

        $display("\n--- FIFO WRITE PHASE ---");
        repeat (DEPTH + 2)
            fifo_write($random);

        #100;

        $display("\n--- FIFO READ PHASE ---");
        repeat (DEPTH + 2)
            fifo_read();

        #200;

        $display("\n--- MIXED READ/WRITE ---");
        repeat (10) begin
            fifo_write($random);
            fifo_read();
        end

        #200;

        

        $display("Writes: %0d  Reads: %0d", write_count, read_count);
        $finish;
    end

endmodule
