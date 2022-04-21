`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module merge(Channel A, Channel B, Channel S, Channel O);
    
    parameter WIDTH = 33;
    logic sel;
    parameter FL = 4;
    parameter BL = 6;
    logic [WIDTH-1:0] data, out;
      
    always begin
        S.Receive(sel);
        if(sel == 0)
            begin          
                A.Receive(data);
             end
        else
            begin
                B.Receive(data);           
            end
        #FL;   
        O.Send(data);
        #BL;
                                    
    end
endmodule
