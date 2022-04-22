`timescale 1ns/100ps
import SystemVerilogCSP::*;

module router (interface in_left,interface in_right,interface in_up,interface in_down,interface in_pe,interface out_left,interface out_right,interface out_up,interface out_down,interface out_pe );

parameter FL=2;
parameter BL=1;
parameter WIDTH=33;
parameter address_X=2'b00;
parameter address_Y=2'b00;

Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) intf  [24:0] (); 

switch  #(.address_X(address_X), .address_Y(address_Y)) S_up(.packet_in(in_up), .O2(intf[0]), .O3(intf[1]), .O4(intf[2]), .O5(intf[3]), .O1(intf[20]));
arbiter_merge_four  am_up(.A(intf[12]), .B(intf[4]), .C(intf[16]), .D(intf[8]), .O(out_up));

switch  #(.address_X(address_X), .address_Y(address_Y)) S_down(.packet_in(in_down), .O1(intf[4]), .O3(intf[5]), .O4(intf[6]), .O5(intf[7]), .O2(intf[21]));
arbiter_merge_four  am_down(.A(intf[17]), .B(intf[9]), .C(intf[0]), .D(intf[13]), .O(out_down));

switch  #(.address_X(address_X), .address_Y(address_Y)) S_left(.packet_in(in_left), .O1(intf[8]), .O2(intf[9]), .O3(intf[10]), .O5(intf[11]), .O4(intf[22]));
arbiter_merge_four  am_left(.A(intf[2]), .B(intf[14]), .C(intf[6]), .D(intf[19]), .O(out_left));

switch  #(.address_X(address_X), .address_Y(address_Y)) S_right(.packet_in(in_right), .O1(intf[12]), .O2(intf[13]), .O4(intf[14]), .O5(intf[15]), .O3(intf[23]));
arbiter_merge_four  am_right(.A(intf[5]), .B(intf[18]), .C(intf[10]), .D(intf[1]), .O(out_right));

switch  #(.address_X(address_X), .address_Y(address_Y)) S_PE(.packet_in(in_pe), .O1(intf[16]), .O2(intf[17]), .O3(intf[18]), .O4(intf[19]), .O5(intf[24]));
arbiter_merge_four  am_pe(.A(intf[11]), .B(intf[3]), .C(intf[15]), .D(intf[7]), .O(out_pe));

//arbiter_merge_four(interface A, interface B, interface C, interface D, interface O);//ABCD count from left to right
//switch(Channel packet_in, Channel O1, Channel O2, Channel O3, Channel O4, Channel O5);//O1 Y up, O2 Y down, O3 X right, O4 X left, O5 to PE 

endmodule
