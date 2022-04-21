`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module arbiter_merge_tb();
    
    //Interface Vector instatiation: 4-phase bundled data channel
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R1();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) R2();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33))  O();
    //Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33))  db();
    
        
    
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 2;
    logic [WIDTH-1: 0] data_R1 = 0;
    logic [WIDTH-1: 0] data_R2 = 0;
    logic [WIDTH-1: 0] out = 0;
    logic [WIDTH-1: 0] winner = 0;
    
    integer k;
    
    arbiter_merge_two #(.WIDTH(33), .FL(FL), .BL(BL)) abmg(.R1(R1), .R2(R2), .O(O));
    data_bucket db(.r(O));
    
    initial
        begin

        $display("Testing for Input R1");
        data_R1 = $random()% 16;
        #10; 
        R1.Send(data_R1);   
        #20;

      $display("Testing for Input R2");
      data_R2 = $random()% 16;
      #10; 
      R2.Send(data_R2);
      #20;
      
      $display("Testing for Random Input");
      
      k = 0;
      while(k < 30)
        begin
            data_R1 = $random()% 16;
            data_R2 = $random()% 16;
            #5; 
            fork
               R1.Send(data_R1);
               R2.Send(data_R2);
            join
            k++;
        end
     end
endmodule
