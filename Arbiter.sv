`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module arbiter(Channel R1, Channel R2, Channel O);
    
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    logic [WIDTH-1: 0] Request1, Request2;
    logic sel;
    integer check1 = 1;
    
    always begin
        
        wait((R1.status!=idle)||(R2.status!=idle));
        // if randomly selected, the arbiter will send 0 for R1 and 1 for R2
        if((R1.status!=idle)&&(R2.status!=idle))
            begin
            if (check1 != 0)
	           begin
               //$display("R1 wins, sending 0");
	            O.Send(0);
	            check1 = 0;
   	            $display("R1 wins, sent 0 complete");  	             
	           end
	        else if (check1 == 0)
	           begin
               //$display("R2 wins, sending 1");
               O.Send(1);
               check1 = 1;
               $display("R2 wins, sent 1 complete");
	           end
            end
             
        //if R1 get selected, the arbiter will send 0     
        else if (R1.status!=idle)
            begin
              //  R1.Receive(Request1);
              //$display("R1 wins, sending 0");
            O.Send(0);
            check1 = 0;
            $display("R1 wins, sent 0 complete");
            end	        
        // if R2 gets selected, the arbiter will send 1      
        else if(R2.status!=idle)
            begin 
            O.Send(1);
            check1 = 1;
            $display("R2 wins, sent 1 complete");
            end
            #BL;           
        end     
endmodule
