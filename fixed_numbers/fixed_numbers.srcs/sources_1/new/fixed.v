`timescale 1ns / 1ps

/*
    The smallest fraction we can represent in Q4.4 is 1/16, so 3/256 can't be expressed. 
    Rather than use a larger precision we can scale the smaller number up. 
    If we multiply 3/256 by 26 we get 0.75, which comfortably fits within our precision. 
    Because we've multiplied one of our numbers by 26 we need to add this to the scaling factor, making it 2^10
*/

/*
    Q4.4 
        Range:      -8 to 7.9375 (7 + 15/16)
        Precision:  0.0625 (1/16)
        
    Q16.16
        Range:      -32768 to 32767.9999847...
        Precision:  0.0000152...

*/

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

    task fixed3;    // multiply + and +
        begin
            a = 8'b0011_0100;       // 3.2500
            b = 8'b0010_0001;       // 2.0625
            big_result = a * b;     // multiply to bigger container
            c = big_result[11:4];       // take middle 8 bits of 16 bits result
            $display("%f * %f = %f", $itor(a*SF), $itor(b*SF), $itor(c*SF));
        end
    endtask
    
    task fixed4;    // multiply + and +0.
        begin
            a = 8'b0111_1000;       // 7.5
            b = 8'b0000_1000;       // 0.5
            big_result = a * b;     // multiply to bigger container
            c = big_result[11:4];       // take middle 8 bits of 16 bits result
            $display("%f * %f = %f", $itor(a*SF), $itor(b*SF), $itor(c*SF));
        end
    endtask
    
    task fixed5;    // multiply + and -
        begin
            a = 8'b0010_0100;       // 2.25
            b = 8'b1110_1000;       // -1.5
            big_result = a * b;     // multiply to bigger container
            c = big_result[11:4];       // take middle 8 bits of 16 bits result
            $display("%f * %f = %f", $itor(a*SF), $itor(b*SF), $itor(c*SF));
        end
    endtask

    // --------------- Main loop -----------------
    initial 
        begin
            $display("Fixed Point Examples from projectf.io.");
            
            // ---- add ----
            fixed1();
            fixed2();
            // -- multiply --
            fixed3();
            fixed4();
            fixed5();
        end

endmodule
