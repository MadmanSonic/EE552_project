`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module NoC (interface PE_0010_i, PE_0110_i, PE_1010_i, PE_0001_i, PE_0101_i, PE_1001_i, PE_0000_i, PE_0100_i, PE_1000_i, memblock_i, PE_0010_o, PE_0110_o, PE_1010_o, PE_0001_o, PE_0101_o, PE_1001_o, PE_0000_o, PE_0100_o, PE_1000_o, memblock_o);

    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [45:0] (); 
    
    router #(.address_X(2'b00), .address_Y(2'b10)) R0010(.in_left(intf[0]), .in_right(intf[2]), .in_up(intf[4]), .in_down(intf[6]), .in_pe(PE_0010_i), .out_left(intf[1]), .out_right(intf[3]), .out_up(intf[5]), .out_down(intf[7]), .out_pe(PE_0010_o));
    router #(.address_X(2'b01), .address_Y(2'b10)) R0110(.in_left(intf[3]), .in_right(intf[8]), .in_up(intf[10]), .in_down(intf[12]), .in_pe(PE_0110_i), .out_left(intf[2]), .out_right(intf[9]), .out_up(intf[11]), .out_down(intf[13]), .out_pe(PE_0110_o));
    router #(.address_X(2'b10), .address_Y(2'b10)) R1010(.in_left(intf[9]), .in_right(intf[14]), .in_up(intf[16]), .in_down(intf[18]), .in_pe(PE_1010_i), .out_left(intf[8]), .out_right(intf[15]), .out_up(intf[17]), .out_down(intf[19]), .out_pe(PE_1010_o));
    router #(.address_X(2'b00), .address_Y(2'b01)) R0001(.in_left(intf[20]), .in_right(intf[22]), .in_up(intf[7]), .in_down(intf[24]), .in_pe(PE_0001_i), .out_left(intf[21]), .out_right(intf[23]), .out_up(intf[6]), .out_down(intf[25]), .out_pe(PE_0001_o));
    router #(.address_X(2'b01), .address_Y(2'b01)) R0101(.in_left(intf[23]), .in_right(intf[26]), .in_up(intf[13]), .in_down(intf[28]), .in_pe(PE_0101_i), .out_left(intf[22]), .out_right(intf[27]), .out_up(intf[12]), .out_down(intf[29]), .out_pe(PE_0101_o));
    router #(.address_X(2'b10), .address_Y(2'b01)) R1001(.in_left(intf[27]), .in_right(memblock_i), .in_up(intf[19]), .in_down(intf[30]), .in_pe(PE_1001_i), .out_left(intf[26]), .out_right(memblock_o), .out_up(intf[18]), .out_down(intf[31]), .out_pe(PE_1001_o));
    router #(.address_X(2'b00), .address_Y(2'b00)) R0000(.in_left(intf[32]), .in_right(intf[34]), .in_up(intf[25]), .in_down(intf[36]), .in_pe(PE_0000_i), .out_left(intf[33]), .out_right(intf[35]), .out_up(intf[24]), .out_down(intf[37]), .out_pe(PE_0000_o));
    router #(.address_X(2'b01), .address_Y(2'b00)) R0100(.in_left(intf[35]), .in_right(intf[38]), .in_up(intf[29]), .in_down(intf[40]), .in_pe(PE_0100_i), .out_left(intf[34]), .out_right(intf[39]), .out_up(intf[28]), .out_down(intf[41]), .out_pe(PE_0100_o));
    router #(.address_X(2'b10), .address_Y(2'b00)) R1000(.in_left(intf[39]), .in_right(intf[42]), .in_up(intf[31]), .in_down(intf[44]), .in_pe(PE_1000_i), .out_left(intf[38]), .out_right(intf[43]), .out_up(intf[30]), .out_down(intf[45]), .out_pe(PE_1000_o));

//router (interface in_left,interface in_right,interface in_up,interface in_down,interface in_pe,interface out_left,interface out_right,interface out_up,interface out_down,interface out_pe );


endmodule
