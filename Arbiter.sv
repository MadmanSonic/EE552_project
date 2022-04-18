`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module arbiter(Channel R1, Channel R2, Channel O);
    
    parameter WIDTH = 33;
    parameter FL = 4;
    parameter BL = 2;
    logic [WIDTH-1: 0] Request1, Request2;
    logic sel;
    
    always begin
    
        wait((R1.status!=idle)||(R2.status!=idle));
        // if randomly selected, the arbiter will send 0 for R1 and 1 for R2
        if((R1.status!=idle)&&(R2.status!=idle))
            begin
            sel = $random()%2;
                if(sel == 0)
	               begin
	                   R1.Receive(Request1);
	                   O.Send(0);	   
	               end
	           else
	               begin
                    R2.Receive(Request2);
                    O.Send(1);
	               end
             end
             
        //if R1 get selected, the arbiter will send 0     
        else if (R1.status!=idle)
            begin
                R1.Receive(Request1);
	            O.Send(0);
            end	
        
        // if R2 gets selected, the arbiter will send 1      
        else if(R2.status!=idle)
            begin 
                R2.Receive(Request2);
                O.Send(1);
            end
        /*case((R1.status != idle) || (R2.status != idle))
        
            (R1.status != idle):begin
                                     R1.Receive(Request1);
                                     O.Send(0);
                                end                      
             
            (R2.status != idle):begin
                                    R2.Receive(Request2);
                                    O.Send(1);
                                end
             
            ((R1.status!=idle)&&(R2.status!=idle)): begin
                                                        sel = $random() % 2;
                                                        if(sel == 0)
                                                            begin
                                                                R1.Receive(Request1);
                                                                O.Send(sel);
                                                            end
                                                        else
                                                            begin
                                                                R2.Receive(Request2);
                                                                O.Send(sel);
                                                            end   
                                                    end    
                        
          endcase*/
    end     
endmodule
