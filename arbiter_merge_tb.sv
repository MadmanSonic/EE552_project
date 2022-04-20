`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module arbiter_merge_tb();
    
    //Interface Vector instatiation: 4-phase bundled data channel
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R1();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R2();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33))  O();
    
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 2;
    logic [WIDTH-1: 0] data_R1 = 0;
    logic [WIDTH-1: 0] data_R2 = 0;
    logic [WIDTH-1: 0] out = 0;
    logic [WIDTH-1: 0] winner = 0;
    
    integer k;
    
    arbiter_merge_two #(.WIDTH(33), .FL(FL), .BL(BL)) abmg(.R1(R1), .R2(R2), .O(O));
    
    initial
        begin

        $display("Testing for Input R1");
        data_R1 = $random()%64;
        data_R2 = $random()%64;
        #10; 
        fork
            R1.Send(data_R1);
            O.Receive(out);
        join
        $display("R1 = %d, R2 = %d, Out = %d", data_R1, data_R2, out);	


      $display("Testing for Input R2");
            data_R1 = $random()%64;
            data_R2 = $random()%64;
            #10; 
            fork
                R2.Send(data_R2);
                O.Receive(out);
            join
            $display("R1 = %d, R2 = %d, Out = %d", data_R1, data_R2, out);
      
      $display("Testing for Random Input");
      
      k = 0;
      while(k < 15)
        begin
            data_R1 = $random()%64;
            data_R2 = $random()%64;
            #5; 
            fork
               R1.Send(data_R1);
               R2.Send(data_R2);
               O.Receive(out);
            join
            O.Receive(winner);
            $display("R1 = %d, R2 = %d, 1st Out = %d, 2nd Out = %d", data_R1, data_R2, out, winner);
            k++;
        end
     end
endmodule
