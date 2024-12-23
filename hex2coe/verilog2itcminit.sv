//=====================================================================
// 
// Description:
//  As .verilog file cannot fill all 64KB ITCM
//  This module will first fill ITCM with all ones,
//      then use .verilog to init ITCM
//  After that, this module will generate .itcminit file
//      which can replace .verilog file in $readmemh()
//
// ====================================================================

`timescale 1ns/1ps

module verilog2itcminit();

    integer i,j,k;
    integer fd_write;
    string  FILE_NAME;  // system verilog data type
    string  READ_FILE_NAME;
    string  WRITE_FILE_NAME;
    reg [7:0] itcm_mem [0:65535]; // 524288 bits, 64KB

    initial begin
        FILE_NAME = "irun_final_test";
        $sformat(READ_FILE_NAME,"D:/ICAIS/projects/IBEXIII/DC/e203_v7/cpu_testcases/%s/%s.verilog",FILE_NAME,FILE_NAME);
        $sformat(WRITE_FILE_NAME,"D:/ICAIS/projects/IBEXIII/DC/e203_v7/cpu_testcases/%s/%s.itcminit",FILE_NAME,FILE_NAME);
        for(i=0; i<65536; i=i+1) begin
            itcm_mem[i] = 8'b1111_1111;
        end
        $readmemh(READ_FILE_NAME, itcm_mem);
        fd_write = $fopen(WRITE_FILE_NAME,"w");
        for(i=0; i<65536; i=i+1) begin
            $fdisplay(fd_write, "%x", itcm_mem[i]);
        end
        $display("DONE");
        $stop;
    end

endmodule
