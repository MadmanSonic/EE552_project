`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module arbiter_merge_two(Channel R1, Channel R2, Channel O);

    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
   
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(WIDTH)) intf  [1:0] ();
    
    //arbiter(R1,R2, O)
    arbiter #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) two_ab(.R1(R1), .R2(R2), .O(intf[0]));
    
    //merge(A,B,S,O)
    merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) two_mg(.A(R1), .B(R2), .S(intf[0]), .O(O));
       
endmodule

module arbiter_merge_four(interface A, interface B, interface C, interface D, interface O);
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) intf  [1:0] ();
    
    //arbiter_merge(R1,R2, O)
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg1(.R1(A), .R2(B), .O(intf[0]));
    
    //arbiter_merge(R1,R2, O)
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg2(.R1(C), .R2(D), .O(intf[1]));
    
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg3(.R1(intf[0]), .R2(intf[1]), .O(O));
    
endmodule
