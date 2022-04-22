`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module merge(Channel A, Channel B, Channel S, Channel O);    
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    logic sel;
    logic [WIDTH-1:0] data, out;
      
    always begin
        S.Receive(sel);
        if(sel == 0)
            begin          
                A.Receive(data);
             end
        else if (sel == 1)
            begin
                B.Receive(data);           
            end
        #FL;   
        O.Send(data);
        #BL;                                    
    end
endmodule
