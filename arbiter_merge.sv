`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module arbiter_merge_two(Channel R1, Channel R2, Channel O);

    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 2;
    logic [WIDTH-1: 0] data_R1, data_R2;
   
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(1)) S1();
    
    //arbiter(R1,R2, O)
    arbiter #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) two_ab(.R1(R1), .R2(R2), .O(S1));
    
    //merge(A,B,S,O)
    merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) two_mg(.A(R1),.B(R2),.S(S1),.O(O));
       
endmodule

/*module arbiter_merge_four(Channel A, Channel B, Channel C, Channel D, interface O);

    parameter WIDTH = 33;
    parameter FL = 3;
    parameter BL = 3;
    
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) S1();
    Channel #(.hsProtocol(P4PhaseBD),.WIDTH(33)) S2();
    
    //arbiter_merge(R1,R2, O)
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg1(.R1(A), .R2(B), .O(S1));
    
    //arbiter_merge(R1,R2, O)
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg2(.R1(C), .R2(D), .O(S2));
    
    arbiter_merge_two #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) abmg3(.R1(S1), .R2(S2), .O(O));
    
endmodule*/