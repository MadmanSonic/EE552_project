`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module switch(interface packet_in, interface O1, interface O2, interface O3, interface O4, interface O5);//O1 Y up, O2 Y down, O3 X right, O4 X left, O5 to PE  
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    logic [WIDTH-1:0] packet;
    //logic [1:0] Xsource, Xdest, Ysource, Ydest;
    logic [1:0] Xoffset, Yoffset;
    
    parameter in_type = 3'b0;
    parameter address_X = 2'b0;    //y
    parameter address_Y = 2'b0;    //y
    
    logic [3:0] address;
      
    always begin
        address = {address_X, address_Y};
        // Packet arrives to the switch
        packet_in.Receive(packet);
        #FL;
        
        //Xoffset = packet [31: 30] - address[3:2];
        //Yoffset = packet [29: 28] - address[1:0];
        
       if (packet [29: 28] > address[1:0])
            begin
            O1.Send(packet);
            end
        else if (packet [29: 28] < address[1:0])
                begin
                O2.Send(packet);
                end
        else if (packet [29: 28] == address[1:0])
                begin
                if(packet [31: 30] > address[3:2])
                    begin
                        O3.Send(packet);
                    end
                else if(packet [31: 30] < address[3:2])
                    begin
                        O4.Send(packet);
                    end
                else if(packet [31: 30] == address[3:2])
                    begin
                        O5.Send(packet);
                    end
                end
        #BL;
    end
endmodule
