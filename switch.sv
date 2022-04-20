`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module switch(Channel I, Channel O1, Channel O2, Channel O3, Channel O4, Channel O5);
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    logic [WIDTH-1:0] packet;
    //logic [1:0] Xsource, Xdest, Ysource, Ydest;
    logic [1:0] Xoffset, Yoffset;
    
    parameter in_type = 3'b0;
    parameter address_0 = 0;    //y
    parameter address_1 = 0;    //y
    parameter address_2 = 0;    //x
    parameter address_3 = 0;    //x
    
    logic [3:0] address;
      
    always begin
        address = {address_3, address_2, address_1, address_0};
        // Packet arrives to the switch
        I.Receive(packet);
        #FL;
        
        Xoffset = packet [WIDTH-2: WIDTH-3] - address[3:2];
        Yoffset = packet [WIDTH-4: WIDTH-5] - address[1:0];
        
        if(in_type == 3'b0) //from North
        begin
            if ((Xoffset == 0) && (Yoffset == 0))
                O5.Send(packet);    // packet reaches the destination
            else if (Yoffset < 0)
                O3.Send(packet);    //heading to the south
            else if (Xoffset > 0)
                O2.Send(packet);    //heading to the east
            else if (Xoffset < 0)
                O1.Send(packet);    //heading to the west
        end
        
        else if (in_type == 3'b001) //from East
        begin
            if ((Xoffset == 0) && (Yoffset == 0))
                O5.Send(packet);
            else if (Yoffset > 0)
                O4.Send(packet);    //heading to the north
            else if (Yoffset < 0)
                O3.Send(packet);    //heading to the south
            else if (Xoffset < 0)
                O1.Send(packet);    //heading to the west
        end
        
        else if (in_type == 3'b010) //From South
        begin
            if ((Xoffset == 0) && (Yoffset == 0))
                O5.Send(packet);
           else if (Yoffset > 0)
                O4.Send(packet);    //heading to the north
            else if (Xoffset > 0)
                O2.Send(packet);    //heading to the east
            else if (Xoffset < 0)
                O1.Send(packet);    //heading to the west
        end
        
        else if (in_type == 3'b011) // From West
        begin
            if ((Xoffset == 0) && (Yoffset == 0))
                O5.Send(packet);
           else if (Yoffset > 0)
                O4.Send(packet);    //heading to the north
            else if (Yoffset < 0)
                O3.Send(packet);    //heading to the south
            else if (Xoffset > 0)
                O2.Send(packet);    //heading to the east
        end
        
       else if (in_type == 3'b100)
        begin
            if ((Xoffset == 0) && (Yoffset == 0))
                O5.Send(packet);
           else if (Yoffset > 0)
                O4.Send(packet);    //heading to the north
            else if (Yoffset < 0)
                O3.Send(packet);    //heading to the south
            else if (Xoffset > 0)
                O2.Send(packet);    //heading to the east
            else if (Xoffset < 0)
                O1.Send(packet);    //heading to the west
        end
        
        #BL;
    end
endmodule



