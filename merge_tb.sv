`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module merge_tb();
    //Interface Vector instatiation: 4-phase bundled data channel
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) A();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) B();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(1)) S();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33))  O();
    
    //select line data generator
    
    parameter WIDTH = 33;
    logic [WIDTH-1:0] data_A = 0;
    logic [WIDTH-1:0] data_B = 0;
    logic [WIDTH-1:0] out = 0;
    logic sel = 0;
    
    integer k;
        
    merge #(.WIDTH(33), .FL(4), .BL(6)) mg(.A(A),.B(B),.S(S),.O(O));
    
    initial 
        begin
        
        $display("Random Testing for 2 Input Merge");
        k = 0;
        while ( k < 12)
            begin
                data_A = $random()%64;
                data_B = $random()%64;
                sel = $random()%2;
                #5;
                    fork
                        S.Send(sel);
                        A.Send(data_A);
                        B.Send(data_B);
                        O.Receive(out);
                        if (sel == 0)
                            begin
                                B.Receive(data_B);
                                
                            end
                        else
                            begin
                                A.Receive(data_A);
                            end
                    join
                    #25;
                    $display("A = %d, B = %d, Sel = %d, out = %d", data_A, data_B, sel, out);
                k++;
           end
           $display("Compilation Succeeds!");
        end  
endmodule
