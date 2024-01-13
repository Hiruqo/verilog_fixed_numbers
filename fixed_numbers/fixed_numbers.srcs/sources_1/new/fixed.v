`timescale 1ns / 1ps

module fixed();

/*
To express the number of integer and fractional bits we use Q number format: Qi.f 
where i is the number of integer bits and f is the number of fractional bits.
--> 0100.1100 has four integer and four fractional bits, so is Q4.4. <--
*/

reg signed [7:0] a, b, c;  // 0000.0000  -->  8 4 2 1 . 0.5 0.25 0.125 0.0625
reg signed [15:0] big_result;

localparam SF = 2.0**-4.0;  // Q4.4 scaling factor is 2^-4

    task fixed1;    // add + and +
        begin
            a = 8'b0011_1010;   // 3.6250
            b = 8'b0100_0001;   // 4.0625
            c = a + b;          // 0111.1011 = 7.6875
            $display("%f + %f = %f", $itor(a*SF), $itor(b*SF), $itor(c*SF));    // display with correction
        end
    endtask
    
    task fixed2;    // add + and -
        begin
            a = 8'b0011_1010;   // 3.625
            b = 8'b1110_1000;   // -1.5
            c = a + b;
            $display("%f + %f = %f", $itor(a*SF), $itor(b*SF), $itor(c*SF));
        end
    endtask


    // --------------- Main loop -----------------
    initial begin
        $display("Fixed Point Examples from projectf.io.");
        
        fixed1();
        fixed2();
        
    end

endmodule
