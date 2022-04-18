`timescale 1ns / 1ps
import SystemVerilogCSP::*;


module Mem_block(interface packet_in, packet_out);

        Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [12:0] ();
        
        memory_wapper  wapper(.toMemRead(intf[0]), .toMemWrite(intf[1]), .toMemT(intf[2]), .toMemX(intf[3]), .toMemY(intf[4]), .toMemSendData(intf[5]), .fromMemGetData(intf[6]), .toNOC(packet_out), .fromNOC(packet_in));
        memory Mem(.read(intf[0]), .write(intf[1]), .T(intf[2]), .x(intf[3]), .y(intf[4]), .data_out(intf[6]), .data_in(intf[5]));

endmodule
