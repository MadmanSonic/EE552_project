`timescale 1ns / 1ns

import SystemVerilogCSP::*;

module arbiter_tb();
    //Interface Vector instatiation: 4-phase bundled data channel
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R1();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R2();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(1))  O();
    
    //select line data generator
    
    parameter WIDTH = 33;
    logic [WIDTH-1:0] Req1 = 0;
    logic [WIDTH-1:0] Req2 = 0;
    logic sel=0;
    
    integer k;
        
    arbiter #(.WIDTH(33), .FL(4), .BL(2)) ab1(.R1(R1),.R2(R2),.O(O));
    
    initial 
        begin
        $display("Request 1 Testing");
        Req1 = 1;
        Req2 = 2;
        #5;
        fork
            R1.Send(Req1);
            O.Receive(sel);
        #5;
            R1.Receive(Req1);
        join
        $display("Req 1 has access, sel = %d", sel);
    
    
        $display("Request 2 Testing");
        Req1 = 1;
        Req2 = 2;
        #5;
        fork
            R2.Send(Req2);
            O.Receive(sel);
        #5;
            R2.Receive(Req2);
        join   
        $display("Req 2 has access, sel = %d", sel);
    
        $display("Random Testing for Arbiter");
        k = 0;
        while ( k < 30)
            begin
                Req1 = 1;
                Req2 = 2;
                #5;
                    fork
                        R1.Send(Req1);
                        R2.Send(Req2);
                        O.Receive(sel);
                #5;
                        R1.Receive(Req1);
                        R2.Receive(Req2);
                    join
                    $display("Req %d has access, sel = %d", sel+1, sel);
                k++;
           end
        end  
endmodule
