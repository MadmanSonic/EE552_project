`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module switch_tb;

    parameter FL = 2;
    parameter BL = 1;
    parameter WIDTH = 33;
    parameter address = 4'b0101;
    parameter input_type = 3'b0;    // 0 means input North, 1 means input East, 2 means input South, 3 means input West, 4 means input from PE
    
  /* Packet Info
   [32]:ifm/filt
   [31:28]: destination address
   [27:24]: source address
   [23:0]: Data info*/
    
    
    logic [WIDTH-1:0] packet = 33'b100100101110100101110010110111000;
    logic [WIDTH-1:0] packet1 = 33'b0;
    logic [WIDTH-1:0] packet2 = 33'b0;
    logic [WIDTH-1:0] packet3 = 33'b0;
    logic [WIDTH-1:0] packet4 = 33'b0;
    logic [WIDTH-1:0] packet5 = 33'b0;

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) In [0:4] ();
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) Out [0:19] ();
    
    //Testing for the input from North
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0101), .in_type(3'b000)) N_in(In[0], Out[0], Out[1], Out[2], Out[3]);
			
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0101), .in_type(3'b001)) E_in(In[1], Out[4], Out[5], Out[6], Out[7]);
    
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0101), .in_type(3'b010)) S_in(In[2], Out[8], Out[9], Out[10], Out[11]);
     
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0101), .in_type(3'b011)) W_in(In[3], Out[12], Out[13], Out[14], Out[15]);
    
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(4'b0101), .in_type(3'b100)) PE_in(In[4], Out[16], Out[17], Out[18], Out[19]);  
    integer k;
    
    initial
    begin
    
        #5;
        In[0].Send(packet);
        fork
            Out[0].Receive(packet1);
            Out[1].Receive(packet1);
            Out[2].Receive(packet1);
            Out[3].Receive(packet1);
        join
        
        $display("Packet with the destination 0010 sent with the address 0101 input from the North and Received by out[%d]. The received value = %b", , packet1);
    
        #5;
        In[1].Send(packet);
        fork
            Out[4].Receive(packet2);
            Out[5].Receive(packet2);
            Out[6].Receive(packet2);
            Out[7].Receive(packet2);
        join
        
        $display("Packet with the destination 0010 sent with the address 0101 input from the East and Received by out[%d]. The received value = %b",  , packet2);
    
        #5;
        In[2].Send(packet);
        fork
            Out[8].Receive(packet3);
            Out[9].Receive(packet3);
            Out[10].Receive(packet3);
            Out[11].Receive(packet3);
        join
        
        $display("Packet with the destination 0010 sent with the address 0101 input from the South and Received by out[%d]. The received value = %b",  , packet3);
        #5;
        In[3].Send(packet);
        fork
            Out[12].Receive(packet4);
            Out[13].Receive(packet4);
            Out[14].Receive(packet4);
            Out[15].Receive(packet4);
        join
        
        $display("Packet with the destination 0010 sent with the address 0101 input from the West and Received by out[%d]. The received value = %b",  , packet4);
    
        #5;
        In[4].Send(packet);
        fork
            Out[16].Receive(packet5);
            Out[17].Receive(packet5);
            Out[18].Receive(packet5);
            Out[19].Receive(packet5);
        join
        
        $display("Packet with the destination 0010 sent with the address 0101 input from the PE and Received by out[%d]. The received value = %b",   , packet5);
    end  
endmodule
