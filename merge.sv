`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module merge(Channel A, Channel B, Channel S, Channel O);
    
    parameter WIDTH = 33;
    logic sel;
    parameter FL = 4;
    parameter BL = 6;
    logic [WIDTH-1:0] data_A, data_B, out;
       
    always begin
        S.Receive(sel);

        #FL;
        if(sel == 0)
            begin          
                A.Receive(data_A);
                O.Send(data_A);
                //$display("The data A = %d, The data B = %d, The Select value S = %d, The output = %d", data1, data2, sel, data1);
            end
        if (sel == 1)
            begin
                B.Receive(data_B);           
                O.Send(data_B);
                //$display("The data A = %d, The data B = %d, The Select value S = %d, The output = %d", data1, data2, sel, data2);
            end
       #BL;                                     
    end
endmodule
