`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module router(Channel N_in, Channel E_in, Channel S_in, Channel W_in, Channel PE_in, Channel N_out, Channel E_out, Channel S_out, Channel W_out, Channel PE_out);

parameter FL = 2;
parameter BL = 1;
parameter WIDTH = 33;
parameter address_0 = 0;
parameter address_1 = 0;
parameter address_2 = 0;
parameter address_3 = 0;

    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) CH[19:0] ();
    
    //switch(I, O1, O2, O3, O4, O5)
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(address_0), .address_1(address_1), .address_2(address_2), .address_3(address_3), .in_type(000)) N_switch(.I(N_in), .O1(CH[0]), .O2(CH[1]), .O3(CH[2]), .O4(CH[3]));
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(address_0), .address_1(address_1), .address_2(address_2), .address3(address_3), .in_type(001)) E_switch(.I(E_in), .O1(CH[4]), .O2(CH[5]), .O3(CH[6]), .O4(CH[7]));
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(address_0), .address_1(address_1), .address_2(address_2), .address3(address_3), .in_type(010)) S_switch(.I(S_in), .O1(CH[8]), .O2(CH[9]), .O3(CH[10]), .O4(CH[11]));
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(address_0), .address_1(address_1), .address_2(address_2), .address3(address_3), .in_type(011)) W_switch(.I(W_in), .O1(CH[12]), .O2(CH[13]), .O3(CH[14]), .O4(CH[15]));
    switch #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(address_0), .address_1(address_1), .address_2(address_2), .address3(address_3), .in_type(100)) PE_switch(.I(PE_in), .O1(CH[16]), .O2(CH[17]), .O3(CH[18]), .O4(CH[19]));

    //arbiter_merge_four(A,B,C,D,O)
    arbiter_merge_four #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) N_abmg(.A(CH[4]), .B(CH[8]), .C(CH[12]), .D(CH[16]), .O(N_out));
    arbiter_merge_four #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) E_abmg(.A(CH[0]), .B(CH[9]), .C(CH[13]), .D(CH[17]), .O(E_out));
    arbiter_merge_four #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) S_abmg(.A(CH[1]), .B(CH[5]), .C(CH[14]), .D(CH[18]), .O(S_out));
    arbiter_merge_four #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) W_abmg(.A(CH[3]), .B(CH[7]), .C(CH[11]), .D(CH[19]), .O(W_out));
    arbiter_merge_four #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) PE_abmg(.A(CH[2]), .B(CH[6]), .C(CH[10]), .D(CH[15]), .O(PE_out));
    
    
endmodule

